#!/usr/bin/env python3
"""Build the Medicare Part D for All proposal page from its Word source.

Usage:
    python3 tools/build-proposal.py [path/to/proposal.docx]

Requires pandoc (https://pandoc.org). The .docx is the source of truth:
edit it, re-run this script, and commit both files. The script converts the
document to HTML, turns bracketed citations such as [7] or [8, 9] into links
to the numbered sources, builds a table of contents, and writes index.html and a
Markdown copy next to the .docx.

Document conventions it relies on:
  * Word "Title" and "Subtitle" styles for the title and subtitle.
  * Paragraphs before the first Heading 1: author line, then
    "Policy proposal | November 2026" (kind | date).
  * Heading 1 for each section; a final section titled "Sources" whose
    entries are "[N] citation text" paragraphs, each followed by a link.
"""
import html
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DOCX = ROOT / "policy" / "medicare-part-d-for-all" / "Medicare_Part_D_for_All_Proposal.docx"
SITE = "https://openhealth.org"
DRAFT = True            # set False when the text is final; removes the "Working draft" label
WORDS_PER_MINUTE = 230

MONTHS = {m: i for i, m in enumerate(
    ["january", "february", "march", "april", "may", "june", "july",
     "august", "september", "october", "november", "december"], start=1)}


def pandoc(*args):
    return subprocess.run(["pandoc", *args], check=True, capture_output=True, text=True).stdout


def read_meta(docx):
    with tempfile.TemporaryDirectory() as d:
        tpl = Path(d) / "meta.html"
        tpl.write_text("$title$\n$subtitle$\n")
        out = pandoc(str(docx), "-t", "html", "--template", str(tpl))
    lines = (out + "\n").split("\n")
    return lines[0].strip(), lines[1].strip()


def strip_tags(s):
    return html.unescape(re.sub(r"<[^>]+>", "", s))


def link_citations(body):
    def repl(m):
        nums = [n.strip() for n in m.group(1).split(",")]
        links = ", ".join(f'<a href="#src-{n}">{n}</a>' for n in nums)
        return f'<sup class="cite">[{links}]</sup>'
    return re.sub(r"\s*\[(\d+(?:\s*,\s*\d+)*)\]", repl, body)


def demote(body):
    body = re.sub(r"<(/?)h3\b", r"<\1h4", body)
    return re.sub(r"<(/?)h2\b", r"<\1h3", body)


def host(url):
    return re.sub(r"^www\.", "", urlparse(url).netloc)


def parse_sources(body):
    pat = re.compile(r"<p>\[(\d+)\]\s*(.*?)</p>\s*(?:<p><a href=\"([^\"]+)\">.*?</a></p>)?", re.S)
    return [(int(n), text.strip(), url) for n, text, url in pat.findall(body)]


def build(docx):
    docx = Path(docx)
    title, subtitle = read_meta(docx)
    frag = pandoc(str(docx), "-t", "html", "--wrap=none")

    parts = re.split(r'<h1 id="([^"]+)">(.*?)</h1>', frag, flags=re.S)
    front = parts[0]
    sections = [(parts[i], parts[i + 1].strip(), parts[i + 2]) for i in range(1, len(parts), 3)]

    front_paras = [strip_tags(p).strip() for p in re.findall(r"<p>(.*?)</p>", front, re.S)]
    author = front_paras[0] if front_paras else "Jonathan A. Borden, MD"
    kind, _, date_text = (front_paras[1] if len(front_paras) > 1 else "Policy proposal").partition("|")
    kind, date_text = kind.strip(), date_text.strip()

    sources = []
    body_sections = []
    for sid, heading, body in sections:
        if strip_tags(heading).strip().lower() == "sources":
            sources = parse_sources(body)
        else:
            body_sections.append((sid, heading, demote(link_citations(body))))

    words = sum(len(strip_tags(b).split()) for _, _, b in body_sections)
    minutes = max(1, round(words / WORDS_PER_MINUTE))

    summary_src = next((b for sid, _, b in body_sections if sid == "executive-summary"), body_sections[0][2])
    first_para = strip_tags(re.search(r"<p>(.*?)</p>", summary_src, re.S).group(1))
    description = re.split(r"(?<=\.)\s", first_para.strip(), maxsplit=1)[0]

    m = re.match(r"([A-Za-z]+)\s+(\d{4})", date_text)
    iso_date = f"{m.group(2)}-{MONTHS[m.group(1).lower()]:02d}" if m and m.group(1).lower() in MONTHS else ""

    slug_dir = docx.parent.name
    canonical = f"{SITE}/policy/{slug_dir}/"
    docx_url = f"{canonical}{docx.name}"

    toc_items = "\n".join(
        f'          <li class="nav-item"><a class="nav-link" href="#{sid}">{heading}</a></li>'
        for sid, heading, _ in body_sections
    )
    if sources:
        toc_items += '\n          <li class="nav-item"><a class="nav-link" href="#sources">Sources</a></li>'

    sections_html = "\n".join(
        f'      <section id="{sid}">\n        <h2>{heading}</h2>\n{body.strip()}\n      </section>'
        for sid, heading, body in body_sections
    )
    sources_html = ""
    if sources:
        items = "\n".join(
            f'          <li id="src-{n}" value="{n}">{text}'
            + (f' <a href="{html.escape(url)}" rel="noopener">{host(url)}</a>' if url else "")
            + "</li>"
            for n, text, url in sources
        )
        sources_html = (
            '      <section id="sources">\n        <h2>Sources</h2>\n'
            f'        <ol class="sources">\n{items}\n        </ol>\n      </section>'
        )

    draft_badge = '<span class="badge badge-draft ms-2">Working draft</span>' if DRAFT else ""
    kicker_bits = [kind, date_text, f"{minutes} min read"]
    kicker = " &middot; ".join(b for b in kicker_bits if b)

    ld = {
        "@context": "https://schema.org",
        "@type": "Article",
        "headline": strip_tags(title),
        "alternativeHeadline": strip_tags(subtitle),
        "author": {"@type": "Person", "name": author, "url": "https://www.jonathanborden-md.com/"},
        "publisher": {"@type": "Organization", "name": "The Open Healthcare Group", "url": SITE + "/"},
        "mainEntityOfPage": canonical,
        "description": description,
        "wordCount": words,
        "encoding": {
            "@type": "MediaObject",
            "contentUrl": docx_url,
            "encodingFormat": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        },
    }
    if iso_date:
        ld["datePublished"] = iso_date
    ld_json = json.dumps(ld, indent=2, ensure_ascii=False)

    page = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{strip_tags(title)} | The Open Healthcare Group</title>
  <meta name="description" content="{html.escape(description)}">
  <meta name="author" content="{html.escape(author)}">
  <meta name="keywords" content="Medicare Part D for All, drug prices, prescription drug pricing, international reference pricing, 28 U.S.C. 1498, national drug purchasing, health policy, Jonathan Borden">
  <link rel="canonical" href="{canonical}">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="The Open Healthcare Group">
  <meta property="og:title" content="{html.escape(strip_tags(title))}">
  <meta property="og:description" content="{html.escape(description)}">
  <meta property="og:url" content="{canonical}">
  <meta name="twitter:card" content="summary">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/OHCG_Style.css">
  <script type="application/ld+json">
{ld_json}
  </script>
</head>
<body class="page-article" data-bs-spy="scroll" data-bs-target="#toc" data-bs-offset="120" tabindex="0">
  <nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
      <a class="navbar-brand" href="/">Open Healthcare Group</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#siteNav" aria-controls="siteNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="siteNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link" href="/">Home</a></li>
          <li class="nav-item"><a class="nav-link active" aria-current="page" href="/policy/">Policy</a></li>
          <li class="nav-item"><a class="nav-link" href="/projects/">Projects</a></li>
          <li class="nav-item"><a class="nav-link" href="/standards/">Standards</a></li>
          <li class="nav-item"><a class="nav-link" href="/about/">About</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <main class="container my-4 my-lg-5">
    <nav aria-label="breadcrumb" class="d-print-none">
      <ol class="breadcrumb small">
        <li class="breadcrumb-item"><a href="/">Home</a></li>
        <li class="breadcrumb-item"><a href="/policy/">Policy</a></li>
        <li class="breadcrumb-item active" aria-current="page">Medicare Part D for All</li>
      </ol>
    </nav>

    <header class="article-header">
      <p class="kicker">{kicker}{draft_badge}</p>
      <h1 class="article-title">{title}</h1>
      <p class="article-subtitle">{subtitle}</p>
      <p class="byline">{html.escape(author)}</p>
      <div class="article-actions d-print-none">
        <a class="btn btn-primary" href="{docx.name}" download>Download the proposal (.docx)</a>
        <button type="button" class="btn btn-outline-secondary" onclick="window.print()">Print</button>
      </div>
      <details class="toc toc-mobile d-lg-none d-print-none">
        <summary>Contents</summary>
        <ul class="nav flex-column">
{toc_items}
        </ul>
      </details>
    </header>

    <div class="row gx-lg-5">
      <aside class="col-lg-3 d-none d-lg-block d-print-none">
        <nav id="toc" class="toc sticky-lg-top">
          <p class="kicker">Contents</p>
          <ul class="nav flex-column">
{toc_items}
          </ul>
        </nav>
      </aside>
      <article class="col-lg-8 article">
{sections_html}
{sources_html}
      <p class="article-colophon d-print-none">This page is generated from the Word document. <a href="{docx.name}" download>Download the .docx</a> for the authoritative text, read it as <a href="{docx.with_suffix(".md").name}">plain Markdown</a>, or send comments to <a href="mailto:jonathan@openhealth.org">jonathan@openhealth.org</a>.</p>
      </article>
    </div>
  </main>

  <footer class="site-footer mt-5 py-4">
    <div class="container">
      <div class="row gy-3">
        <div class="col-md-6">
          <p class="mb-1"><strong>The Open Healthcare Group</strong></p>
          <p class="mb-1">Open standards and open-source software for health records, and proposals for a better-run healthcare system.</p>
          <p class="mb-0"><a href="mailto:jonathan@openhealth.org">jonathan@openhealth.org</a></p>
        </div>
        <div class="col-md-6 text-md-end">
          <p class="mb-1"><a href="https://www.jonathanborden-md.com/jonathan-borden-cv.html">Jonathan A. Borden, MD</a></p>
          <p class="mb-1"><a href="https://blog.openhealth.org">Blog</a> &middot; <a href="https://github.com/jab-r/openhealth">Source on GitHub</a></p>
          <p class="mb-0 small">&copy; 2026 The Open Healthcare Group</p>
        </div>
      </div>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
"""
    out = docx.parent / "index.html"
    out.write_text(page, encoding="utf-8")

    # Plain Markdown copy for text readers and crawlers
    md_body = pandoc(str(docx), "-t", "gfm", "--wrap=none")
    md_body = md_body[md_body.find("\n# "):].lstrip("\n") if "\n# " in md_body else md_body  # drop front-matter lines
    md = (f"# {strip_tags(title)}\n\n*{strip_tags(subtitle)}*\n\n"
          f"{author}. {kind}, {date_text}. Published at {canonical}\n\n{md_body}")
    (docx.parent / docx.with_suffix(".md").name).write_text(md, encoding="utf-8")
    return out, words, len(body_sections), len(sources)


if __name__ == "__main__":
    docx = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_DOCX
    if not docx.exists():
        sys.exit(f"not found: {docx}")
    out, words, nsec, nsrc = build(docx)
    print(f"wrote {out.relative_to(ROOT)}: {nsec} sections, {nsrc} sources, {words} words")

<!DOCTYPE xsl:stylesheet [
<!ENTITY ldquo '&#x201C;' >
<!ENTITY rdquo '&#x201D;' >
]>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- For conversion of Extreme Markup Languages conference papers
     to XHTML for display.
     by Wendell Piez, Mulberry Technologies
     March 23, 2001

-->

<xsl:import href="table.xsl"/>
<!-- import Norman Walsh's OASIS (DocBook) table stylesheet -->


<xsl:output method="html" indent="yes" encoding="ISO-8859-1" />

<xsl:variable name="bgcolor" select="'#EFFFEF'"/>

<xsl:variable name="altbgcolor" select="'#BADABA'"/>

<xsl:variable name="linkcolor" select="'#662222'"/>

<xsl:variable name="secnumbers" select="paper/@secnumbers"/>
<!-- the value should be an integer. 0 (the default) means
     no section numbering -->

<xsl:variable name="footnotes" select="//ftnote"/>

<!-- set parameters for Norman Walsh's table stylesheet: -->
  <xsl:variable name="default.table.width" select="'85%'"/>

  <xsl:variable name="saxon.extensions" select="0"/>
  <!-- running without extensions -->

  <xsl:variable name="saxon.tablecolumns" select="0"/>
<!-- [end parameters for table.xsl] -->

<xsl:template match="/">
  <html>
    <head>
      <title>
        <xsl:value-of select="paper/front/title"/>
      </title>
    </head>
    <body bgcolor="{$bgcolor}" link="{$linkcolor}" vlink="{$linkcolor}" alink="{$linkcolor}">
      <table border="0" width="100%" cellspacing="4" cellpadding="8">
        <tr>
          <td align="right" bgcolor="{$altbgcolor}">
            <span style="font-size:140%;font-face:sans-serif">
              <i><b>Extreme</b></i> Markup Languages</span>
          </td></tr>
      </table>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:template match="paper">
  <xsl:apply-templates select="front|body"/>
  <xsl:call-template name="footnotes"/>
  <xsl:apply-templates select="rear"/>
</xsl:template>

<xsl:template match="front">
  <xsl:apply-templates select="title|subt"/>
  <xsl:apply-templates select="author"/>
  <xsl:apply-templates select="keywords"/>
  <xsl:apply-templates select="abstract"/>
</xsl:template>

<xsl:template match="front/title">
  <h1>
    <xsl:if test="../@id">
      <a name="../@id"/>
    </xsl:if>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="subt">
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="author">
  <xsl:if test="preceding-sibling::author">
    <br class="br"/>
  </xsl:if>
  <address>
    <xsl:apply-templates select="fname"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="surname"/>
    <xsl:apply-templates select="jobtitle|address"/>
  </address>
  
</xsl:template>

<xsl:template match="jobtitle">
  <br class="br"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="address">
  <xsl:apply-templates select="affil|subaffil"/>
  <xsl:apply-templates
    select="aline|city|state|province|cntry|postcode|phone|fax|email|web"/>
</xsl:template>

<xsl:template match="affil|subaffil|aline|city|cntry|province">
  <br class="br"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="state|postcode">
  <xsl:text> </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="phone">
  <br class="br"/><xsl:text>tel: </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="fax">
  <br class="br"/><xsl:text>fax: </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="email">
  <br class="br"/>
  <a href="mailto:{.}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="web">
  <br class="br"/>
  <a href="href://{.}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="abstract">
  <table border="1" width="80%" align="center" cellpadding="8" bgcolor="{$altbgcolor}">
  <tr><td>
    <h5><i>Abstract</i></h5>
    <xsl:apply-templates/>
  </td></tr></table>
</xsl:template>

<xsl:template match="keywords">
  <p><b>Keywords: </b>
    <xsl:for-each select="*">
      <xsl:apply-templates/>
      <xsl:if test="position() &lt; last()">; </xsl:if>
    </xsl:for-each>
  </p>
</xsl:template>

<!-- Body content elements -->

<xsl:template match="section|subsec1|subsec2|subsec3">
  <div class="local-name()">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template name="marksectitle">
    <xsl:if test="../@id">
      <a name="{../@id}"/>
    </xsl:if>
    <xsl:if test="$secnumbers">
      <xsl:number level="multiple" format="1.1.1.1 " count="section|subsec1|subsec2|subsec3"/>
    </xsl:if>
</xsl:template>

<xsl:template match="section/title">
  <h2>
    <xsl:call-template name="marksectitle"/>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="subsec1/title">
  <h3>
    <xsl:call-template name="marksectitle"/>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="subsec2/title">
  <h4>
    <xsl:call-template name="marksectitle"/>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="subsec3/title">
  <h5>
    <xsl:call-template name="marksectitle"/>
    <xsl:apply-templates/>
  </h5>
</xsl:template>

<xsl:template match="para">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="note">
  <blockquote>
    <xsl:text>NOTE: </xsl:text>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="figure">
  <br class="br"/>
  <object>
    <table width="40%" align="right" border="1" cellpadding="8" bgcolor="{$altbgcolor}">
      <tr><td>
        <xsl:if test="@id">
          <a name="{@id}"/>
        </xsl:if>
        <h5>Figure <xsl:number count="figure" level="any"/>
          <xsl:if test="title|caption">
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="title"/>
        </h5>
        <xsl:apply-templates select="node()[not(self::title)]"/>
      </td></tr>
    </table>
  </object>
</xsl:template>

<xsl:template match="caption">
  <div style="font-size:85%">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="lquote">
  <br class="br"/>
  <object>
    <table border="1" width="80%" align="center" cellpadding="8" bgcolor="{$altbgcolor}"><tr><td>
      <xsl:apply-templates/>
    </td></tr></table>
  </object>
</xsl:template>

<xsl:template match="graphic">
  <p>
    <xsl:text>[Graphic entity </xsl:text>
    <xsl:value-of select="@figname"/>
    <br class="br"/>
    <span style="font-size:85%">
      <xsl:choose>
        <xsl:when test="unparsed-entity-uri(@figname)">
            <xsl:text/> (<xsl:value-of select="unparsed-entity-uri(@figname)"/>)<xsl:text/>
        </xsl:when>
        <xsl:otherwise> <i>(Please declare graphic entity)</i></xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:text>]</xsl:text>
  </p>
</xsl:template>

<xsl:template match="randlist">
  <xsl:choose>
    <xsl:when test="@style='simple'">
      <dl>
        <xsl:apply-templates/>
      </dl>
    </xsl:when>
    <xsl:otherwise>
      <ul>
        <xsl:if test="@style='dashed'">
          <!-- dashed lists get squares ... too bad -->
          <xsl:attribute name="type">
            <xsl:text>square</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </ul>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="seqlist">
  <ol>
    <xsl:attribute name="type">
      <xsl:choose>
        <xsl:when test="ualpha">A</xsl:when>
        <xsl:when test="uroman">I</xsl:when>
        <xsl:when test="lalpha">a</xsl:when>
        <xsl:when test="lroman">i</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="li">
  <xsl:choose>
    <xsl:when test="parent::randlist[@style='simple']">
      <dd>
        <xsl:apply-templates/>
      </dd>
    </xsl:when>
    <xsl:otherwise>
      <li>
        <xsl:apply-templates/>
      </li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="li/para">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::*">
    <br class="br"/>
  </xsl:if>
</xsl:template>

<xsl:template match="def.list">
  <xsl:apply-templates select="title"/>
    <table border="0" cellpadding="8">
      <xsl:if test="term.heading|def.heading">
        <tr>
          <th>
            <xsl:apply-templates select="term.heading"/>
          </th>
          <th>
            <xsl:apply-templates select="def.heading"/>
          </th>
        </tr>
      </xsl:if>
      <xsl:apply-templates select="def.item"/>
    </table>
</xsl:template>

<xsl:template match="def.list/title">
  <h4>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="def.item">
  <tr>
    <xsl:apply-templates/>
  </tr>
</xsl:template>

<xsl:template match="def.term|def">
  <td>
    <xsl:apply-templates/>
  </td>
</xsl:template>

<!-- Inline elements -->

<xsl:template match="expansion">
  <!-- we don't need to match acronym.grp or acronym, just
       pass them through -->
  <xsl:text> [</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="bibref">
  <b><span style="font-size:85%"><a href="#{@refloc}" name="from{@refloc}">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="id(@refloc)/bib"/>
    <xsl:text>]</xsl:text>
  </a></span></b>
</xsl:template>

<xsl:template match="inline.graphic">
  <b>
    <xsl:text>[Graphic entity </xsl:text>
    <xsl:value-of select="@figname"/>
    <xsl:if test="unparsed-entity-uri(@figname)">
      <xsl:text/>(<xsl:value-of select="unparsed-entity-uri(@figname)"/>)<xsl:text/>
    </xsl:if>
    <xsl:text>]</xsl:text>
  </b>
</xsl:template>

<xsl:template match="cit">
 <i>
   <xsl:apply-templates/>
 </i>
</xsl:template>

<xsl:template match="fnref">
  <xsl:variable name="ftnote" select="id(@refloc)"/>
  <xsl:variable name="noteno">
    <xsl:for-each select="$ftnote">
      <xsl:number level="any"/>
    </xsl:for-each>
  </xsl:variable>
  <sup>
    <span style="background-color:{$altbgcolor}">
      <b>
        <a href="#to{generate-id($ftnote)}">
          <xsl:value-of select="$noteno"/>
        </a>
      </b>
    </span>
  </sup>
</xsl:template>

<xsl:template match="ftnote">
  <xsl:variable name="noteno">
    <xsl:number level="any"/>
  </xsl:variable>
  <sup>
    <span style="background-color:{$altbgcolor}">
      <b>
      <a href="#to{generate-id()}" name="from{generate-id()}">
          <xsl:value-of select="$noteno"/>
        </a>
      </b>
    </span>
  </sup>
</xsl:template>

<xsl:template match="ftnote" mode="notes">
  <xsl:variable name="noteno">
    <xsl:number level="any" format="1."/>
  </xsl:variable>
  <tr>
    <td valign="top" width="10%" align="right">
    <a href="#from{generate-id()}" name="to{generate-id()}">
      <b><xsl:value-of select="$noteno"/></b>
    </a>
    </td>
    <td style="font-size:85%">
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="sgml">
  <span style="background-color:{$altbgcolor}"><tt>
    <xsl:apply-templates/>
  </tt></span>
</xsl:template>

<xsl:template match="sgml.block|verbatim">
  <br class="br"/>
  <object>
    <table border="1" width="80%" align="center" cellpadding="8" bgcolor="{$altbgcolor}"><tr><td>
      <pre>
        <xsl:apply-templates/>
      </pre>
    </td></tr></table>
  </object>
</xsl:template>

<xsl:template match="xref">
  <a href="#{@refloc}">
    <xsl:apply-templates select="id(@refloc)" mode="xreftext">
      <xsl:with-param name="type" select="@type"/>
    </xsl:apply-templates>
  </a>
</xsl:template>

<xsl:template match="section|subsec1|subsec2|subsec3" mode="xreftext">
  <xsl:param name="type" select="'title'"/>
  <xsl:choose>
    <xsl:when test="$type='title'">
      <xsl:text>&ldquo;</xsl:text>
      <xsl:value-of select="title"/>
      <xsl:text>&rdquo;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="multiple" format="1.1.1.1" count="section|subsec1|subsec2|subsec3"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure" mode="xreftext">
  <xsl:param name="type" select="'title'"/>
  <xsl:choose>
    <xsl:when test="$type='title'">
      <xsl:text>&ldquo;</xsl:text>
      <xsl:value-of select="title"/>
      <xsl:text>&rdquo;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="any"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="highlight[@style='bold']">
  <b>
    <xsl:apply-templates/>
  </b>
</xsl:template>

<xsl:template match="highlight[@style='ital']">
  <i>
    <xsl:apply-templates/>
  </i>
</xsl:template>

<xsl:template match="highlight[@style='under']">
  <u>
    <xsl:apply-templates/>
  </u>
</xsl:template>

<xsl:template match="highlight[@style='roman']">
  <span style="font-style:normal; font-weight:normal">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="highlight[@style='bital']">
  <i>
    <b>
      <xsl:apply-templates/>
    </b>
  </i>
</xsl:template>

<xsl:template match="sub">
  <sub>
    <xsl:apply-templates/>
  </sub>
</xsl:template>

<xsl:template match="super">
  <sup>
    <xsl:apply-templates/>
  </sup>
</xsl:template>

<!-- Back matter and bibliography elements -->

<xsl:template name="footnotes">
  <xsl:if test="$footnotes">
    <h3><i>Notes</i></h3>
    <table width="100%" cellpadding="8" cellspacing="0" border="0">
      <xsl:apply-templates select="$footnotes" mode="notes"/>
    </table>
  </xsl:if>
</xsl:template>

<xsl:template match="rear">
  <hr/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="acknowl">
  <h3><i>
    <xsl:text>Acknowledgments</xsl:text>
  </i></h3>
  <xsl:apply-templates/>
  <hr/>
</xsl:template>

<xsl:template match="bibliog">
  <h3><i>
    <xsl:text>Bibliography</xsl:text>
  </i></h3>
  <xsl:apply-templates/>
  <hr/>
</xsl:template>

<xsl:template match="bibitem">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="bib">
  <b><a name="{../@id}">
    <xsl:if test="//bibref/@refloc=../@id">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('#from', ../@id)"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>] </xsl:text>
  </a></b>
</xsl:template>

<xsl:template match="pub">
  <xsl:text> </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

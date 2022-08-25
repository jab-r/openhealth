<xslt:stylesheet 
    xmlns:xslt="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rddl="http://www.rddl.org/"
	xmlns:xlink="http://www.w3.org/1999/xlink" >

<xslt:param name="xmlfile" />
<xslt:output method="html" indent="yes"/>
<xslt:variable name="wnprefix">http://xmlns.com/wordnet/1.6/</xslt:variable>
<xslt:variable name="webdata">http://www.w3.org/2000/06/webdata/xslt?xslfile=http://www.rddl.org/wn2rddl.xsl&amp;xmlfile=</xslt:variable>

<xslt:template match="rdf:RDF">
<html xmlns:rddl="http://www.rddl.org/"
	  xmlns:xlink="http://www.w3.org/1999/xlink"
	  >
   <head>
     <title>Wordnet Term</title>
   </head>
   <body>
    <xslt:apply-templates select="rdfs:Class[rdfs:subClassOf/rdfs:Class]"/>
	<xslt:if test="rdfs:Class[@rdf:about]/rdfs:subClassOf[@rdf:resource]">
	<h2>Hyponyms</h2>
	</xslt:if>
    <xslt:apply-templates select="rdfs:Class[@rdf:about and rdfs:subClassOf/@rdf:resource]"/>
   </body>
</html>
</xslt:template>

<xslt:template match="rdfs:Class[rdfs:subClassOf/rdfs:Class]">
<rddl:resource
	xlink:title="{rdfs:label}"
	xlink:role="http://www.w3.org/2000/01/rdf-schema#Class"
	xlink:arcrole="http://www.rddl.org/purposes#definition"
	xlink:href="{@rdf:about}"
>
<h1><xslt:value-of select="rdfs:label"/></h1>
<xslt:for-each select=".//rdfs:description">
<p><xslt:value-of select="."/></p>
</xslt:for-each>

<!--<xslt:for-each select=".//rdfs:subClassOf/rdfs:Class[@rdf:about]">

</xslt:for-each>-->
<xslt:apply-templates />
</rddl:resource>
</xslt:template>

<xslt:template match="rdfs:subClassOf/rdfs:Class[@rdf:about]" priority="9">
<xslt:variable name="word" select="substring-after(@rdf:about,$wnprefix)"/>
<rddl:resource
	xlink:title="{rdfs:label}"
	xlink:role="http://www.rddl.org/natures#term"
	xlink:arcrole="http://www.rddl.org/purposes#definition"
	xlink:href="{@rdf:about}"
>
 <p>Is a type of: 
   <a href="{concat($webdata,@rdf:about)}"><xslt:value-of select="$word" /></a>
 </p>
 <xslt:apply-templates />
</rddl:resource>
</xslt:template>
<!-- hyponyms -->

<xslt:template match="rdfs:Class[@rdf:about and rdfs:subClassOf/@rdf:resource]" priority="10">
<rddl:resource
	xlink:title="{rdfs:label}"
	xlink:role="http://www.rddl.org/natures#term"
	xlink:arcrole="http://www.rddl.org/purposes#definition"
	xlink:href="{@rdf:about}"
	>
<h3><a href="{concat($webdata,@rdf:about)}"><xslt:value-of select="rdfs:label"/></a></h3>
<xslt:for-each select="rdfs:description">
<p><xslt:value-of select="."/></p>
</xslt:for-each>
</rddl:resource>
</xslt:template>
<!-- Don't pass text through -->
<xslt:template match="text()|@*">
</xslt:template>
</xslt:stylesheet>

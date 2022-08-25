<?xml version="1.0" ?>
<!-- 
	Resource Directory Description Language (RDDL)
	Author: Jonathan Borden <jonathan@openhealth.org>
	Date: 2001-01-15
	
	This is an experimental version.
	
	RDDL to RSS 1.0 transform
	
	Assumes xlink:arcrole is a URI reference in form:
	
		absoluteURI '#' fragment-id
		
		when converting to a propertyElt:
		
			absoluteURI => namespace URI
			fragment-id => local-name
			
	
	RDDL: http://www.rddl.org/
	RDF: http://www.w3.org/TR/REC-rdf-syntax
-->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rddl="http://www.rddl.org/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:ht="http://www.w3.org/1999/xhtml"
	xmlns="http://purl.org/rss/1.0/"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes='xsl rddl xlink saxon'
	version="1.0">

<xsl:template match="/">
<xsl:comment>RDF generated from RDDL document (http://www.rddl.org/</xsl:comment>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		 xmlns="http://purl.org/rss/1.0/"
>
	<channel rdf:about="">
	  <title><xsl:value-of select="ht:html/ht:head/ht:title" /></title>
	  <link><xsl:if test="function-available('saxon:system-id')"><xsl:value-of select="saxon:system-id()" /></xsl:if></link>
	  <description><xsl:value-of select="ht:html/ht:body/ht:h1" /></description>
	  <items>
	   <rdf:Seq>
		 <xsl:apply-templates select="//rddl:resource" mode="channel"/>
	   </rdf:Seq>
	  </items>
	</channel>
	<xsl:apply-templates select="//rddl:resource" mode="item"/>
</rdf:RDF>

</xsl:template>
<!-- 
	note: assume xlink:arcrole := absoluteURI  '#' fragment-id
-->
<xsl:template match="rddl:resource" mode="item">
	<xsl:variable name="namespace-part" select="substring-before(@xlink:arcrole,'#')"/>
	<xsl:variable name="local-name" select="substring-after(@xlink:arcrole,'#')"/>
	<xsl:comment> <xsl:value-of select="@xlink:title" /> </xsl:comment>
	<item>
		<xsl:attribute name="rdf:about"><xsl:value-of select="@xlink:href" /></xsl:attribute>
		<title><xsl:value-of select="@xlink:title" /></title>
		<link><xsl:value-of select="@xlink:href" /></link>
		<description>
			<xsl:value-of select="*" />
		</description>
	</item>
</xsl:template>
<xsl:template match="rddl:resource[@xlink:href]" mode="channel">
	<rdf:li>
		<xsl:attribute name="rdf:resource"><xsl:value-of select="@xlink:href" /></xsl:attribute>
	</rdf:li>
</xsl:template>
</xsl:stylesheet>
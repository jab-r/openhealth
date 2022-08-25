<?xml version="1.0"?>
<!-- 
	Jonathan Borden <jonathan@openhealth.org> 
	3/16/2002 
-->
<!DOCTYPE xsl:stylesheet [
<!ENTITY schemans "http://www.openhealth.org/WOWG/Schema.owl#">
<!ENTITY ontns "http://www.openhealth.org/WOWG/webont#">
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY rdfs "http://www.w3.org/2000/03/rdf-schema#">
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xsd="&xsd;"
	xmlns:rdf="&rdf;"
	xmlns:rdfs="&rdfs;"
	xmlns:ont="&ontns;"
	xmlns="&schemans;"
	xmlns:schema="&schemans;">
<xsl:output method="xml" indent="yes" />
<!-- represent the document as RDF/ONT -->
<xsl:template match="/">
<rdf:RDF>
	<xsl:apply-templates/>
</rdf:RDF>
</xsl:template>
<!-- this pattern matches all elements i.e. the lexical XML production "element" is transformed into
a member of the Element class -->
<xsl:template match="*">
<Element>
	<xsl:attribute name="schema:name"><xsl:value-of select="local-name()" /></xsl:attribute>
	<xsl:attribute name="schema:ns"><xsl:value-of select="namespace-uri()" /></xsl:attribute>
	<!-- the set of attributes -->
		<attributes rdf:parseType="ont:collection">
			<xsl:apply-templates select="@*"/>
		</attributes>
	<!-- the sequence of child elements and text nodes -->
		<content rdf:parseType="ont:collection">
			<xsl:apply-templates select="*|text()"/>
		</content>
</Element>
</xsl:template>
<!-- this pattern matches all attributes -->
<xsl:template match="@*">
<Attribute>
	<xsl:attribute name="schema:name"><xsl:value-of select="local-name()" /></xsl:attribute>
	<xsl:attribute name="schema:ns"><xsl:value-of select="namespace-uri()" /></xsl:attribute>
	<rdf:value><xsl:value-of select="."/></rdf:value>
</Attribute>
</xsl:template>
<!-- this pattern matches all text nodes - note that the logic here filters out nodes that consist only
of SPACE -->
<xsl:template match="text()">
<xsl:if test="normalize-space() != normalize-space(' ')">
<Text>
<rdf:value><xsl:value-of select="."/></rdf:value>
</Text>
</xsl:if>
</xsl:template>
<xsl:template name="qnameToURI">
	<xsl:param name="ns"/>
	<xsl:param name="local"/>
<xsl:value-of select="$ns"/>#<xsl:value-of select="$local"/>
</xsl:template>
<xsl:template match="comment()">
<Comment>
<xsl:value-of select="."/>
</Comment>
</xsl:template>
<xsl:template match="processing-instruction()">
<PI>
<xsl:attribute name="schema:name"><xsl:value-of select="name()"/></xsl:attribute>
<xsl:value-of select="."/>
</PI>
</xsl:template>
</xsl:stylesheet>

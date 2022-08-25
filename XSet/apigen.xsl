<?xml version="1.0" ?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY forget "p:Eq | p:S | p:string | p:c">
]>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:p="http://www.openhealth.org/property-set-production-language">
<xsl:output version="1.0" method="text"/>
<xsl:template match="/rdf:RDF">
	<xsl:apply-templates select="rdf:Description"/>
</xsl:template>
<xsl:template match="rdf:Description">
interface Node {
	<xsl:apply-templates select="p:productions/p:production" mode="enum" />
};
<xsl:for-each select="p:productions/p:production">
	Class <xsl:value-of select="@name" /> : Node {
		<xsl:apply-templates select="*" mode="classdef"/>
	};
</xsl:for-each>
</xsl:template>
<xsl:template match="p:production" mode="enum">
	static final int <xsl:value-of select="@name" />_TYPE = <xsl:value-of select="@p" />;
</xsl:template>
<xsl:template match="*" mode="classdef">
	Node <xsl:value-of select="local-name()" />;
</xsl:template>
<xsl:template match="*[@occurs='*']" mode="classdef">
	NodeList <xsl:value-of select="local-name()" />s;
</xsl:template>
<xsl:template match="*[@occurs='+']" mode="classdef">
	NodeList <xsl:value-of select="local-name()" />s;
</xsl:template>
<xsl:template match="p:Seq" mode="classdef">
	<xsl:apply-templates select="*" mode="classdef"/>
</xsl:template>
<xsl:template match="p:Alt" mode="classdef">
	union{
	<xsl:apply-templates select="*" mode="classdef"/>
	};
</xsl:template>
<xsl:template match="p:Seq[@occurs]" mode="classdef">
	<xsl:apply-templates select="*" mode="multiple"/>
</xsl:template>
<xsl:template match="p:Alt[@occurs]" mode="classdef">
	union{
	<xsl:apply-templates select="*" mode="multiple"/>
	};
</xsl:template>
<xsl:template match="p:Seq[@occurs='?']" mode="classdef">
	<xsl:apply-templates select="*" mode="classdef"/>
</xsl:template>
<xsl:template match="p:Alt[@occurs='?']" mode="classdef">
	union{
	<xsl:apply-templates select="*" mode="classdef"/>
	};
</xsl:template>

<xsl:template match="*" mode="multiple">
	NodeList <xsl:value-of select="local-name()" />s;
</xsl:template>
<xsl:template match="p:Seq" mode="multiple">
	<xsl:apply-templates select="*" mode="multiple"/>
</xsl:template>
<xsl:template match="p:Alt" mode="multiple">
 union{
	<xsl:apply-templates select="*" mode="multiple"/>
 };
</xsl:template>

<xsl:template match="&forget;" mode="classdef"></xsl:template>
<xsl:template match="&forget;" mode="multiple"></xsl:template>
</xsl:stylesheet>

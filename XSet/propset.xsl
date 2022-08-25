<?xml version="1.0" ?>
<!-- 
	Copyright (c) 2000-2001 Jonathan Borden All rights reserved 
	
	An XSLT to derive an ISO Property Set from XSet EBNF grammar
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:x="http://www.openhealth.org/XSet"
	xmlns="http://www.openhealth.org/XSet"
	xml:space="preserve">
<!--<!DOCTYPE xsl:stylesheet [
<!ENTITY cut "c|string">
<!ENTITY transparent "Alt|Seq">
<!ENTITY string_types "Name|Nmtoken|PubidLiteral|SystemLiteral|S|CharData|Comment|PITarget|CData|VersionNum">
<!ENTITY stringlist_types "Names|Nmtokens">

<!ENTITY char_types "Char|NameChar|TextChar|Digit|Letter|CombiningChar|Extender|characters">
<!ENTITY nodelist_types "*[@occurs='*' or @occurs='+']">
<!ENTITY enum_types "SDDecl">
]>-->
<xsl:output version="1.0" method="xml" indent="yes"/>
<xsl:template match="/rdf:RDF">
<propset><xsl:apply-templates select="x:propertySet"/></propset>
</xsl:template>
<xsl:key name="prod" match="x:production" use="@name" />
<xsl:template match="x:Alt[(@occurs='*' or @occurs='+') and not(.//*[local-name() != 'c'])]">
	<xsl:param name="dnm" select="ancestor::x:production/@name" /> 	
	<propdef noderel="subnode" rcsnm="{$dnm}" datatype="string"/>
</xsl:template>
<xsl:template match="x:Alt[not(.//*[local-name()!='c'])]">
	<xsl:param name="dnm" select="ancestor::x:production/@name" /> 	
	<propdef noderel="subnode" rcsnm="{$dnm}" datatype="char"/>
</xsl:template>
<xsl:template match="x:Alt">
	<xsl:param name="dnm" select="ancestor::x:production/@name" /> 	
	<propdef noderel="subnode" rcsnm="{$dnm}" datatype="node">
		<xsl:attribute name="ac"><xsl:call-template name="getnm" /></xsl:attribute>
	</propdef>
</xsl:template>
<xsl:template match="x:Seq[not(.//*[local-name()!='c'])]">
	<xsl:param name="dnm" select="ancestor::x:production/@name" />
	<propdef noderel="subnode" rcsnm="{$dnm}" datatype="string"/>
</xsl:template>
<xsl:template match="x:Seq">
	<xsl:param name="dnm" select="ancestor::x:production/@name" />
	<xsl:apply-templates select="*">
		<xsl:with-param name="dnm" select="$dnm"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="*">
   <xsl:param name="dnm" select="ancestor::x:production/@name" />
   <xsl:variable name="nm" select="local-name()" />
   <xsl:if test="not(preceding::*[(ancestor::x:production/@name = $dnm) and (local-name()= $nm)])">	
	<propdef noderel="subnode" rcsnm="{$nm}" datatype="node">
		<!--<xsl:attribute name="ac"><xsl:value-of select="local-name()" /></xsl:attribute>-->
	</propdef>
   </xsl:if>
</xsl:template>
<xsl:template match="*" mode="classdef">
	<xsl:param name="dnm" select="ancestor::x:production/@name" />
 	<classdef rcsnm="{$dnm}">
	  <xsl:apply-templates select="*">
		<xsl:with-param name="dnm" select="$dnm"/>
	  </xsl:apply-templates>
	 </classdef>
</xsl:template>
<xsl:template name="getnm">
	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="local-name() = 'Alt'"><xsl:call-template name="getnm" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="local-name()" /></xsl:otherwise>
		</xsl:choose><xsl:if test="position() != last()">&#32;</xsl:if></xsl:for-each>
</xsl:template>
<xsl:template match="c|string"></xsl:template>

<xsl:template match="x:propertySet"><xsl:apply-templates select="x:productions"/></xsl:template>
<xsl:template match="x:productions"><xsl:apply-templates select="x:production"/></xsl:template>
<xsl:template match="x:production">
	<xsl:apply-templates select="*" mode="classdef">
		<xsl:with-param name="dnm" select="@name"/>
	</xsl:apply-templates>
</xsl:template>
</xsl:stylesheet>

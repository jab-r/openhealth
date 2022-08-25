<?xml version="1.0" ?>
<!-- 
	Copyright (c) 2000 Jonathan Borden
	All rights reserved
	
	This software is licensed under the Open Health Community License (OHCL) available at
	http://www.openhealth.org/license
-->
<xsl:stylesheet 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0"
		xmlns:edit="http://www.openhealth.org/editor"
		xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
		>

<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

<!-- identity transform -->
<xsl:template match="/edit:list">
 <xsl:comment>Generated XSLT by http://www.openhealth.org/editor/editorgen.xsl</xsl:comment>
 <axsl:stylesheet 
 		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">
	<xsl:for-each select="namespace::*">
		<!--<xsl:attribute name="{name()}" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="." /></xsl:attribute>-->
		<xsl:copy />
	</xsl:for-each>
	<axsl:template match="@*|node()">
		<axsl:copy>
			<axsl:apply-templates select="@*|node()"/>
		</axsl:copy>
	</axsl:template>
	<xsl:apply-templates />
 </axsl:stylesheet>
</xsl:template>
<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>
<xsl:template match="/"><xsl:apply-templates /></xsl:template>
<!--<xsl:template match="@*" mode="ns"><xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute></xsl:template>-->
<xsl:template match="edit:append">
	<axsl:template>
		<xsl:attribute name="match"><xsl:if test="/edit:list[@path-prefix]"><xsl:value-of select="/edit:list/@path-prefix" /></xsl:if><xsl:value-of select="@match" /></xsl:attribute>
		<axsl:copy>
			<axsl:apply-templates select="@*|node()"/>
			<xsl:apply-templates />	
		</axsl:copy>
	</axsl:template>
</xsl:template>
<xsl:template match="edit:insert-before">
	<axsl:template>
		<xsl:attribute name="match"><xsl:if test="/edit:list[@path-prefix]"><xsl:value-of select="/edit:list/@path-prefix" /></xsl:if><xsl:value-of select="@match" /></xsl:attribute>
		<axsl:copy>
			<axsl:apply-templates select="@*" />
			<xsl:apply-templates />
			<axsl:apply-templates select="node()"/>
		</axsl:copy>	
</axsl:template>
</xsl:template>
<xsl:template match="edit:delete">
	<axsl:template>
		<xsl:attribute name="match"><xsl:if test="/edit:list[@path-prefix]"><xsl:value-of select="/edit:list/@path-prefix" /></xsl:if><xsl:value-of select="@match" /></xsl:attribute>
	</axsl:template>
</xsl:template>
<xsl:template match="edit:replace">
	<axsl:template>
		<xsl:attribute name="match"><xsl:if test="/edit:list[@path-prefix]"><xsl:value-of select="/edit:list/@path-prefix" /></xsl:if><xsl:value-of select="@match" /></xsl:attribute>
		<xsl:apply-templates />
	</axsl:template>
</xsl:template>
<xsl:template match="edit:replace-or-append">
 <axsl:choose>
 	<axsl:when test="{@match}">
		<xsl:attribute name="test">
			<xsl:if test="/edit:list[@path-prefix]"><xsl:value-of select="/edit:list/@path-prefix" /></xsl:if><xsl:value-of select="@match" /></xsl:attribute>
		<axsl:apply-templates select="@*|node()"/>
		<xsl:apply-templates />
	</axsl:when>
	<axsl:otherwise></axsl:otherwise>
 </axsl:choose>
</xsl:template>
<xsl:template match="edit:param">
	<axsl:param name="{@name}">
		<xsl:if test="@select"><xsl:attribute name="select"><xsl:value-of select="@select" /></xsl:attribute></xsl:if>
		<xsl:apply-templates />
	</axsl:param>
</xsl:template>
<xsl:template match="edit:variable">
	<axsl:variable name="{@name}">
		<xsl:if test="@select"><xsl:attribute name="select"><xsl:value-of select="@select" /></xsl:attribute></xsl:if>
		<xsl:apply-templates />
	</axsl:variable>
</xsl:template>
<xsl:template match="edit:value">
	<axsl:value-of select="{@select}" />
</xsl:template>
<xsl:template match="edit:element-if">
	<axsl:if test="{@select}">
		<axsl:element name="{@name}"><axsl:value-of select="{@select}" /></axsl:element>
	</axsl:if>
</xsl:template>
<xsl:template match="edit:element">
 <axsl:element name="{@name}"><axsl:value-of select="{@select}" /></axsl:element>
</xsl:template>
</xsl:stylesheet>
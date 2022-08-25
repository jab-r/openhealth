<?xml version="1.0" encoding="utf-8"?><!-- 
	Copyright (c) 2000 Healthcare Transaction Systems, LLC 
	All rights reserved
	
	Author: Jonathan Borden
	
--><!--Generated XSLT by http://www.openhealth.org/editor/editorgen.xsl--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:edit="http://www.openhealth.org/editor#2000-08"  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="1.0"><xsl:template match="@*|node()"><xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy></xsl:template>
	<xsl:param name="FirstName"/>
	<xsl:param name="LastName"/>
	<xsl:param name="MiddleName"/>
	<xsl:param name="Title"/>
	<xsl:param name="Suffix"/>
	<xsl:param name="SSN"/>
	<xsl:param name="DOB"/>
	<xsl:param name="Gender"/>
	
	<xsl:param name="HAddress"/>
	<xsl:param name="HAddress2"/>
	<xsl:param name="HCity"/>
	<xsl:param name="HState"/>
	<xsl:param name="HZip"/>
	<xsl:param name="HPhone"/>
	<xsl:param name="HFax"/>
	<xsl:param name="HPager"/>
	<xsl:param name="HEmail"/>
	<xsl:param name="HCountry"/>
	
	<xsl:param name="WAddress"/>
	<xsl:param name="WAddress2"/>	
	<xsl:param name="WCity"/>
	<xsl:param name="WState"/>
	<xsl:param name="WZip"/>
	<xsl:param name="WPhone"/>
	<xsl:param name="WFax"/>
	<xsl:param name="WPager"/>
	<xsl:param name="WEmail"/>
	<xsl:param name="WCountry"/>
	<xsl:param name="UID"/>

	<xsl:param name="Type"/>
	<xsl:param name="Format"/>
<xsl:template match="/rdf:RDF/rdf:Description"><xsl:copy><xsl:apply-templates select="@*|node()"/>
 <person role="patient" UID="{$UID}">
	<name>
		<last><xsl:value-of select="$LastName"/></last>
		<first><xsl:value-of select="$FirstName"/></first>
		<middle><xsl:value-of select="$MiddleName"/></middle>
		<title><xsl:value-of select="$Title"/></title>
		<suffix><xsl:value-of select="$Suffix"/></suffix>
	</name>
	<gender><xsl:value-of select="$Gender"/></gender>
	<id>
		<DOB><xsl:value-of select="$DOB"/></DOB>
		<SSN><xsl:value-of select="$SSN"/></SSN>
	</id>
	<address type="home">
		<street><xsl:value-of select="$HAddress"/></street>
		<xsl:if test="$HAddress2"><xsl:element name="street2"><xsl:value-of select="$HAddress2"/></xsl:element></xsl:if>
		<xsl:element name="city"><xsl:value-of select="$HCity"/></xsl:element>
		<xsl:element name="state"><xsl:value-of select="$HState"/></xsl:element>
		<xsl:element name="zip"><xsl:value-of select="$HZip"/></xsl:element>
		<xsl:if test="$HPhone"><xsl:element name="phone"><xsl:value-of select="$HPhone"/></xsl:element></xsl:if>
		<xsl:if test="$HFax"><xsl:element name="fax"><xsl:value-of select="$HFax"/></xsl:element></xsl:if>
		<xsl:if test="$HPager"><xsl:element name="page"><xsl:value-of select="$HPager"/></xsl:element></xsl:if>
	</address>
	<address type="work">
		<xsl:element name="street"><xsl:value-of select="$WAddress"/></xsl:element>
		<xsl:if test="$WAddress2"><xsl:element name="street2"><xsl:value-of select="$WAddress2"/></xsl:element></xsl:if>
		<xsl:element name="city"><xsl:value-of select="$WCity"/></xsl:element>
		<xsl:element name="state"><xsl:value-of select="$WState"/></xsl:element>
		<xsl:element name="zip"><xsl:value-of select="$WZip"/></xsl:element>
		<xsl:if test="$WPhone"><xsl:element name="phone"><xsl:value-of select="$WPhone"/></xsl:element></xsl:if>
		<xsl:if test="$WFax"><xsl:element name="fax"><xsl:value-of select="$WFax"/></xsl:element></xsl:if>
		<xsl:if test="$WPager"><xsl:element name="page"><xsl:value-of select="$WPager"/></xsl:element></xsl:if>
	</address>
 </person>
 </xsl:copy></xsl:template>
</xsl:stylesheet>
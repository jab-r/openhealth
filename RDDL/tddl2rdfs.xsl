<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:tddl="http://www.rddl.org/tddl"
	xmlns:ht="http://www.w3.org/1999/xhtml"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns="http://www.w3.org/2000/01/rdf-schema#">
<xsl:template match="/ht:html/ht:body">
	<xsl:apply-templates />
</xsl:template>
<xsl:template match="ht:*"></xsl:template>
<xsl:template match="tddl:*"><xsl:apply-templates /></xsl:template>
<xsl:template match="tddl:Class">
<Class rdf:ID="{@id}">
	<xsl:apply-templates />
	<comment>
		<xsl:copy-of select="ht:*"/>
	</comment>
</Class>
</xsl:template>
<xsl:template match="tddl:Property">
<rdf:Property ID="(@id}">
	<xsl:apply-templates />
	<rdfs:comment>
		<xsl:copy-of select="ht:*"/>
	</rdfs:comment>
</rdf:Property>
</xsl:template>
<xsl:template match="tddl:subClassOf">
	<subClassOf rdf:resource="{@tddl:resource}"/>
</xsl:template>
<xsl:template match="tddl:subPropertyOf">
	<subPropertyOf rdf:resource="{@tddl:resource}"/>
</xsl:template>
<xsl:template match="tddl:domain"><domain rdf:resource="{@tddl:resource}"/></xsl:template>
<xsl:template match="tddl:range"><range rdf:resource="{@tddl:resource}"/></xsl:template>
</xsl:stylesheet>

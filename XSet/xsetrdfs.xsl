<?xml version="1.0" ?>
<!--
Copyright (c) 2000-2001 Jonathan Borden
the entities have become redundant because xpath can figure this stuff out based upon the patterns

last updated: 2001-03-06

<!DOCTYPE xsl:stylesheet [
<!ENTITY cut "c|string">
<!ENTITY transparent "Alt|Seq">
<!ENTITY string_types "Name|Nmtoken|PubidLiteral|SystemLiteral|S|CharData|Comment|PITarget|CData|VersionNum">
<!ENTITY stringlist_types "Names|Nmtokens">

<!ENTITY char_types "Char|NameChar|TextChar|Digit|Letter|CombiningChar|Extender|characters">
<!ENTITY nodelist_types "*[@occurs='*' or @occurs='+']">
<!ENTITY enum_types "SDDecl">
]>
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:x="http://www.openhealth.org/XSet"
	>
<xsl:output version="1.0" method="xml" indent="yes"/>
<xsl:template match="/rdf:RDF">
<rdf:RDF><xsl:apply-templates select="x:propertySet"/></rdf:RDF>
</xsl:template>


<xsl:template match="x:propertySet">
<!--
	<xsl:comment>define base classes</xsl:comment>
<rdfs:Class rdf:ID="Char">
	<rdfs:subClassOf rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
</rdfs:Class>
<rdfs:Class rdf:ID="String">
	<rdfs:subClassOf rdf:resource="http://www.w3.org/2000/01/rdf-schema#Seq"/>
</rdfs:Class>
<rdf:Property rdf:ID="char">
	<rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
	<rdfs:domain rdf:resource="#Char"/>
	<rdfs:domain rdf:resource="#String"/>
</rdf:Property>
<rdf:Property rdf:ID="string">
	<rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
	<rdfs:domain rdf:resource="#String"/>
</rdf:Property>
	<xsl:comment>define class for each production</xsl:comment>	
-->
<xsl:for-each select="x:production">

 <rdfs:Class rdf:ID="{@id}">
 	<rdfs:subClassOf>
		<xsl:attribute name="rdf:resource"><xsl:choose>
			<xsl:when test="@datatype = 'string'">http://www.openhealth.org/XSet#String</xsl:when>
			<xsl:when test="x:Char[@occurs='+' or @occurs='*']">http://www.openhealth.org/XSet#String</xsl:when>
			<xsl:when test="x:Alt[(@occurs='*' or @occurs='+') and not(x:Alt/*[local-name() != 'c'])]">http://www.w3.org/2000/01/rdf-schema#Literal</xsl:when>
			<xsl:when test="x:Alt[not(*[local-name()!='c'])]">http://www.openhealth.org/XSet#Char</xsl:when>
			<xsl:when test="x:Alt[@occurs='*' or @occurs='+']">http://www.openhealth.org/XSet#Seq</xsl:when>
			<xsl:when test="x:Alt[not(@occurs)]">http://www.openhealth.org/XSet#Alt</xsl:when>
			<xsl:when test="x:Seq[not(*[(local-name() != 'c') and (local-name() != 'string')])]">http://www.openhealth.org/XSet#String</xsl:when>
			<xsl:when test="x:Seq"><!--http://www.w3.org/1999/02/22-rdf-syntax-ns#Seq-->http://www.openhealth.org/XSet#Seq</xsl:when>
			<xsl:when test="*[exclude]"><xsl:value-of select="local-name(*[exclude])" /></xsl:when>
			<xsl:when test="*[@occurs='+' or @occurs='*']">http://www.openhealth.org/XSet#Seq</xsl:when>
			<xsl:otherwise>http://www.w3.org/2000/01/rdf-schema#Class</xsl:otherwise></xsl:choose>
		</xsl:attribute>
	</rdfs:subClassOf>
 </rdfs:Class>
	</xsl:for-each>
	<xsl:comment>define property for each production</xsl:comment>
	<xsl:for-each select="production">
 <xsl:variable name="nm" select="@id" />
 <rdf:Property ID="_{@name}" >
	<rdfs:range rdf:resource="#{@id}"/>
  <xsl:for-each select="/rdf:RDF/x:propertySet/x:production//*[(local-name() = $nm)]">
    <xsl:variable name="dnm" select="ancestor::x:production/@id"/>
	<xsl:if test="not(preceding::*[(ancestor::x:production/@id = $dnm) and (local-name()= $nm)])">
		<rdfs:domain rdf:resource="#{$dnm}"/>
	</xsl:if>
  </xsl:for-each>
 </rdf:Property>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>

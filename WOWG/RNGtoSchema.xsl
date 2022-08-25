<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY schemans "http://www.openhealth.org/WOWG/Schema.owl#">
<!ENTITY ontns "http://www.openhealth.org/WOWG/webont#">
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema-datatypes">
<!ENTITY rng "http://relaxng.org/ns/structure/1.0">
]>
<!-- 
	Jonathan Borden <jonathan@openhealth.org>
	3/18/2002
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xsd="&xsd;"
	xmlns:rng="&rng;"
	xmlns:rdf="&rdf;"
	xmlns:rdfs="&rdfs;"
	xmlns:ont="&ontns;"
	xmlns="&schemans;"
	xmlns:schema="&schemans;">
<xsl:output method="xml" indent="yes" />
<xsl:variable name="baseURI">
	<xsl:choose>
			<xsl:when test="/rng:grammar[@ns]">
				<xsl:value-of select="/rng:grammar/@ns"/>
			</xsl:when>
			<xsl:when test="/rng:grammar[@xml:base]">
				<xsl:value-of select="/rng:grammar/@xml:base" />
			</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:template match="/rng:grammar">
<ont:Ontology>
	<xsl:apply-templates select="rng:*" />
</ont:Ontology>
</xsl:template>
<!-- these are class definitions -->
<xsl:template match="rng:define">
	<Type schema:name="{@name}" schema:ns="{self-or-ancestor::rng:*[@ns]/@ns}">
		<xsl:if test="@id"><xsl:attribute name="rdf:ID"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<xsl:apply-templates select="*" mode="particles"/>
	</Type>
</xsl:template>

<xsl:template match="rng:choice" mode="particles">
	<ont:oneOf rdf:parseType="ont:collection">
		<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:oneOf>
</xsl:template>

<xsl:template match="rng:sequence" mode="particles">
	<ont:sequence rdf:parseType="ont:collection">
		<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:sequence>
</xsl:template>

<xsl:template match="rng:interleave" mode="particles">
	<ont:set rdf:parseType="ont:collection">
			<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:set>
</xsl:template>

<xsl:template match="rng:optional" mode="particles">
	<ont:sequence rdf:parseType="ont:collection">
	<xsl:call-template name="handleOccurs" >
		<xsl:with-param name="minC" select="0"/>
		<xsl:with-param name="maxC" select="1"/>
	</xsl:call-template>
	<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:sequence>
</xsl:template>
???
<xsl:template match="rng:zeroOrMore" mode="particles">
	<ont:sequence rdf:parseType="ont:collection">
	<xsl:call-template name="handleOccurs" >
		<xsl:with-param name="minC" select="0"/>
		<xsl:with-param name="maxC" select="unbounded"/>
	</xsl:call-template>
	<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:sequence>
</xsl:template>
???
<xsl:template match="rng:oneOrMore" mode="particles">
	<ont:sequence rdf:parseType="ont:collection">
	<xsl:call-template name="handleOccurs" >
		<xsl:with-param name="minC" select="1"/>
		<xsl:with-param name="maxC" select="unbounded"/>
	</xsl:call-template>
	<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:sequence>
</xsl:template>
...
<xsl:template match="*" mode="particles">
<xsl:comment> <xsl:value-of select="name()"/> skipped: <xsl:value-of select="."/> </xsl:comment>
</xsl:template>
<xsl:template name="handleOccurs">
	<xsl:param name="minC" />
	<xsl:param name="maxC" />
	<xsl:if test="$minC != 'unbounded'">
			<ont:minCardinality><xsl:value-of select="$minC"/></ont:minCardinality>
	</xsl:if>
	<xsl:if test="$maxC != 'unbounded'">
			<ont:maxCardinality><xsl:value-of select="$maxC"/></ont:maxCardinality>
	</xsl:if>
</xsl:template>
<!-- in collection -->
<!-- ref'd -->
<xsl:template match="xsd:element[@ref]" mode="in-collection">
	<!-- an element which has the name ... -->
	<Element>
		<xsl:comment>&lt;xsd:element ref="<xsl:value-of select="@ref"/>" /&gt;</xsl:comment>
		<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@ref"/></xsl:call-template>
	</Element>
</xsl:template>
<xsl:template match="xsd:attribute[@ref]" mode="in-collection">
	<!-- an attribute which has the name ... -->
	<Attribute>
		<xsl:comment>&lt;xsd:attribute ref="<xsl:value-of select="@ref"/>" /&gt;</xsl:comment>
		<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@ref"/></xsl:call-template>
	</Attribute>
</xsl:template>
<xsl:template match="xsd:complexType[@ref]" mode="in-collection">
	<!-- an group which has the name ... -->
	<Type>
		<xsl:comment>&lt;xsd:group ref="<xsl:value-of select="@ref"/>" /&gt;</xsl:comment>
		<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@ref"/></xsl:call-template>
	</Type>
</xsl:template>
<xsl:template match="xsd:simpleType[@ref]" mode="in-collection">
	<!-- an attribute which has the name ... -->
	<Datatype>
		<xsl:comment>&lt;xsd:attribute ref="<xsl:value-of select="@ref"/>" /&gt;</xsl:comment>
		<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@ref"/></xsl:call-template>
	</Datatype>
</xsl:template>
<!-- typed -->
<xsl:template match="xsd:element[@type]" mode="in-collection">
	<Element>
	    <xsl:if test="@name">
			<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@name"/></xsl:call-template>
		</xsl:if>
	  <ont:subClassOf>
		 <Type>
			<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@type"/></xsl:call-template>
		 </Type>
	  </ont:subClassOf>
	</Element>
</xsl:template>
<xsl:template match="xsd:attribute[@type]" mode="in-collection">
	<Attribute>
	    <xsl:if test="@name">
			<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@name"/></xsl:call-template>
		</xsl:if>
		<ont:subClassOf>
			<ont:DatatypeProperty>
				<rdfs:range>
					<xsl:element name="{@type}"/>
				</rdfs:range>
			</ont:DatatypeProperty>
		</ont:subClassOf>
	</Attribute>
</xsl:template>
<!-- -->
<xsl:template match="xsd:sequence|xsd:choice" mode="in-collection">
	<!--<xsl:choose>
		<xsl:when test="@minOccurs or @maxOccurs">
	<Type>
		<xsl:apply-templates select="." mode="particles"/>
	</Type>		
		</xsl:when>-->
	<Type>
		<xsl:apply-templates select="." mode="particles"/>
	</Type>
</xsl:template>

<xsl:template name="qnameRestrictions">
	<xsl:param name="qname"/>
	<xsl:variable name="prefix"><xsl:choose>
			<xsl:when test="contains($qname,':')"><xsl:value-of select="substring-before($qname,':')"/></xsl:when>
		<xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>
	<xsl:variable name="local"><xsl:choose>
			<xsl:when test="contains($qname,':')"><xsl:value-of select="substring-after($qname,':')"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$qname"/></xsl:otherwise></xsl:choose></xsl:variable>
	<xsl:choose>
			<xsl:when test="$prefix=''">
			<ont:Restriction>
				<ont:onProperty rdf:resource="&schemans;name"/>
				<ont:toValue><xsl:value-of select="$qname"/></ont:toValue>
			</ont:Restriction>
			</xsl:when>
		<xsl:otherwise>
			<ont:Restriction>
				<ont:onProperty rdf:resource="&schemans;name"/>
				<ont:toValue><xsl:value-of select="$local"/></ont:toValue>
			</ont:Restriction>
			<ont:Restriction>
				<ont:onProperty rdf:resource="&schemans;ns"/>
				<ont:toValue><xsl:value-of select="namespace::*[$prefix = local-name()]"/></ont:toValue>
			</ont:Restriction>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
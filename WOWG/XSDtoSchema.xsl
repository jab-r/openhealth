<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY schemans "http://www.openhealth.org/WOWG/Schema.owl#">
<!ENTITY ontns "http://www.openhealth.org/WOWG/webont#">
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema">
]>
<!-- 
	Jonathan Borden <jonathan@openhealth.org>
	3/16/2002
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xsd="&xsd;"
	xmlns:rdf="&rdf;"
	xmlns:rdfs="&rdfs;"
	xmlns:ont="&ontns;"
	xmlns="&schemans;"
	xmlns:schema="&schemans;">
<xsl:output method="xml" indent="yes" />
<xsl:variable name="baseURI">
	<xsl:choose>
			<xsl:when test="/xsd:schema/targetNamespace[@targetNamespace]">
				<xsl:value-of select="/xsd:schema/@targetNamespace"/>
			</xsl:when>
			<xsl:when test="/xsd:schema[@xml:base]">
				<xsl:value-of select="/xsd:schema/@xml:base" />
			</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:template match="/xsd:schema">
<rdf:RDF>
<ont:Ontology rdf:about="">
</ont:Ontology>
<xsl:apply-templates select="xsd:*" />
</rdf:RDF>
</xsl:template>
<!-- these are class definitions -->
<xsl:template match="xsd:complexType">
	<Type schema:name="{$baseURI}#{@name}">
		<xsl:if test="@id"><xsl:attribute name="rdf:ID"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
		<xsl:apply-templates select="*" mode="particles"/>
	</Type>
</xsl:template>

<xsl:template match="xsd:simpleType">
 <Datatype schema:name="{@name}" schema:ns="{$baseURI}">
 	<xsl:if test="@id"><xsl:attribute name="rdf:ID"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
	<ont:subClassOf>
	 <ont:Restriction>
	  <ont:onProperty rdf:resource="rdf:value"/>
	  <ont:toClass>
			<ont:DatatypeProperty>
				<rdfs:range rdf:resource="{$baseURI}#{@name}" />
			</ont:DatatypeProperty>
	  </ont:toClass>
	</ont:Restriction>
   </ont:subClassOf>
 </Datatype>
</xsl:template>

<xsl:template match="xsd:element">
  <Element schema:name="{@name}" schema:ns="{$baseURI}">
	<xsl:if test="@id"><xsl:attribute name="rdf:ID"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
	<xsl:if test="@type">
		<ont:subClassOf>
			<Type>
				<xsl:call-template name="qnameRestrictions"><xsl:with-param name="qname" select="@type"/></xsl:call-template>
			</Type>
		</ont:subClassOf>
	</xsl:if>
	<xsl:apply-templates select="*" mode="particles"/>
  </Element>
</xsl:template>

<xsl:template match="xsd:attribute">
  <Attribute schema:name="{@name}" schema:ns="{$baseURI}">
	<xsl:if test="@id"><xsl:attribute name="rdf:ID"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
	<xsl:apply-templates select="*" mode="particles"/>
  </Attribute>
</xsl:template>

<!--<xsl:template match="xsd:choice" mode="particles">
<xsl:choose>
		<xsl:when test="(@minOccurs or (@maxOccurs > 1))">
		<schema:Type>
			<ont:minCardinality><xsl:value-of select="@minOccurs"/></ont:minCardinality>
			<xsl:if test="@maxOccurs != 'unbounded'">
				<ont:maxCardinality><xsl:value-of select="@maxOccurs"/></ont:maxCardinality>
			</xsl:if>
			<ont:oneOf rdf:parseType="ont:collection">
				<xsl:apply-templates select="*" mode="in-collection"/>
			</ont:oneOf>
		</schema:Type>
		</xsl:when>
		<xsl:otherwise>
			<ont:oneOf rdf:parseType="ont:collection">
				<xsl:apply-templates select="*" mode="in-collection"/>
			</ont:oneOf>
		</xsl:otherwise>
</xsl:choose>
</xsl:template>-->
<!-- these are properties -->
<xsl:template match="xsd:choice" mode="particles">
	<xsl:call-template name="handleOccurs" />
	<ont:unionOf rdf:parseType="ont:collection">
		<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:unionOf>
</xsl:template>

<xsl:template match="xsd:sequence" mode="particles">
	<xsl:call-template name="handleOccurs" />
	<ont:sequence rdf:parseType="ont:collection">
		<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:sequence>
</xsl:template>

<xsl:template match="xsd:group" mode="particles">
	<xsl:call-template name="handleOccurs" />
	<ont:set rdf:parseType="ont:collection">
			<xsl:apply-templates select="*" mode="in-collection"/>
	</ont:set>
</xsl:template>

<xsl:template match="xsd:complexType" mode="particles">
	<xsl:call-template name="handleOccurs" />
	<xsl:comment>xsd:complexType</xsl:comment>
	<xsl:apply-templates select="*" mode="in-collection"/>
</xsl:template>

<xsl:template match="*" mode="particles">
<xsl:comment> <xsl:value-of select="name()"/> skipped: <xsl:value-of select="."/> </xsl:comment>
</xsl:template>
<xsl:template name="handleOccurs">
	<xsl:if test="@minOccurs"><ont:minCardinality><xsl:value-of select="@minOccurs"/></ont:minCardinality></xsl:if>
	<xsl:if test="@maxOccurs and (@maxOccurs != 'unbounded')">
			<ont:maxCardinality><xsl:value-of select="@maxOccurs"/></ont:maxCardinality>
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
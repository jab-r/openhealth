<?xml version="1.0" ?>
<!-- 
	Resource Directory Description Language (RDDL)
	Author: Jonathan Borden <jonathan@openhealth.org>
	Date: 2001-01-15
	
	This is an experimental version.
	
	RDDL to RDF transform

- modified 2/23/2005 to fix default namespace and add xml:base
	
	Assumes xlink:arcrole is a URI reference in form:
	
		absoluteURI '#' fragment-id
		
		when converting to a propertyElt:
		
			absoluteURI => namespace URI
			fragment-id => local-name
			
	
	RDDL: http://www.rddl.org/
	RDF: http://www.w3.org/TR/REC-rdf-syntax
-->
<!-- 
	note, because most RDF parsers don't grok xml:base ... 
	we need to replace rdf:ID with rdf:about=base#id generally
	-->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rddl="http://www.rddl.org/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:ht="http://www.w3.org/1999/xhtml"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes='xsl saxon ht'
	version="1.0">
<xsl:param name="documentation" select="'no'"/>
<xsl:variable name="sysid">
	<xsl:choose>
	<xsl:when test="function-available('saxon:system-id')">
		<xsl:value-of select="saxon:system-id()" />
	</xsl:when>
	<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="baseURI">
	<xsl:choose>
		<xsl:when test="/ht:html[@xml:base]"><xsl:value-of select="/ht:html/@xml:base" /></xsl:when>
		<xsl:otherwise><xsl:value-of select="$sysid" /></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template match="/">
<xsl:comment>RDF generated from RDDL document 
(http://www.rddl.org/)</xsl:comment>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			 xmlns:rddl="http://www.rddl.org/">
<xsl:attribute name="xmlns">
	<xsl:value-of select="$baseURI" />
</xsl:attribute>
<!--	namespace="http://www.w3.org/1998/XML/namespace" 
	
<xsl:attribute name="xml:base"> <xsl:value-of select="$baseURI" /> 
</xsl:attribute>
-->
		<xsl:apply-templates select="//rddl:resource"/>
</rdf:RDF>

</xsl:template>
<!-- 
	note: assume xlink:arcrole := absoluteURI  '#' fragment-id
-->
<xsl:template match="rddl:resource">
	<xsl:param name="node" select="."/>
	<xsl:variable name="base">
		<xsl:choose>
			<xsl:when test="$node/ancestor-or-self::*[@xml:base]"><xsl:value-of select="$node/ancestor-or-self::*[@xml:base][1]/@xml:base" /></xsl:when>
			<xsl:when test="$sysid = $baseURI"></xsl:when>
			<xsl:otherwise><xsl:value-of select="$baseURI" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="href">
		<xsl:choose>
			<xsl:when test="starts-with(@xlink:href,'#')"><xsl:value-of select="concat($base,@xlink:href)" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="@xlink:href" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="namespace-part">
		<xsl:choose>
			<xsl:when test="@xlink:arcrole and (substring-before(@xlink:arcrole,'#') != '')"><xsl:value-of select="substring-before(@xlink:arcrole,'#')" />#</xsl:when>
			<xsl:when test="@xlink:arcrole"><xsl:value-of select="@xlink:arcrole" />#</xsl:when>
			<xsl:otherwise>http://www.rddl.org/#</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="local-name">
		<xsl:choose><xsl:when test="@xlink:arcrole and (substring-after(@xlink:arcrole,'#') != '')"><xsl:value-of select="substring-after(@xlink:arcrole,'#')" /></xsl:when>
		<xsl:otherwise>resource</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="role-namespace-part">
		<xsl:choose>
			<xsl:when test="@xlink:role and (substring-before(@xlink:role,'#')!='')"><xsl:value-of select="substring-before(@xlink:role,'#')"/>#</xsl:when>
			<xsl:when test="@xlink:role"><xsl:value-of select="@xlink:role" />#</xsl:when>
			<xsl:otherwise>http://www.rddl.org/#</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="role-local-name">
		<xsl:choose>
			<xsl:when test="@xlink:role and (substring-after(@xlink:role,'#') != '')"><xsl:value-of select="substring-after(@xlink:role,'#')" /></xsl:when>
			<xsl:otherwise>resource</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:comment> <xsl:value-of select="@xlink:title" /> </xsl:comment>
	<xsl:choose>
		<xsl:when test="substring-before($role-namespace-part,'#') = @xlink:role">
			<rdf:Description>
				<xsl:choose>
			<xsl:when test="@id"><!--<xsl:attribute name="rdf:ID">--><xsl:attribute name="rdf:about"><xsl:value-of select="concat($base,'#',@id)" /></xsl:attribute></xsl:when>
			<xsl:when test="@xml:base"><xsl:attribute name="rdf:about"><xsl:value-of select="@xml:base" /></xsl:attribute></xsl:when>
			<xsl:when test="ancestor::*[@id]"><xsl:attribute name="rdf:about"><xsl:value-of select="$base" />#<xsl:value-of select="ancestor::*[@id][1]/@id" /></xsl:attribute></xsl:when>
			<xsl:otherwise><xsl:attribute name="rdf:about"></xsl:attribute></xsl:otherwise>
				</xsl:choose>
				<rdf:type rdf:resource="{@xlink:role}" />
				<xsl:element name="{$local-name}" namespace="{$namespace-part}">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$href" /></xsl:attribute>
				</xsl:element>
				<xsl:if test="$documentation='yes'"><rddl:documentation rdf:parseType="Literal">
						<xsl:copy-of select="*" />
				</rddl:documentation></xsl:if>
			</rdf:Description>
		</xsl:when>	
		<xsl:otherwise>
		  <xsl:element name="{$role-local-name}" namespace="{$role-namespace-part}">
		  	<xsl:choose>
			 <xsl:when test="@id"><!--<xsl:attribute name="rdf:ID">--><xsl:attribute name="rdf:about"><xsl:value-of select="concat($base,'#',@id)" /></xsl:attribute></xsl:when>
			 <xsl:when test="@xml:base"><xsl:attribute name="rdf:about"><xsl:value-of select="@xml:base" /></xsl:attribute></xsl:when>
			 <xsl:when test="ancestor::*[@id]"><xsl:attribute name="rdf:about"><xsl:value-of select="$base" />#<xsl:value-of select="ancestor::*[@id][1]/@id" /></xsl:attribute></xsl:when>
			 <xsl:otherwise><xsl:attribute name="rdf:about"></xsl:attribute></xsl:otherwise>
			</xsl:choose>
			<xsl:element name="{$local-name}" namespace="{$namespace-part}">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$href" /></xsl:attribute>
			</xsl:element>
			<xsl:if test="$documentation='yes'"><rddl:documentation rdf:parseType="Literal">
				<xsl:copy-of select="*" />
			</rddl:documentation></xsl:if>
		  </xsl:element>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

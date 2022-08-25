<?xml version="1.0"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  	xmlns:rdfx="http://www.openhealth.org/RDF/RDFxtSyntax#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes='xsl rdfs rdfx xlink saxon' 
	version="1.0">
<xsl:output method="text" omit-xml-declaration="yes" media-type="text/plain"/>
<xsl:template match="/rdf:RDF">
<xsl:for-each select="namespace::*">
@prefix <xsl:value-of select="local-name()" />: <xsl:value-of select="text()" /> .
</xsl:for-each>
	<xsl:apply-templates mode="IN_RDF"/>
</xsl:template>
<xsl:template match="rdf:*" mode="IN_RDF">
ERROR: top level <xsl:value-of select="name()" />
</xsl:template>
<xsl:template name="rdf:Description|rdf:Alt|rdf:Bag|rdf:Seq|*)" mode="IN_RDF">
	<xsl:variable name="subj"><xsl:choose>
			<xsl:when test="@rdf:about">&lt;<xsl:value-of select="@rdf:about"/>&gt;</xsl:when>
			<xsl:when test="@rdf:ID">&lt;#<xsl:value-of select="@rdf:ID"/>&gt;</xsl:when>
		<xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>
	<xsl:choose>
		<xsl:when test="@rdf:about|@rdf:ID"><xsl:value-of select="$subj"/> </xsl:when>
		<xsl:otherwise>[ </xsl:otherwise>
	</xsl:choose>
	<xsl:if test="namespace-name() != '&rdf;' or local-name() != 'Description'">
a <xsl:value-of select="name()"/> ;
	</xsl:if>		
	<xsl:apply-templates select="*" mode="IN_DESCRIPTION" >
		<xsl:with-param name="subj" select="$subj"/>
	</xsl:apply-templates>
<xsl:if test="$subj=''">]</xsl:if> .
</xsl:template>
<!-- mode IN_DESCRIPTION process contents of Description and typedNode -->
<xsl:template name="*[@rdf:resource]" mode="IN_DESCRIPTION">
<xsl:value-of select="name()"/> <xsl:value-of select="&lt;{@rdf:resource}&gt;"/>
</xsl:template>
<xsl:template name="*[*]" mode="IN_DESCRIPTION">
	<xsl:variable name="obj"><xsl:choose>
			<xsl:when test="*[@rdf:about]">&lt;<xsl:value-of select="*[@rdf:about]"/>&gt;</xsl:when>
			<xsl:when test="*[@rdf:ID]">&lt;#<xsl:value-of select="*[@rdf:ID]"/>&gt;</xsl:when>
		<xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>
	<xsl:call-template name="statement">
		<xsl:with-param name="subject" select="$subj"/>
		<xsl:with-param name="predicate" select="name()"/>
		<xsl:with-param name="object" select="$obj"/>
	</xsl:call-template>
	<xsl:apply-templates select="*" mode="IN_DESCRIPTION">
		<xsl:with-param name="subject" select="$obj"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template name="*[text()]" mode="IN_DESCRIPTION">
	<xsl:call-template name="lit-predobj">
		<xsl:with-param name="subject" select="$subj"/>
		<xsl:with-param name="predicate" select="name()"/>
		<xsl:with-param name="object" select="*/text()"/>
	</xsl:call-template>
</xsl:template>
<xsl:template name="*[rdf:parseType='Literal']" mode="IN_DESCRIPTION">
	<xsl:call-template name="litxml-predobj">
		<xsl:with-param name="subject" select="$subj"/>
		<xsl:with-param name="predicate" select="name()"/>
		<xsl:with-param name="object"><xsl:copy-of select="*" /></xsl:with-param>
	</xsl:call-template>
</xsl:template>
<xsl:template name="*[rdf:parseType='Resource']" mode="IN_DESCRIPTION">
	<xsl:apply-templates select="*" mode="IN_PROPERTYRESOURCE">
		<xsl:with-param name="subj" select="$subj"/>
		<xsl:with-param name="pred" select="name()"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template name="*[rdf:RDF]" mode="IN_DESCRIPTION">
	<xsl:variable name="bundle"><xsl:choose>
			<xsl:when test="rdf:RDF[@rdf:about]">&lt;<xsl:value-of select="rdf:RDF[@rdf:about]"/>&gt;</xsl:when>
			<xsl:when test="rdf:RDF[@rdf:ID]">&lt;<xsl:value-of select="$baseURI"/>#<xsl:value-of select="rdf:RDF[@rdf:ID]"/>&gt;</xsl:when>
		<xsl:otherwise>&lt;<xsl:value-of select="$baseURI"/>#<xsl:value-of select="generate-id(*)"/>&gt;</xsl:otherwise></xsl:choose></xsl:variable>
	<xsl:value-of select="name()"/> {
	<xsl:apply-templates select="*" mode="IN_RDF"><!-- mode="IN_BUNDLE"> -->
		<xsl:with-param name="bundle" select="$bundle"/>
	</xsl:apply-templates>
	}
</xsl:template>
<!-- handle extensions -->
<xsl:template match="/*">
# root <xsl:value-of select="name()" />
<xsl:for-each select="namespace::*">
@prefix <xsl:value-of select="local-name()" />: <xsl:value-of select="text()" /> .
</xsl:for-each>
	<xsl:apply-templates select="*" mode="IN_BUNDLE"/>
</xsl:template>
<xsl:template match="rdf:*" mode="IN_BUNDLE">
	<xsl:apply-templates mode="IN_RDF"/>
</xsl:template>
<xsl:template match="*" mode="IN_BUNDLE">
	<xsl:variable name="pred" select="name()"/>
	<xsl:for-each select="*">{ <xsl:choose>
		<xsl:when test="*[*]"><xsl:apply-templates mode="IN_BUNDLE"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="name()" /> </xsl:otherwise>
	</xsl:choose> } <xsl:if test="index() != last()"><xsl:value-of select="$pred" /></xsl:if>
	</xsl:for-each> .
</xsl:template>
<xsl:template match="rdf:*|*[@rdf:about|@rdf:ID]" mode="IN_BUNDLE">
	<xsl:variable name="subj"><xsl:choose>
			<xsl:when test="@rdf:about">&lt;<xsl:value-of select="@rdf:about"/>&gt;</xsl:when>
			<xsl:when test="@rdf:ID">&lt;<xsl:value-of select="$baseURI"/>#<xsl:value-of select="@rdf:ID"/>&gt;</xsl:when>
		<xsl:otherwise>&lt;<xsl:value-of select="$baseURI"/>#<xsl:value-of select="generate-id()"/>&gt;</xsl:otherwise></xsl:choose></xsl:variable>
	<xsl:if test="namespace-name() != '&rdf;' or local-name() != 'Description'">
		<xsl:call-template name="statement">
			<xsl:with-param name="subject" select="$subj"/>
			<xsl:with-param name="predicate"select="rdf:type"/>
			<xsl:with-param name="object" select="name()"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:apply-templates select="*" mode="IN_DESCRIPTION" >
		<xsl:with-param name="subj" select="$subj"/>
	</xsl:apply-templates>
</xsl:template>
</xsl:stylesheet>
<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="http://www.openhealth.org/ASTM/operative.report">

<xsl:param name="TXNID">dummy</xsl:param>
<xsl:param name="TXNSTATE">SIGNED</xsl:param>
<xsl:param name="description"></xsl:param>
<xsl:include href="opnote-base.xsl" />

<xsl:template name="organization"><organization><xsl:choose><xsl:when test="@hospital"><xsl:value-of select="@hospital" /></xsl:when><xsl:otherwise>New England Medical Center</xsl:otherwise></xsl:choose></organization>
</xsl:template>
<xsl:template name="cpt"><xsl:call-template name="parse-values"><xsl:with-param name="values" select="@cpt" /><xsl:with-param name="codesystem">CPT</xsl:with-param></xsl:call-template></xsl:template>
<xsl:template name="providers"
	xmlns="http://www.openhealth.org/ASTM/clinical.header">
	<xsl:call-template name="surgeon"><xsl:with-param name="fullname" select="@surgeon" /></xsl:call-template>
	<xsl:call-template name="assistant"><xsl:with-param name="fullname" select="@assistant" /></xsl:call-template>
</xsl:template>
<xsl:template name="anesthesia"><anesthesia><xsl:choose><xsl:when test="@anesthesia"><xsl:value-of select="@anesthesia" /></xsl:when><xsl:otherwise>Local/IV</xsl:otherwise></xsl:choose></anesthesia></xsl:template>
<xsl:template name="preop-diagnosis"><preoperative.diagnosis><xsl:value-of select="@preop-diagnosis" /></preoperative.diagnosis></xsl:template>
<xsl:template name="postop-diagnosis"><postoperative.diagnosis><xsl:value-of select="@postop-diagnosis" /></postoperative.diagnosis></xsl:template>
<xsl:template name="procedure"><procedure><xsl:value-of select="@procedure" /></procedure></xsl:template><!--<procedure>***OVERRIDE REQUIRED***</procedure>-->
--<xsl:template name="date"><date><xsl:value-of select="@date" /></date></xsl:template>
<xsl:template name="indications"><indications><xsl:call-template name="parse-paras"><xsl:with-param name="paras" select="@indications" /></xsl:call-template></indications></xsl:template>
<xsl:template name="description"><description><xsl:call-template name="parse-paras"><xsl:with-param name="paras" select="$description" /></xsl:call-template></description></xsl:template>


</xsl:stylesheet>
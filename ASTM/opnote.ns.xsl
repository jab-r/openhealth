<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
		xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:o="http://www.openhealth.org/ASTM/operative.report"
		xmlns:ch="http://www.openhealth.org/ASTM/clinical.header"
		xmlns:html="http://www.w3.org/1999/xhtml">

<xsl:output method="html" version="4.0" />
<xsl:variable name="patname"><xsl:choose><xsl:when test="o:operative.report/ch:clinical.header/ch:patient/ch:person.name[ch:family]"><xsl:value-of select="o:operative.report/ch:clinical.header/ch:patient/ch:person.name/ch:family" />, <xsl:value-of select="o:operative.report/ch:clinical.header/ch:patient/ch:person.name/ch:given" /></xsl:when><xsl:otherwise><xsl:value-of select="o:operative.note/ch:clinical.header/ch:patient/ch:person.name" /></xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="pat-id" select="o:operative.report/ch:clinical.header/ch:patient/ch:id" />
<xsl:param name="TXNID" >dummy</xsl:param>
<xsl:template match="/o:operative.report" >
<html>
<head>
<title>OPERATIVE NOTE: <xsl:value-of select="$patname" />:<xsl:value-of select="$pat-id" /></title>
<!--<link href="../opnote/openhealth.css" rel="STYLESHEET" type="text/css" />-->
</head>
<body>
<h2><xsl:value-of select="ch:clinical.header/ch:patient.encounter/ch:location" /></h2>
<h2>OPERATIVE NOTE</h2>
<h2>Patient:
<span class="patient-name"><xsl:value-of select="$patname" /></span>-<span class="patient-id"><xsl:value-of select="$pat-id" /></span>
</h2>
<h3>Procedure: <span class="procedure"><xsl:value-of select="o:clinical.body/o:procedure" /></span></h3>
<p>CPT: <span class="CPT"><xsl:for-each select="ch:clinical.header/ch:codes/ch:coded.value[@code.system='CPT']"><xsl:if test="position()>1">,</xsl:if><xsl:value-of select="."/></xsl:for-each></span></p>
<h3>Preoperative Diagnosis: <span class="pre-op-diagnosis"><xsl:value-of select="o:clinical.body/o:preoperative.diagnosis" /></span></h3>
<h3>Postoperative Diagnosis: <span class="post-op-diagnosis"><xsl:value-of select="o:clinical.body/o:postoperative.diagnosis" /></span></h3>
<h3>Operative Date: <span class="date"><xsl:value-of select="ch:clinical.header/ch:patient.encounter/ch:date.time" /></span></h3>
<h3>Surgeon: <span class="surgeon"><xsl:value-of select="ch:clinical.header/ch:provider[ch:function='Surgeon']/ch:person.name" /></span></h3>
<h3>Assistant: <span class="assistant"><xsl:value-of select="ch:clinical.header/ch:provider[ch:function='Assistant']/ch:person.name" /></span></h3>
<h3><b>Anesthesia: </b><span class="anesthesia"><xsl:value-of select="o:clinical.body/o:anesthesia" /></span></h3>
<p><b>Indications:</b></p><span class="indications"><xsl:copy-of select="o:clinical.body/o:indications/*" /></span>
<p><b>Description of Procedure: </b></p>
<span class="description"><xsl:copy-of select="o:clinical.body/o:description/*" /></span>
<br/><br/><br/>
<p>-------------------------------</p>
<p><xsl:value-of select="ch:clinical.header/ch:provider[ch:function='Surgeon']/ch:person.name" /></p>
</body>
</html>
</xsl:template>

<xsl:template match="o:patient/o:name"><xsl:choose><xsl:when test="o:last"><xsl:value-of select="o:last" />, <xsl:value-of select="o:first" /></xsl:when><xsl:otherwise><xsl:value-of select="." /></xsl:otherwise></xsl:choose></xsl:template>
<xsl:template match="o:id"><xsl:apply-templates/></xsl:template>
<xsl:template match="o:name"><xsl:apply-templates/></xsl:template>
<xsl:template match="o:value"><xsl:apply-templates/></xsl:template>
<xsl:template match="p"><xsl:apply-templates/></xsl:template>
<xsl:template match="o:description"><xsl:apply-templates/></xsl:template>
<xsl:template match="o:indications"><xsl:apply-templates/></xsl:template>
<xsl:template match="o:procedure"><xsl:apply-templates/></xsl:template>
<xsl:template match="o:date"><xsl:apply-templates/></xsl:template>
<xsl:template match="o:cpt"><xsl:apply-templates/></xsl:template>
<xsl:template name="parse-paras">
	<xsl:param name="paras" select="/.."/>
	<xsl:choose>
		<xsl:when test="contains($paras,'&#xA;')"><p><xsl:value-of select="substring-before($paras,'&#xA;')" /></p><xsl:call-template name="parse-paras"><xsl:with-param name="paras" select="substring-after($paras,'&#xA;')"/></xsl:call-template></xsl:when>
		<xsl:otherwise><html:p><xsl:value-of select="$paras" /></html:p></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

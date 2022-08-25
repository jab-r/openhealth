<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="http://www.openhealth.org/ASTM/operative.report"
				>
<xsl:param name="TXNID">dummy</xsl:param>
<xsl:param name="TXNSTATUS">CREATED</xsl:param>
<xsl:template match="/"><xsl:apply-templates select="opnote"/></xsl:template>
<xsl:template match="opnote">
<xsl:processing-instruction name="xml-stylesheet">href="../opnote.xsl" type="text/xsl"</xsl:processing-instruction>
<xsl:call-template name="operative-report"/>
</xsl:template>
<xsl:template name="operative-report">
<operative.report 
		xmlns="http://www.openhealth.org/ASTM/operative.report"
		xmlns:xhtml="http://www.w3.org/1999/xhtml">
	<xsl:call-template name="clinical-header" />
	<xsl:call-template name="body" />
</operative.report>
</xsl:template>
<xsl:template name="clinical-header"
	xmlns="http://www.openhealth.org/ASTM/clinical.header">
<clinical.header>
	<xsl:call-template name="providers" />
	<xsl:call-template name="patient" />
	<xsl:call-template name="encounter" />
	<xsl:call-template name="events" />
	<xsl:call-template name="codes" />
</clinical.header>
</xsl:template>
<xsl:template name="patient"
	xmlns="http://www.openhealth.org/ASTM/clinical.header">
<patient>
		<person.name>
			<xsl:choose>
				<xsl:when test="@lastname" >
					<given><xsl:value-of select="@firstname" /></given>
					<family><xsl:value-of select="@lastname" /></family>
				</xsl:when>
				<xsl:otherwise><family><xsl:value-of select="@Patient" /></family></xsl:otherwise>
			</xsl:choose>
		</person.name>
		<id type="patient-identifier"><xsl:attribute name="authority"><xsl:call-template name="organization" /></xsl:attribute><xsl:value-of select="@patientid" /></id>
</patient>
</xsl:template>
<xsl:template name="organization">
	<xsl:choose><xsl:when test="@Hospital"><xsl:value-of select="@Hospital" /></xsl:when><xsl:otherwise>New England Medical Center</xsl:otherwise></xsl:choose>
</xsl:template>
<!--<cpt>***OVERRIDE REQUIRED***</cpt>-->
<xsl:template name="providers"
	xmlns="http://www.openhealth.org/ASTM/clinical.header">
	<xsl:call-template name="surgeon"><xsl:with-param name="fullname" select="@Physician" /></xsl:call-template>
	<xsl:call-template name="assistant"><xsl:with-param name="fullname" select="@Resident" /></xsl:call-template>
</xsl:template>
<xsl:template name="surgeon"
	xmlns="http://www.openhealth.org/ASTM/clinical.header">
	<xsl:param name="fullname" />
	<provider>
		<type.code>Attending</type.code>
		<function>Surgeon</function>
		<person.name><family type="full"><xsl:value-of select="$fullname" /></family></person.name>
	</provider>
</xsl:template>
<xsl:template name="assistant"
	xmlns="http://www.openhealth.org/ASTM/clinical.header">
	<xsl:param name="fullname" />
	<provider>
		<type.code>Resident</type.code>
		<function>Assistant</function>
		<person.name><family type="full"><xsl:value-of select="$fullname" /></family></person.name>
	</provider>
</xsl:template>
<xsl:template name="encounter" xmlns="http://www.openhealth.org/ASTM/clinical.header">
<patient.encounter>
	<practice.setting>Operating Suite</practice.setting>
	<date.time><xsl:value-of select="@Date" /></date.time>
	<location><xsl:call-template name="organization"/></location>
</patient.encounter>
</xsl:template>
<xsl:template name="events" xmlns="http://www.openhealth.org/ASTM/clinical.header">
	<events>
		<event><event.name><xsl:value-of select="$TXNSTATUS" /></event.name><date.time></date.time><comments><xsl:value-of select="$TXNID" /></comments></event>
	</events>
</xsl:template>
<xsl:template name="codes" xmlns="http://www.openhealth.org/ASTM/clinical.header">
 <codes>
	<xsl:call-template name="cpt" />
 </codes>
</xsl:template>
<xsl:template name="body">
<clinical.body>
	<xsl:call-template name="preop-diagnosis"/>
	<xsl:call-template name="postop-diagnosis"/>
	<xsl:call-template name="procedure"/>
	<xsl:call-template name="anesthesia"/>
	<xsl:call-template name="indications"/>
	<xsl:call-template name="description"/>
</clinical.body>
</xsl:template>
<xsl:template name="anesthesia"><anesthesia><xsl:choose><xsl:when test="@Anesthesia"><xsl:value-of select="@Anesthesia" /></xsl:when><xsl:otherwise>Local/IV</xsl:otherwise></xsl:choose></anesthesia></xsl:template>
<xsl:template name="preop-diagnosis"><preoperative.diagnosis><xsl:value-of select="@Diagnosis" /></preoperative.diagnosis></xsl:template>
<xsl:template name="postop-diagnosis"><postoperative.diagnosis>same</postoperative.diagnosis></xsl:template>
<!--<procedure>***OVERRIDE REQUIRED***</procedure>-->
<xsl:template name="indications"><indications><xsl:value-of select="@Indications" /></indications></xsl:template>
<xsl:template name="description"><description><xsl:value-of select="@description" /></description></xsl:template>
<!-- functions -->
<xsl:template name="parse-values">
	<xsl:param name="values" select="/.."/>
	<xsl:param name="codesystem" />
	<xsl:choose>
		<xsl:when test="contains($values,',')"><coded.value code.system.name="{$codesystem}"><xsl:value-of select="substring-before($values,',')" /></coded.value><xsl:call-template name="parse-values"><xsl:with-param name="values" select="substring-after($values,',')"/></xsl:call-template></xsl:when>
		<xsl:otherwise><coded.value code.system.name="CPT"><xsl:value-of select="$values" /></coded.value></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template name="parse-paras" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:param name="paras" select="/.."/>
	<xsl:choose>
		<xsl:when test="starts-with($paras,'&#xD;&#xA;')"><xsl:call-template name="parse-paras"><xsl:with-param name="paras" select="substring-after($paras,'&#xD;&#xA;')"/></xsl:call-template></xsl:when>
		<xsl:when test="contains($paras,'&#xD;&#xA;')"><p><xsl:value-of select="substring-before($paras,'&#xD;&#xA;')" /></p><xsl:call-template name="parse-paras"><xsl:with-param name="paras" select="substring-after($paras,'&#xD;&#xA;')"/></xsl:call-template></xsl:when>
		<xsl:otherwise><p><xsl:value-of select="$paras" /></p></xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
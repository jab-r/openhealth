<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
		xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:o="http://www.openhealth.org/ASTM/operative.report"
		xmlns:ch="http://www.openhealth.org/ASTM/clinical.header"
		xmlns:html="http://www.w3.org/1999/xhtml">
<xsl:output method="html" version="4.0" />
<xsl:param name="TXNSTATE">SIGNED</xsl:param>
<xsl:variable name="patname"><xsl:choose><xsl:when test="o:operative.report/ch:clinical.header/ch:patient/ch:person.name[ch:given]"><xsl:value-of select="o:operative.report/ch:clinical.header/ch:patient/ch:person.name/ch:family" />, <xsl:value-of select="o:operative.report/ch:clinical.header/ch:patient/ch:person.name/ch:given" /></xsl:when><xsl:otherwise><xsl:value-of select="o:operative.report/ch:clinical.header/ch:patient/ch:person.name/ch:family" /></xsl:otherwise></xsl:choose></xsl:variable>
<xsl:template match="/o:opnote">
<html>
<head>
<title>OPERATIVE NOTE: <xsl:value-of select="$patname" />:<xsl:value-of select="ch:clinical.header/ch:patient/ch:id[@type='patient.identifier']" /></title>
<link href="../opnote/openhealth.css" rel="STYLESHEET" type="text/css" />
</head>
<body>
<h2><xsl:value-of select="ch:clinical.header/ch:patient.encounter/ch:location" /></h2>
<h2>OPERATIVE NOTE</h2>
<form action="SignOpnote" method="POST">
<input type="hidden" name="TXNID" value="{o:TXN/@ID}"/>
<input type="hidden" name="TXNSTATE" value="{$TXNSTATE}"/>
<input type="hidden" name="form" value="no" />
<input type="hidden" name="style" value="opnote-signed.xsl"/>
<input type="hidden" name="result" value="opnote.xsl"/>
<table>
<tr><td>Hospital: </td><td><input type="Text" name="hospital" size="64" maxlength="64" value="{ch:clinical.header/ch:patient.encounter/ch:location}" /></td></tr>
<xsl:choose>
<xsl:when test="o:patient/o:name[o:last]">
<tr><td>Patient:</td><td><input type="Text" name="lastname" size="31" maxlength="64"><xsl:attribute name="value"><xsl:value-of select="o:patient/o:name/o:last" /></xsl:attribute></input>,<input type="Text" name="firstname" size="31" maxlength="64"><xsl:attribute name="value"><xsl:value-of select="o:patient/o:name/o:first" /></xsl:attribute></input></td></tr>
</xsl:when>
<xsl:otherwise>
<tr><td>Patient:</td><td><input type="Text" name="name" size="48" maxlength="64"><xsl:attribute name="value"><xsl:value-of select="$patname" /></xsl:attribute></input></td></tr>
</xsl:otherwise></xsl:choose>
<tr><td>ID:</td><td><input type="Text" name="patientid" size="32" value="{ch:clinical.header/ch:patient/ch:id[@type='patient.identifier']}" /></td></tr>
<tr><td>Procedure: </td><td><input type="Text" name="procedure" size="80" maxlength="255" value="{o:procedure}" /></td></tr>
<tr><td>CPT: </td><td><input type="Text" name="cpt" size="48" maxlength="255"><xsl:attribute name="value"><xsl:for-each select="o:cpt/o:value" xml:space="preserve"><xsl:if test="position()>1">,</xsl:if><xsl:value-of select="."/></xsl:for-each></xsl:attribute></input></td></tr>
<tr><td>Preoperative Diagnosis: </td><td><input type="Text" name="preop-diagnosis" size="48" maxlength="255" value="{o:preop-diagnosis}" /></td></tr>
<tr><td>Postoperative Diagnosis: </td><td><input type="Text" name="postop-diagnosis" size="48" maxlength="255" value="{o:postop-diagnosis}" /></td></tr>
<tr><td>Operative Date: </td><td><input type="Text" name="date" size="48" maxlength="255" value="{o:date}" /></td></tr>
<tr><td>Surgeon: </td><td><input type="Text" name="surgeon" size="48" maxlength="255" value="{o:surgeon}" /></td></tr>
<tr><td>Assistant: </td><td><input type="Text" name="assistant" size="48" maxlength="255" value="{o:assistant}" /></td></tr>
<tr><td>Anesthesia: </td><td><input type="Text" name="anesthesia" size="48" maxlength="255" value="{o:anesthesia}" /></td></tr>
</table>
<p><b>Indications:</b></p><p> <textarea name="indications" cols="80" rows="10"><xsl:for-each select="o:indications//html:p" xml:space="default"><xsl:value-of select="." />&#xA;&#xA;</xsl:for-each></textarea></p>
<p><b>Description of Procedure: </b></p><p><textarea name="description" cols="80" rows="40"><xsl:for-each select="o:description//html:p" xml:space="preserve"><xsl:value-of select="." />&#xA;&#xA;</xsl:for-each></textarea></p>
<input type="Submit" name="Submit" value="Submit" />
</form>
</body>
</html>
</xsl:template>
<xsl:template match="o:patient/name"><xsl:choose><xsl:when test="o:last"><xsl:value-of select="o:last" />, <xsl:value-of select="o:first" /></xsl:when><xsl:otherwise><xsl:value-of select="." /></xsl:otherwise></xsl:choose></xsl:template>
</xsl:stylesheet>
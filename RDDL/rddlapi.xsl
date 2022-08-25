<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:rddl="http://www.rddl.org/">
<xsl:param name="role">http://www.rddl.org/arcroles.htm#RDFS</xsl:param>
<xsl:param name="arcrole" />
<xsl:template match="/"><xsl:apply-templates select="*"/></xsl:template>
<xsl:template match="xhtml:html"><xsl:apply-templates select="//rddl:resource"/></xsl:template>
<xsl:template match="*"><rddl:error>Non RDDL document - root namespace: '<xsl:value-of select="namespace-uri(.)" />'</rddl:error></xsl:template>
<xsl:template match="rddl:resource">
<xsl:choose><xsl:when test="(not($role) or ($role = @xlink:role) and (not($arcrole) or ($arcrole = @xlink:arcrole))"><xsl:copy-of select="document(@xlink:href)" /></xsl:when></xsl:choose>
</xsl:template>
</xsl:stylesheet>

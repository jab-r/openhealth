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
<xsl:variable name="baseURI">
	<xsl:choose>
		<xsl:when test="/ht:html[@xml:base]"><xsl:value-of select="/ht:html/@xml:base" /></xsl:when>
		<xsl:when test="function-available('saxon:system-id')"><xsl:value-of select="saxon:system-id()" /></xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template match="/">
<html>
	<head>
		<title>RDDL: <xsl:value-of select="$baseURI" /></title>
	</head>
	<body>
		<table width="100%" border="1">
		<colgroup><col width="16%" /><col width="16%" /><col width="16%" /><col width="16%" /><col width="16%" /><col width="16%" /><col width="16%" /></colgroup>
      	<tr><th>id</th>
			<th>nature</th>
			<th>purpose</th>
			<th>href</th>
			<th>title</th>
			<th>lang</th>
			<th>baseURI</th>
		</tr>
		<xsl:apply-templates select="//rddl:resource"/>
		</table>
	</body>
</html>
</xsl:template>
<xsl:template match="rddl:resource">
	<xsl:variable name="id">
		<xsl:choose>
			<xsl:when test="@id"><xsl:value-of select="@id" /></xsl:when>
			<xsl:when test="ancestor::ht:div[@id]"><xsl:value-of select="ancestor::ht:div[@id][1]/@id" /></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="base">
		<xsl:choose>
			<xsl:when test="@xml:base"><xsl:value-of select="@xml:base" /></xsl:when>
			<xsl:when test="ancestor::*[@xml:base]"><xsl:value-of select="ancestor::*[@xml:base][1]/@xml:base" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$baseURI" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="lang">
		<xsl:choose>
			<xsl:when test="@xml:lang"><xsl:value-of select="@xml:lang" /></xsl:when>
			<xsl:when test="ancestor::*[@xml:lang]"><xsl:value-of select="ancestor::*[@xml:lang][1]/@xml:lang" /></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<tr>
		<td><a><xsl:attribute name="href"><xsl:value-of select="$base" />#<xsl:value-of select="$id" /></xsl:attribute><xsl:value-of select="$id" /></a></td>
		<td><a href="{@xlink:role}"><xsl:value-of select="@xlink:role" /></a></td>
		<td><a href="{@xlink:arcrole}"><xsl:value-of select="@xlink:arcrole" /></a></td>
		<td><a href="{@xlink:href}"><xsl:value-of select="@xlink:href" /></a></td>
		<td><xsl:value-of select="@xlink:title" /></td>
		<td><xsl:value-of select="$lang" /></td>
		<td><xsl:value-of select="$base" /></td>
	</tr>

</xsl:template>
</xsl:stylesheet>

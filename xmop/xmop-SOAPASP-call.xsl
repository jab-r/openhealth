<?xml version="1.0" ?>
<!--
Copyright (c) 2000 Jonathan Borden ALL RIGHTS RESERVED

This XSLT program generates a javascript proxy given an XMOP definition document for use on Microsoft IE5
  
You can redistribute this program and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

The GPL is available at http://www.gnu.org/copyleft/gpl.html

If not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

For a license under other than GPL contact the author at jborden@mediaone.net
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:SOAP="urn:schemas-xmlsoap-org:soap.v1">
<xsl:output
  method = "xml" 
  version = "1.0" 
  omit-xml-declaration = "yes"
  standalone = "yes"
  cdata-section-elements = "style" 
  indent = "no" 
  media-type = "text/javascript" /> 
<xsl:template match="/">
<xsl:apply-templates select="/SOAP:Envelope" />
</xsl:template>
<xsl:template match="/SOAP:Envelope">
<xsl:apply-templates select="SOAP:Body" />
</xsl:template>
<xsl:template match="SOAP:Body">
<xsl:apply-templates select="*"/>
</xsl:template>
<xsl:template match="*">
	<xsl:variable name="end" select="count(child::*)" />
	<xsl:variable name="progid" select="substring-after(namespace-uri(),'http://www.grovelogic.com/SOAP/class/')" />
	var obj = Server.CreateObject(&quot;<xsl:value-of select="translate($progid,';&quot;-+=,','..___ ')" />&quot;);
	res = obj.<xsl:value-of select="local-name()" />(<xsl:for-each select="*"><xsl:if test="position() > 1">,</xsl:if>'<xsl:value-of />'</xsl:for-each>);
</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" ?>
<!--
Copyright (c) 2000 Jonathan Borden ALL RIGHTS RESERVED

  
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:SOAP="urn:schemas-xmlsoap-org:soap.v1"
				version="1.0">
<xsl:param name="res"/>
<xsl:template match="/"><xsl:apply-templates select="/methodCall"/></xsl:template>
<xsl:template match="/methodCall">
<SOAP:Envelope xmlns:SOAP="urn:schemas-xmlsoap-org:soap.v1">
<SOAP:Body>
<xsl:apply-templates select="*"/>
</SOAP:Body>
</SOAP:Envelope>
</xsl:template>
<xsl:template match="*"><xsl:for-each select="*"><xsl:copy><return><xsl:value-of select="/methodCall/result" /></return></xsl:copy>
</xsl:for-each></xsl:template>
</xsl:stylesheet>

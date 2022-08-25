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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output
  method = "xml" 
  version = "1.0" 
  omit-xml-declaration = "yes"
  standalone = "no"
  cdata-section-elements = "style" 
  indent = "yes" 
  media-type = "text/javascript" /> 
<xsl:template match="/">
<xsl:comment>
<xsl:apply-templates select="/objectDef" />
</xsl:comment>
</xsl:template>
<xsl:template match="/objectDef">
function <xsl:value-of select="translate(@name,'.','_')" />(loc){
	this.where = loc;
<xsl:apply-templates select="interfaceDef" />
};
</xsl:template>
<xsl:template match="interfaceDef">
<xsl:apply-templates select="method" />
</xsl:template>
<xsl:template match="method">
this.<xsl:value-of select="@name" /> = function(
<xsl:for-each select="param"><xsl:if test="position() > 1">,</xsl:if><xsl:value-of select="@name" /></xsl:for-each>
){
var uri = "http://www.grovelogic.com/SOAP/ProgID/<xsl:value-of select="/objectDef/@name" />";

var methnuri = uri+"#<xsl:value-of select="@name" />";
var methn = "m:<xsl:value-of select="@name" />";

var dom = new ActiveXObject("MSXML2.DOMDocument");
// dom.loadXML('&lt;SOAP:Envelope xmlns:SOAP="urn:schemas-xmlsoap-org:soap.v1"&gt;&lt;/SOAP:Envelope&gt;')
var env = dom.createNode(1,"SOAP:Envelope","urn:schemas-xmlsoap-org:soap.v1");
dom.documentElement = env;
var bod = dom.createNode(1,"SOAP:Body","urn:schemas-xmlsoap-org:soap.v1");
var meth = dom.createNode(1,methn,uri);
var par = null;
var tex = null;
<xsl:for-each select="param">
	par = dom.createElement("<xsl:value-of select="@name" />");
	tex = dom.createTextNode(<xsl:value-of select="@name" />);
	par.appendChild(tex);
	meth.appendChild(par);
</xsl:for-each>
bod.appendChild(meth);
env.appendChild(bod);
var call = new ActiveXObject("Microsoft.XMLHTTP");
call.open("POST",this.where,false);
call.setRequestHeader("SOAPMethodName",methnuri);
call.send(dom);
return call.responseText;
};
</xsl:template>
</xsl:stylesheet>
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
<xsl:variable name="end" select="count(child::param)" />
this.<xsl:value-of select="@name" /> = function(
<xsl:for-each select="param"><xsl:value-of select="@name" /><xsl:if test="position() != $end">,</xsl:if></xsl:for-each>
){
var uri = "http://www.grovelogic.com/XMLRPC/ProgID/<xsl:value-of select="/objectDef/@name" />";

var methnuri = uri+"#<xsl:value-of select="@name" />";

var dom = new ActiveXObject("MSXML2.DOMDocument");

var env = dom.createElement("methodCall");
dom.documentElement = env;
var meth = dom.createElement("methodName");
meth.appendChild(dom.createTextNode(methnuri));
var params = dom.createElement("params");
var par = null;
var tex = null;
<xsl:for-each select="param">
	par = dom.createElement("value");
	val = dom.createElement("<xsl:value-of select="@type" />");
	tex = dom.createTextNode(<xsl:value-of select="@name" />);
	val.appendChild(tex);
	par.appendChild(val);
	params.appendChild(par);
</xsl:for-each>
env.appendChild(meth);
env.appendChild(params);
var call = new ActiveXObject("Microsoft.XMLHTTP");
call.open("POST",this.where,false);
call.send(dom);
return call.responseText;
};
</xsl:template>
</xsl:stylesheet>
<%@ Transaction="Required" Language="JavaScript" %>
<%
/*
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
*/
    // The Transacted Script Abort Handler.  This sub-routine
    // will be called if the script transacted aborts

try{
	Response.Buffer = true;	
	Response.Clear();
	Response.ContentType = "text/xml";

	var dom = Server.CreateObject("MSXML2.DOMDocument");
	dom.async = false;
	dom.load(Request);

	var xf = Server.CreateObject("MSXML2.DOMDocument");
	xf.async = false;
	xf.load(Server.MapPath("xmop-SOAPASP-call.xsl"));
	var call = dom.transformNode(xf);

	var res;
	eval(call);
	var xfr = Server.CreateObject("MSXML2.DOMDocument");
	xfr.async = false;
	xfr.load(Server.MapPath("soapresult.xsl"));
	var resnode = dom.createElement("result");
	var txt = dom.createTextNode(res+"");
	resnode.appendChild(txt);
	dom.documentElement.appendChild(resnode);
	var soapres = dom.transformNode(xfr);
	Response.Write(soapres);
	ObjectContext.SetComplete();
	Response.End();
} catch(exception) {
		Response.Clear();
%>
<SOAP:Envelope xmlns:SOAP="urn:schemas-xmlsoap-org:soap.v1">
    <SOAP:Body>
        <SOAP:Fault>
            <faultcode><%=  exception.number %></faultcode>
            <faultstring>
                <%= exception.description %>
            </faultstring>
            <runcode>1</runcode>
        </SOAP:Fault>
    </SOAP:Body>
</SOAP:Envelope>
<%
	Response.Flush();
	Response.End();
};
%>
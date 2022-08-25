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
	Response.Buffer = true;
	Response.Clear();
	// Response.ContentType = "text/plain";
	var progid = Request.QueryString("class");
	var mbfact = Server.CreateObject("XTRIME.MBXMLFactory.1");
	var sxmop = 	mbfact.TypeDescription(progid);
	var xxmop = Server.CreateObject("MSXML2.DOMDocument");
	xxmop.loadXML(sxmop);
	var xsl = Server.CreateObject("MSXML2.DOMDocument");
	xsl.async = false;
	xsl.load(Server.MapPath("xmop_IEproxygen.xsl"));
	Response.Write(xxmop.transformNode(xsl));
	Response.Flush();
	Response.End();

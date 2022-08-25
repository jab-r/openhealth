<%@ Transaction="Required" LANGUAGE="JSCRIPT" %>
<!--#include file="adojavas.inc"-->
<html>
<head>
</head>
<body>
<%

    // Access Provider
    // NOTE:  UID and PWD syntax cannot be used here
	Response.Buffer = true;
	var conn = Server.CreateObject( "ADODB.Connection" );
	conn.Open( "PROVIDER=Microsoft.Jet.OLEDB.3.51;" +
              "DATA SOURCE=d:/inetpub/wwwroot/xmop/xmop-signup.mdb;" +
              "USER ID=;PASSWORD=;");
	var rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("signup",conn,adOpenKeyset,adLockOptimistic,adCmdTable);
	while (!rs.EOF) {
%>
	<table>
	<tr><td><%= rs("LastName") %></td><td><%= rs("E-mail") %></td></tr>
%<
	//var oxml = ObjectContext.CreateObject("JABR.XMLRS");
	//oxml.AutoFormat(rs);
	//oxml.DTD = false;
	//oxml.DocType = "Testers";
	//oxml.ItemName = "Tester";
	//oxml.OutputHeader = false;
	//oxml.AutoFormat(rs);
		rs.MoveNext();
	};
%>
	</table></body></html>
<%
	ObjectContext.SetComplete();
	//oxml = null;
	rs = null;
	conn = null;
    function OnTransactionCommit()
    {
	//	Response.ContentType = "text/xml";
    };
    // The Transacted Script Abort Handler.  This sub-routine
    // will be called if the script transacted aborts

    function OnTransactionAbort()
    {
	Response.Write("<p>Error accessing database</p>");
    };
	};
%>
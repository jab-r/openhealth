/*

  convert.js
  
  Windows Scripting Host file for running the xsl-xslt-converter.xslt
  stylesheet.
  
  Parameters:  xsl-stylesheet-file [xslt-output-file]
  
  Author: Jonathan Marsh <jmarsh@microsoft.com>
  Copyright 2000 Microsoft Corp.
  
*/

var args = WScript.arguments;
if (args.length != 3 && args.length !=2)
  alert("parameters are: xml-file xsl-stylesheet-file [xslt-output-file]");
else
{
  var ofs = WScript.CreateObject("Scripting.FileSystemObject");

  var src = ofs.GetAbsolutePathName(args.item(0));
  var converter = ofs.GetAbsolutePathName(args.item(1));
  if (args.length < 3)
    var dest = ofs.getAbsolutePathName(args.item(1)) + "t";
  else
    var dest = ofs.getAbsolutePathName(args.item(2));
  
  var oXML = new ActiveXObject("MSXML2.DOMDocument");
  oXML.validateOnParse = false;
  oXML.async = false;
  oXML.preserveWhiteSpace = true;
  oXML.load(src);

  var oXSL = new ActiveXObject("MSXML2.DOMDocument");
  oXSL.validateOnParse = false;
  oXSL.async = false;
  oXSL.load(converter);

  var oFile = ofs.CreateTextFile(dest);
  oFile.Write(oXML.transformNode(oXSL));
  oFile.Close();
}
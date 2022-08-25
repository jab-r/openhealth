<script type="text/javascript">
<!--

function XTRIME_MBXMLFactory_1(loc){
	this.where = loc;

this.CreateInstance = function(
ProgID
){
var uri = "http://www.grovelogic.com/SOAP/XTRIME.MBXMLFactory.1;

var methnuri = uri+"#CreateInstance";
var methn = "m:CreateInstance";

var dom = new ActiveXObject("MSXML2.DOMDocument");
// dom.loadXML('<SOAP:Envelope xmlns:SOAP="urn:schemas-xmlsoap-org:soap.v1"></SOAP:Envelope>')
var env = dom.createNode(1,"SOAP:Envelope","urn:schemas-xmlsoap-org:soap.v1");
dom.documentElement = env;
var bod = dom.createNode(1,"SOAP:Body","urn:schemas-xmlsoap-org:soap.v1");
var meth = dom.createNode(1,methn,uri);
var par = null;
var tex = null;

	par = dom.createElement("ProgID");
	tex = dom.createTextNode(ProgID);
	par.appendChild(tex);
	meth.appendChild(par);

bod.appendChild(meth);
env.appendChild(bod);
var call = new ActiveXObject("Microsoft.XMLHTTP");
call.open("POST",this.where,false);
call.setRequestHeader("SOAPMethodName",methnuri);
call.send(dom);
return call.responseXML;
};

this.Attach = function(
pObject
){
var uri = "http://www.grovelogic.com/SOAP/XTRIME.MBXMLFactory.1;

var methnuri = uri+"#Attach";
var methn = "m:Attach";

var dom = new ActiveXObject("MSXML2.DOMDocument");
// dom.loadXML('<SOAP:Envelope xmlns:SOAP="urn:schemas-xmlsoap-org:soap.v1"></SOAP:Envelope>')
var env = dom.createNode(1,"SOAP:Envelope","urn:schemas-xmlsoap-org:soap.v1");
dom.documentElement = env;
var bod = dom.createNode(1,"SOAP:Body","urn:schemas-xmlsoap-org:soap.v1");
var meth = dom.createNode(1,methn,uri);
var par = null;
var tex = null;

	par = dom.createElement("pObject");
	tex = dom.createTextNode(pObject);
	par.appendChild(tex);
	meth.appendChild(par);

bod.appendChild(meth);
env.appendChild(bod);
var call = new ActiveXObject("Microsoft.XMLHTTP");
call.open("POST",this.where,false);
call.setRequestHeader("SOAPMethodName",methnuri);
call.send(dom);
return call.responseXML;
};

};
-->
</script>

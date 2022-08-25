<!--
	Copyright (c) 2000 The Open Healthcare Group
	
	The content of ASTM Healthcare documents may include XLinks
	PUBLIC +//ASTM//ENTITIES Xlink 1.0//EN"
	SYSTEM "http://www.openhealth.org/ASTM/astm-xlink.mod"
-->
<!ENTITY % xlink.namespace.uri "'http://www.w3.org/1999/xlink'">

<!ENTITY % no.namespace.support "IGNORE">
<!ENTITY % XLINK.namespace.prefixed "INCLUDE">

<![ %no.namespace.support; [
<!ENTITY % xlink.namespace.attrib "">
]]>

<!ENTITY % xlink.namespace.attrib "xmlns:xlink CDATA #FIXED 'http://www.w3.org/1999/xlink'">

<![ %XLINK.namespace.prefixed; [
<!ENTITY % XLINK.pfx "xlink:">
<!ENTITY % XLINK.sfx ":xlink">
<!ENTITY % xlink.type.qname "xlink:type">
<!ENTITY % xlink.arcrole.qname "xlink:arcrole">
<!ENTITY % xlink.href.qname "xlink:href">

<!ENTITY % xlink.attrib "
	xlink:type (simple|extended|locator|arc|resource|title) #IMPLIED
	xlink:arcrole CDATA #IMPLIED
	xlink:href CDATA #IMPLIED
	xlink:role CDATA #IMPLIED
	xlink:title CDATA #IMPLIED
">
<!ENTITY % xlink.simple.attrib '
	xlink:type (simple|extended) "simple"
	xlink:arcrole CDATA #IMPLIED
	xlink:href CDATA #IMPLIED
	xlink:role CDATA #IMPLIED
	xlink:title CDATA #IMPLIED
'>
<!ENTITY % xlink.extended.attrib '
	xlink:from CDATA #IMPLIED
	xlink:to CDATA #IMPLIED
	xlink:label CDATA #IMPLIED
'>
]]>

<!ENTITY % XLINK.pfx "">
<!ENTITY % XLINK.sfx "">

<!ENTITY % xlink.type.qname "type">
<!ENTITY % xlink.arcrole.qname "arcrole">
<!ENTITY % xlink.href.qname "href">

<!ENTITY % xlink.attrib "
	type (simple|extended) #IMPLIED
	arcrole CDATA #IMPLIED
	href CDATA #IMPLIED
">
<!ENTITY % xlink.simple.attrib '
	type (simple|extended) "simple"
	arcrole CDATA #IMPLIED
	href CDATA #IMPLIED
'>


<?xml version="1.0" encoding="UTF-8"?>
<!-- 
	Schematron Schema for RDDL 1.0 http://www.rddl.org/
 
 Copyright (c) 20001 Jonathan Borden <jonathan@openhealth.org>

 This software is provided 'as-is', without any express or implied warranty. 
 In no event will the authors be held liable for any damages arising from 
 the use of this software.

 Permission is granted to anyone to use this software for any purpose, 
 including commercial applications, and to alter it and redistribute it freely,
 subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not claim
 that you wrote the original software. If you use this software in a product, 
 an acknowledgment in the product documentation would be appreciated but is 
 not required.

 2. Altered source versions must be plainly marked as such, and must not be 
 misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.

    Version: 20020129
-->

<schema xmlns="http://www.ascc.net/xml/schematron"
       xmlns:sch="http://www.ascc.net/xml/schematron"
       xml:lang="en"                                       
       xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance"
	   xmlns:xlink="http://www.w3.org/1999/xlink"
	   xmlns:h="http://www.w3.org/1999/xhtml"
       xsi:schemaLocation="http://www.ascc.net/xml/schematron
          http://www.ascc.net/xml/schematron/schematron1-5.xsd" >

	<title>Resource Directory Description Language (RDDL) 1.0</title>
	<ns uri="http://www.rddl.org/" prefix="rddl"/>
	<ns uri="http://www.w3.org/1999/xhtml" prefix="h"/>
	<ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
	<ns uri="http://www.ascc.net/xml/schematron" prefix="sch" />
	<ns uri="http://www.w3.org/2000/10/XMLSchema" prefix="xsd" />
	<ns uri="http://www.xml.gr.jp/xmlns/relaxCore" prefix="rlx" />
	<ns uri="http://www.xml.gr.jp/xmlns/relaxNamespace" prefix="rng" />
	<ns uri="http://www.thaiopensource.com" prefix="trx" />
	<p>RDDL contains elements from the XHTML and RDDL namespaces.</p>
	<pattern name="RDDL Elements and Required Attributes">
		<p>Rules defining occurrence rules for the RDDL resource element
 and its attributes. Note that for attributes, it is not that the attribute is being tested for existance,
 but whether it has a value.</p>
		<p>RDDL resource elements must be within the html body. </p>
		<rule context="/h:html">
			<assert test="not(@lang) or (@lang = @xml:lang)">When lang attribute is present, the value must equal the value of xml:lang.</assert>
		</rule>
  		<rule context="h:head">
			<report test=".//rddl:resource">RDDL resources must be within the html body.</report>
		</rule>
  		<rule context="h:body">
			<assert test=".//rddl:resource">There should be at least one RDDL resource in the body.</assert>
		</rule>
		<rule context="rddl:resource">
			<assert test="count(@*) = count(@id|@xml:base|@xml:lang|@xlink:title|@xlink:href|@xlink:arcrole|@xlink:role|@xlink:type|@xlink:show|@xlink:embed)"
				>The element rddl:resource should contain only the attributes id, xml:base, xml:lang, xlink:href, xlink:arcrole, xlink:role, xlink:href.</assert>
	  		<assert test="count(*)=(count(h:*)+count(rddl:*))">The rddl:resource element should only have child elements from the XHTML and RDDL namespaces.</assert>
			<assert test="not(@xlink:type) or @xlink:type='simple'">RDDL resources are simple Xlinks.</assert>
			<assert test="(not(@xlink:embed) or @xlink:embed='none') and (not(@xlink:show) or @xlink:show='none')">xlink:embed,xlink:show are not used.</assert>
			<assert test="not(@xlink:role) or contains(@xlink:role,':') or starts-with(@xlink:role,'#')">The value of xlink:role cannot be a relative URI reference.</assert>
			<assert test="not(@xlink:arcrole) or contains(@xlink:arcrole,':') or starts-with(@xlink:arcrole,'#')">The value of xlink:arcrole cannot be a relative URI reference.</assert>
			<assert test="normalize-space(.) and *">A rddl:resource should have a description.</assert>	
		</rule>
	</pattern>
	<pattern name="Flow.mix">
		<!-- Flow.mix consists of Heading.class, List.class, Block.class, Inline.class and Misc.class -->
		<rule context="h:h1|h:h2|h:h3|h:h4|h:h5|h:h6|h:ul|h:ol|h:dl|h:p|h:div|rddl:resource|h:pre|h:blockquote|h:address|h:table|h:form">
			<!-- parent must be in Flow.mix or Block.mix -->
			<assert test="parent::rddl:resource or 
			parent::h:div or 
			parent::h:dd or 
			parent::h:li or 
			parent::h:object or 
			parent::h:blockquote or 
			parent::h:body or
			parent::h:td"
			>Parent element [<name path="parent::*"/>] must be either Flow.mix or Block.mix,
			Element [<name path="*"/>]
			</assert>
		</rule>
	</pattern>
 
	<pattern name="Well-known Natures">
             <!-- too much download time and XHTML WF is freq crappy 
		<rule context="rddl:resource[@xlink:role='http://www.w3.org/1999/xhtml']">
			<assert test="document(@xlink:href)/h:html"
                        >This resource should be XHTML.</assert>
                </rule>             
             
		<rule context="rddl:resource[@xlink:role='http://www.ascc.net/xml/schematron']">
			<assert test="document(@xlink:href)//sch:schema"
                        >This resource should be Schematron.</assert>
        </rule>
		<rule context="rddl:resource[@xlink:role='http://www.w3.org/2001/XMLSchema']">
			<assert test="document(@xlink:href)//xsd:schema"
                        >This resource should be an XML Schema.</assert>
        </rule>
		<rule context="rddl:resource[@xlink:role='http://www.xml.gr.jp/xmlns/relaxCore']">
			<assert test="document(@xlink:href)//rlx:grammar"
                        >This resource should be an RELAX Core Grammar.</assert>
        </rule>
		<rule context="rddl:resource[@xlink:role='http://www.xml.gr.jp/xmlns/relaxNamespace']">
			<assert test="document(@xlink:href)//rng:grammar"
                        >This resource should be an RELAX Namespace Grammar.</assert>
        </rule>
		<rule context="rddl:resource[@xlink:role='http://www.thaiopensource.com/trex']">
			<assert test="document(@xlink:href)//trx:grammar"
                        >This resource should be an TREX Grammar.</assert>
        </rule>
		-->
	</pattern>
 
</schema>

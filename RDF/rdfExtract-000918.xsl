<?xml version="1.0" ?>
<!-- rdfExtract.xsl -->
<!-- Jonathan Borden <jonathan@openhealth.org> -->
<!-- Params:
	defaultParseType = 'Resource'
	explicitPathIndicies = 'ChildSeq'
	trace =
-->
<!-- handles XLink 2 RDF for simple links -->
<!-- rdf (syntax sucks) 1.0 "parser" -->
<!-- revision: 2000-09-18 -->
<!-- contact: jason@injektilo.org -->

<!-- TODO: -->

<!-- aboutEach=bagID -->
<!-- reification -->
<!-- aboutEachPrefix -->
<!-- xml:lang -->

<!-- error checking -->
<!-- property-elements with resource attributes can't have children? -->

<!-- HISTORY:

  2000-09-11:
    Initial release.
  2000-09-13:
    Refactored into multiple templates. General cleanup.
    Added support for containers, value, parseType.
  2000-09-14:
    Anonymous container objects had a different URI than the same container
      as a subject to it's members.
    Typed nodes with a resource attribute not in the rdf namespace weren't being
      parsed correctly

  -->

<!DOCTYPE xsl:transform [

<!ENTITY description-id-and-about "Description's cannot have both and ID and about attribute">
<!ENTITY about-each-prefix-not-implemented "aboutEachPrefix not implemented">
<!ENTITY alt-minimum-one-member "Alts need at least one member">
<!ENTITY container-member-attributes-vs-elements "containers with member attributes cannot have elements">

]>

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfp="http://www.w3.org/XML/2000/04/rdf-parse/#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes='xsl rdf rdfs rdfp xlink saxon'
>

<xsl:output method="xml" indent="yes"/>
<xsl:variable name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
  <xsl:variable name='rdfNS' select='"http://www.w3.org/1999/02/22-rdf-syntax-ns#"'/>
  <xsl:variable name='rdfsNS' select='"http://www.w3.org/2000/01/rdf-schema#"'/>  
  <xsl:variable name='xlinkNS' select='"http://www.w3.org/1999/xlink"'/>
  <xsl:variable name='uriReferenceType' select='"http://www.w3.org/1999/XMLSchema#datatype_uriReference"'/>
  <xsl:variable name='stringType' select='"http://www.w3.org/1999/XMLSchema#datatype_string"'/>
  <xsl:variable name="rdfsLiteralType" select='concat($rdfsNS,"Literal")'/>
  <xsl:variable name="rdfsResourceType" select='concat($rdfsNS,"Resource")'/>
  <xsl:variable name="xmlNS" select="'http://www.w3.org/XML/1998/namespace'" />
  <xsl:variable name="rdfType" select="concat($rdfNS,'type')"/>

<xsl:param name="explicitPathIndices" select="'ChildSeq'"/>
<xsl:param name="trace"/>
<xsl:param name="defaultParseType" select="'Resource'"/><!--  -->
<!-- disable the built-in templates that copies text through -->

<xsl:template match="text()|@*"></xsl:template>
<xsl:template match="text()|@*" mode="objects"></xsl:template>
<xsl:template match="text()|@*" mode="members"></xsl:template>

<!--                                                                         -->

<xsl:template match="rdf:RDF">
<rdf:RDF>
  <xsl:apply-templates  mode="objects"/>
</rdf:RDF>
</xsl:template>

<!--                                                                         -->
<!--                                                                         -->

<xsl:template match="/*">
<rdf:RDF>
  <xsl:apply-templates select="." mode="objects"/>
</rdf:RDF>
</xsl:template>

<!--
<xsl:template match="rdf:Description" mode="objects">
	<xsl:call-template name="generate-statements"/>
</xsl:template>
-->
<!--                                                                         -->

<xsl:template match="rdf:Description[@about or @rdf:about]" mode="objects">
	<xsl:call-template name="generate-statements"/>
</xsl:template>

<!--                                                                         -->

<xsl:template match="rdf:Description[(@about or @rdf:about) and (@ID or @rdf:ID)]" mode="objects">
<xsl:message terminate="yes">&description-id-and-about;</xsl:message>
</xsl:template>

<!--                                                                         -->

<xsl:template match="rdf:Description[@aboutEach]" mode="objects">
 <xsl:call-template name="generate-statements-about-each">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="about-each" select="@aboutEach"/>
 </xsl:call-template>
</xsl:template>

<!--                                                                         -->
<!--                                                                         -->

<xsl:template match="rdf:Description[@rdf:aboutEach]" mode="objects">
 <xsl:call-template name="generate-statements-about-each">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="about-each" select="@rdf:aboutEach"/>
 </xsl:call-template>
</xsl:template>

<!--  
<xsl:template match="rdf:Description[@aboutEachPrefix]" mode="objects">

<xsl:message terminate="yes">&about-each-prefix-not-implemented;</xsl:message>

</xsl:template>
-->
<!--                                                                         -->

<xsl:template match="*[@rdf:about]" mode="objects">

<xsl:call-template name="generate-type-statement">
  <xsl:with-param name="subject" select="@rdf:about"/>
  <xsl:with-param name="type"><xsl:call-template name="QNameToURI" /></xsl:with-param><!-- select="concat(namespace-uri(), local-name())"/>-->
</xsl:call-template>

<xsl:call-template name="generate-statements"/>

</xsl:template>

<!--                                                                         -->

<xsl:template match="*" mode="objects">

<xsl:call-template name="generate-statements"/>

</xsl:template>

<!--                                                                         -->

<xsl:template match="*[@rdf:aboutEach]" mode="objects">

<xsl:call-template name="generate-statements-about-each">
  <xsl:with-param name="node" select="."/>
  <xsl:with-param name="about-each" select="@rdf:aboutEach"/>
  <xsl:with-param name="type"><xsl:call-template name="QNameToURI" /></xsl:with-param><!-- select="concat(namespace-uri(), local-name())"/> -->
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template match="*[@aboutEachPrefix]" mode="objects">

<xsl:message terminate="yes">&about-each-prefix-not-implemented;</xsl:message>

</xsl:template>

<!--                                                                         -->

<xsl:template match="rdf:Bag | rdf:Seq | rdf:Alt" mode="objects">

<xsl:variable name="subject">
  <xsl:call-template name="container-uri">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:variable>

<xsl:call-template name="generate-type-statement">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="type"><xsl:call-template name="QNameToURI" /></xsl:with-param>
</xsl:call-template>

<!-- make sure Alts have at least one member -->
<xsl:if test="local-name() = 'Alt' and count(rdf:li) = 0">
  <xsl:message terminate="yes">&alt-minimum-one-member;</xsl:message>
</xsl:if>

<!-- make sure there are not both member attributes and elements -->
<xsl:choose>
  <xsl:when test="@rdf:*[starts-with(local-name(), '_')]">
    <xsl:choose>
      <xsl:when test="*">
        <xsl:message terminate="yes">&container-member-attributes-vs-elements;</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@rdf:*" mode="member-attributes">
          <xsl:with-param name="subject" select="$subject"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="rdf:li" mode="members">
      <xsl:with-param name="container" select="$subject"/>
    </xsl:apply-templates>
  </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!--                                                                         -->

<xsl:template match="@rdf:*" mode="member-attributes">
  <xsl:param name="subject"/>

<xsl:if test="starts-with(local-name(), '_')">
  <xsl:call-template name="generate-statement-string">
    <xsl:with-param name="subject" select="$subject"/>
    <xsl:with-param name="predicate-namespace-uri" select="$rdf"/>
    <xsl:with-param name="predicate-local-name" select="local-name()"/>
    <xsl:with-param name="object-type" select="'literal'"/>
    <xsl:with-param name="object" select="."/>
  </xsl:call-template>
</xsl:if>

</xsl:template>

<!--                                                                         -->

<xsl:template match="rdf:li[@resource]" mode="members">
  <xsl:param name="container"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$container"/>
  <xsl:with-param name="predicate-namespace-uri" select="$rdf"/>
  <xsl:with-param name="predicate-local-name" select="concat('_', position())"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="@resource"/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<!-- this is mostly a copy of the previous template with the resource
attribute explicitly in the rdf namespace. this isn't legal according to the
spec but it probably should be. -->

<xsl:template match="rdf:li[@rdf:resource]" mode="members">
  <xsl:param name="container"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$container"/>
  <xsl:with-param name="predicate-namespace-uri" select="$rdf"/>
  <xsl:with-param name="predicate-local-name" select="concat('_', position())"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="@rdf:resource"/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template match="rdf:li" mode="members">
  <xsl:param name="container"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$container"/>
  <xsl:with-param name="predicate-namespace-uri" select="$rdf"/>
  <xsl:with-param name="predicate-local-name" select="concat('_', position())"/>
  <xsl:with-param name="object-type" select="'literal'"/>
  <xsl:with-param name="object" select="."/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template match="@*" mode="property-attributes">
  	<xsl:param name="subject"/>
	<xsl:variable name="attribute-namespace-uri" select="namespace-uri()"/>

	<xsl:if test="($attribute-namespace-uri != $rdfNS) and ($attribute-namespace-uri != $xmlNS) and ($attribute-namespace-uri != $xlinkNS)">
  		<xsl:if test="($attribute-namespace-uri != '') or (local-name() != 'about') and (local-name() != 'ID')">
    		<xsl:call-template name="generate-statement-string">
      			<xsl:with-param name="subject" select="$subject"/>
      			<xsl:with-param name="predicate-namespace-uri" select="$attribute-namespace-uri"/>
      			<xsl:with-param name="predicate-local-name" select="local-name()"/>
      			<xsl:with-param name="object-type" select="'literal'"/>
      			<xsl:with-param name="object" select="."/>
    		</xsl:call-template>
  		</xsl:if>
	</xsl:if>
</xsl:template>

<!--                                                                         -->

<xsl:template match="*[rdf:Description | rdf:Bag | rdf:Seq | rdf:Alt]" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:variable name="container" select="rdf:Description | rdf:Bag | rdf:Seq | rdf:Alt"/>

<xsl:variable name="object">
  <xsl:call-template name="resource-uri">
    <xsl:with-param name="node" select="$container"/>
  </xsl:call-template>
</xsl:variable>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="$object"/>
</xsl:call-template>

<xsl:apply-templates select="$container" mode="objects"/>

</xsl:template>

<!--                                                                         -->

<xsl:template match="*[@resource]" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="@resource"/>
</xsl:call-template>

<xsl:apply-templates select="." mode="objects"/>

</xsl:template>

<!--                                                                         -->

<!-- this is mostly a copy of the previous template with the resource
attribute explicitly in the rdf namespace. this isn't legal according to the
spec but it probably should be. -->

<xsl:template match="*[@rdf:resource]" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="@rdf:resource"/>
</xsl:call-template>

<xsl:apply-templates select="." mode="objects"/>

</xsl:template>

<!--                                                                         -->

<xsl:template match="rdf:*[@resource]" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="@resource"/>
</xsl:call-template>

<xsl:apply-templates select="." mode="objects"/>

</xsl:template>
<!--                                                                         -->

<xsl:template match="rdf:*[@rdf:resource]" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="@rdf:resource"/>
</xsl:call-template>

<xsl:apply-templates select="." mode="objects"/>

</xsl:template>

<!--                                                                         -->

<xsl:template match="*[*[1]/@rdf:about]" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="*[1]/@rdf:about"/>
</xsl:call-template>

<xsl:apply-templates select="*[1]" mode="objects"/>

</xsl:template>

<!--                                                                         -->
<!-- jab -->
<xsl:template match="*[not(@rdf:parseType)]" mode="property-elements">
  <xsl:param name="subject"/>
<xsl:if test="$trace">[TRACE *(not(@rdf:parseType) mode="property-elements" : <xsl:value-of select="name()" />]</xsl:if>
<xsl:choose>
 <xsl:when test="$defaultParseType='Resource'">

<xsl:variable name="object">
  <xsl:choose>
  	<xsl:when test="@rdf:resource"><xsl:value-of select="@rdf:resource" /></xsl:when>
  	<xsl:otherwise>
	 <xsl:call-template name="resource-uri">
    	<xsl:with-param name="node" select="."/>
     </xsl:call-template>
  	</xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="$object"/>
</xsl:call-template>

<xsl:call-template name="generate-statements">
  <xsl:with-param name="node" select="."/>
  <xsl:with-param name="subject" select="$object"/>
</xsl:call-template>

 </xsl:when>
 <xsl:when test="$defaultParseType='Literal'">
<xsl:call-template name="generate-statement">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'literal'"/>
  <xsl:with-param name="object" select="*|text()"/>
</xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
	<xsl:call-template name="generate-statement-string">
  		<xsl:with-param name="subject" select="$subject"/>
  		<xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  		<xsl:with-param name="predicate-local-name" select="local-name()"/>
  		<xsl:with-param name="object-type" select="'literal'"/>
  		<xsl:with-param name="object" select="."/>
	</xsl:call-template>
 </xsl:otherwise>
</xsl:choose>	
</xsl:template>

<!--                                                                         -->

<xsl:template match="*[@rdf:parseType='Literal']" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:call-template name="generate-statement">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'literal'"/>
  <xsl:with-param name="object" select="*|text()"/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template match="*[@rdf:parseType='Resource']" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:variable name="object">
  <xsl:choose>
  <!-- jab -->
  	<xsl:when test="@rdf:resource"><xsl:value-of select="@rdf:resource" /></xsl:when>
  	<xsl:otherwise>
	 <xsl:call-template name="resource-uri">
    	<xsl:with-param name="node" select="."/>
     </xsl:call-template>
  	</xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="$object"/>
</xsl:call-template>

<xsl:call-template name="generate-statements">
  <xsl:with-param name="node" select="."/>
  <xsl:with-param name="subject" select="$object"/>
</xsl:call-template>

</xsl:template>

<!--   XLink 2 RDF here                                                                      -->
<!-- per http://www.w3.org/XML/2000/09/xlink2rdf.htm -->
<xsl:template match="*[@xlink:type='simple']" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:variable name="object" select="@xlink:href"/>

<rdf:Statement>
	<rdf:predicate>
			<xsl:choose>
				<xsl:when test="@xlink:arcrole"><xsl:value-of select="@xlink:arcrole" /></xsl:when>
				<xsl:otherwise><xsl:call-template name="QNameToURI"/></xsl:otherwise>
			</xsl:choose>
	</rdf:predicate>
	<rdf:subject><xsl:value-of select="$subject"/></rdf:subject>
	<rdf:object rdf:type="{$rdfsResourceType}"><xsl:value-of select="@xlink:href" /></rdf:object>
</rdf:Statement>
	<xsl:if test="@xlink:role">
      	<rdf:Statement>
        		<rdf:predicate><xsl:value-of select="$rdfType" /></rdf:predicate>
				<rdf:subject><xsl:value-of select="@xlink:href"/></rdf:subject>
        		<rdf:object rdf:type="{$rdfsResourceType}"><xsl:value-of select="@xlink:role" /></rdf:object>
      	</rdf:Statement>
      	<rdf:Statement>
        		<rdf:predicate><xsl:value-of select="$rdfType" /></rdf:predicate>
        		<rdf:subject><xsl:value-of select="@xlink:role" /></rdf:subject>
        		<rdf:object rdf:type="{$rdfsResourceType}"><xsl:value-of select='concat($rdfsNS,"Class")' /></rdf:object>
      	</rdf:Statement>
	</xsl:if>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="$object"/>
</xsl:call-template>

<xsl:call-template name="generate-statements">
  <xsl:with-param name="node" select="."/>
  <xsl:with-param name="subject" select="$object"/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template match="*[@rdf:value]" mode="property-elements">
  <xsl:param name="subject"/>

<xsl:variable name="object">
  <xsl:call-template name="resource-uri">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:variable>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="namespace-uri()"/>
  <xsl:with-param name="predicate-local-name" select="local-name()"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="$object"/>
</xsl:call-template>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$object"/>
  <xsl:with-param name="predicate-namespace-uri" select="$rdf"/>
  <xsl:with-param name="predicate-local-name" select="'value'"/>
  <xsl:with-param name="object-type" select="'literal'"/>
  <xsl:with-param name="object" select="@rdf:value"/>
</xsl:call-template>

<xsl:call-template name="generate-statements">
  <xsl:with-param name="node" select="."/>
  <xsl:with-param name="subject" select="$object"/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template name="resource-uri">
  <xsl:param name="node" select="."/>

<xsl:choose>
  <xsl:when test="namespace-uri($node) = $rdf and $node/@about">
    <xsl:value-of select="$node/@about"/>
  </xsl:when>
  <xsl:when test="$node/@rdf:about">
    <xsl:value-of select="$node/@rdf:about"/>
  </xsl:when>
  <xsl:when test="namespace-uri($node) = $rdf and $node/@resource">
    <xsl:value-of select="$node/@resource"/>
  </xsl:when>
  <xsl:when test="namespace-uri($node) != $rdf and $node/@rdf:resource">
    <xsl:value-of select="$node/@rdf:resource"/>
  </xsl:when>
  <!--<xsl:when test="namespace-uri($node) != $rdf and $node/@rdf:about">
    <xsl:value-of select="$node/@rdf:about"/>
  </xsl:when>-->
  <xsl:when test="$node/@ID">
    <xsl:value-of select="concat('#', $node/@ID)"/>
  </xsl:when>
  <xsl:when test="$node/@rdf:ID">
    <xsl:value-of select="concat('#', $node/@rdf:ID)"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="nodeIdentifier">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <!--<xsl:call-template name="anonymous-uri">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>-->
  </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!--                                                                         -->

<xsl:template name="container-uri">
  <xsl:param name="node" select="."/>

<xsl:choose>
  <xsl:when test="namespace-uri($node) = $rdf and $node/@ID">
    <xsl:value-of select="concat('#', $node/@ID)"/>
  </xsl:when>
  <xsl:when test="namespace-uri($node) != $rdf and $node/@rdf:ID">
    <xsl:value-of select="concat('#', $node/@rdf:ID)"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="nodeIdentifier">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <!--<xsl:call-template name="anonymous-uri">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>-->
  </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!--                                                                         -->

<xsl:template name="anonymous-uri">
  <xsl:param name="node"/>

<xsl:value-of select="concat('anonymous:', generate-id($node))"/>

</xsl:template>

<!--                                                                         -->

<xsl:template name="generate-statement-string">
  <xsl:param name="subject"/>
  <xsl:param name="predicate-namespace-uri"/>
  <xsl:param name="predicate-local-name"/>
  <xsl:param name="object-type"/>
  <xsl:param name="object"/>

<xsl:call-template name="generate-statement">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="$predicate-namespace-uri"/>
  <xsl:with-param name="predicate-local-name" select="$predicate-local-name"/>
  <xsl:with-param name="object-type" select="$object-type"/>
  <xsl:with-param name="object" select="string($object)"/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template name="generate-statement">
  <xsl:param name="subject"/>
  <xsl:param name="predicate-namespace-uri"/>
  <xsl:param name="predicate-local-name"/>
  <xsl:param name="object-type"/>
  <xsl:param name="object"/>

<rdf:Statement>
  <rdf:subject><xsl:value-of select="$subject"/></rdf:subject>
  <rdf:predicate><xsl:call-template name="QNameToURI"><xsl:with-param name="namespace-name" select="$predicate-namespace-uri"/><xsl:with-param name="local-name" select="$predicate-local-name"/></xsl:call-template></rdf:predicate><!--<xsl:value-of select="concat($predicate-namespace-uri, $predicate-local-name)"/>-->
	<xsl:choose>
		<xsl:when test="$object-type='literal'">
  			<rdf:object rdf:type="{$rdfsLiteralType}">			
  				<xsl:copy-of select="$object"/>
  			</rdf:object>
		</xsl:when>
		<xsl:when test="$object-type='resource'">
  			<rdf:object rdf:type="{$rdfsResourceType}">			
  				<xsl:copy-of select="$object"/>
  			</rdf:object>
		</xsl:when>
	</xsl:choose>
</rdf:Statement>

</xsl:template>

<!--                                                                         -->

<xsl:template name="generate-type-statement">
  <xsl:param name="subject"/>
  <xsl:param name="type"/>

<xsl:call-template name="generate-statement-string">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="predicate-namespace-uri" select="$rdf"/>
  <xsl:with-param name="predicate-local-name" select="'type'"/>
  <xsl:with-param name="object-type" select="'resource'"/>
  <xsl:with-param name="object" select="$type"/>
</xsl:call-template>

</xsl:template>

<!--                                                                         -->

<xsl:template name="generate-statements-about-each">
  <xsl:param name="node"/>
  <xsl:param name="about-each"/>
  <xsl:param name="type"/>

<xsl:variable name="id">
  <xsl:choose>
    <xsl:when test="starts-with($about-each, '#')">
      <xsl:value-of select="substring-after($about-each, '#')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$about-each"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:for-each select="//rdf:*[@ID=$id]/rdf:li">

  <xsl:if test="$type">
    <xsl:call-template name="generate-type-statement">
      <xsl:with-param name="subject" select="@resource"/>
      <xsl:with-param name="type" select="$type"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:call-template name="generate-statements">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="subject" select="@resource"/>
  </xsl:call-template>

</xsl:for-each>

</xsl:template>

<!--                                                                         -->

<xsl:template name="generate-statements">
  <xsl:param name="node" select="."/>
  <xsl:param name="subject">
    <xsl:call-template name="resource-uri">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>

<xsl:variable name="reified-statement">
  <xsl:value-of select="$node/@bagID"/>
</xsl:variable>

<xsl:apply-templates select="$node/@*" mode="property-attributes">
  <xsl:with-param name="subject" select="$subject"/>
</xsl:apply-templates>

<xsl:apply-templates select="$node/*" mode="property-elements">
  <xsl:with-param name="subject" select="$subject"/>
  <xsl:with-param name="reified-statement" select="$reified-statement"/>
</xsl:apply-templates>
	<xsl:choose>
		<xsl:when test="$defaultParseType='Resource'">
			<xsl:for-each select='text()[string-length(normalize-space())&gt;0]'>
        		<xsl:call-template name="generate-statement-string">
  					<xsl:with-param name="subject" select="$subject"/>
  					<xsl:with-param name="predicate-namespace-uri" select="$rdf"/>
  					<xsl:with-param name="predicate-local-name" select="'value'"/>
  					<xsl:with-param name="object-type" select="'literal'"/>
  					<xsl:with-param name="object" select="."/>
				</xsl:call-template>
      		</xsl:for-each>
		</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template name="childSeq">
	<xsl:param name="node" select="."/>
	<xsl:for-each select="$node/ancestor-or-self::*">/<xsl:value-of select="1 + count(preceding-sibling::*)"/></xsl:for-each>
</xsl:template>
<xsl:template name="nodeIdentifier">
	<xsl:param name="node" select="."/>
	<xsl:choose>
		<!--<xsl:when test="@rdf:instance"><xsl:value-of select="@rdf:instance" /></xsl:when>-->
		<xsl:when test="$node/@rdf:resource"><xsl:value-of select="$node/@rdf:resource" /></xsl:when>
		<xsl:when test="$explicitPathIndices='ChildSeq'">#<xsl:call-template name="childSeq" ><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:when>
		<xsl:otherwise>#xpointer(<xsl:call-template name="pathName" ><xsl:with-param name="node" select="$node"/></xsl:call-template>)</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template name="QNameToURI">
	<xsl:param name="sep" select="'#'"/>
	<xsl:param name="node" select="."/>
	<xsl:param name="namespace-name" select="namespace-uri($node)"/>
	<xsl:param name="local-name" select="local-name($node)"/>
	<xsl:variable name="nslen" select="string-length($namespace-name)"/>
	<xsl:variable name="base">
		<xsl:choose>
			<xsl:when test="$nslen > 0"></xsl:when>
			<xsl:when test="ancestor-or-self::*/@xml:base"><xsl:value-of select="ancestor-or-self::*/@xml:base" /></xsl:when>
			<xsl:when test="function-available('saxon:system-id')"><xsl:value-of select="saxon:system-id()" /></xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="lastNSChar" select="substring($namespace-name,$nslen)"/>
		<xsl:choose>
			<xsl:when test="($lastNSChar='#') or ($lastNSChar='/') or ($lastNSChar='\')"><xsl:value-of select="concat($namespace-name,$local-name)" /></xsl:when>
			<xsl:when test="$nslen = 0"><xsl:value-of select="concat($base,'#',$local-name)" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat($namespace-name,$sep,$local-name)" /></xsl:otherwise>
		</xsl:choose>
</xsl:template>
<xsl:template name="pathName">
  <xsl:param name="node" select="."/>
  <xsl:for-each select="$node/ancestor-or-self::*">
    <xsl:variable name="nodename" select="name()" />
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$nodename" />
	<xsl:choose>
	  <xsl:when test="$explicitPathIndices">
		<xsl:text>[</xsl:text>
    	<xsl:value-of select="1 + count(preceding-sibling::*[name() = $nodename])"/>
    	<xsl:text>]</xsl:text>
	  </xsl:when>
	  <xsl:when test="@*[not(namespace-uri()=$rdfNS) and not(namespace-uri() = $xlinkNS)]">    
		<xsl:text>[</xsl:text>
		<xsl:for-each select="@*[not(namespace-uri()=$rdfNS) and not(namespace-uri() = $xlinkNS)]">@<xsl:value-of select="name()" />='<xsl:value-of select="." />'<xsl:if test="not(position() = last())"> and </xsl:if></xsl:for-each>
    	<xsl:text>]</xsl:text>
	  </xsl:when>  
	</xsl:choose>  
 </xsl:for-each>
</xsl:template>
</xsl:transform>

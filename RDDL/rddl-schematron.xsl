<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:rddl="http://www.rddl.org/" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsd="http://www.w3.org/2000/10/XMLSchema" xmlns:rlx="http://www.xml.gr.jp/xmlns/relaxCore" xmlns:rng="http://www.xml.gr.jp/xmlns/relaxNamespace" xmlns:trx="http://www.thaiopensource.com" version="1.0" rddl:dummy-for-xmlns="" h:dummy-for-xmlns="" xlink:dummy-for-xmlns="" sch:dummy-for-xmlns="" xsd:dummy-for-xmlns="" rlx:dummy-for-xmlns="" rng:dummy-for-xmlns="" trx:dummy-for-xmlns="">
   <xsl:template match="*|@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:if test="count(. | ../@*) = count(../@*)">@</xsl:if>
      <xsl:value-of select="name()"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
   </xsl:template>
   <xsl:template match="/h:html" priority="3998" mode="M10">
      <xsl:choose>
         <xsl:when test="not(@lang) or (@lang = @xml:lang)"/>
         <xsl:otherwise>When lang attribute is present, the value must equal the value of xml:lang.</xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M10"/>
   </xsl:template>
   <xsl:template match="h:head" priority="3997" mode="M10">
      <xsl:if test=".//rddl:resource">RDDL resources must be within the html body.</xsl:if>
      <xsl:apply-templates mode="M10"/>
   </xsl:template>
   <xsl:template match="h:body" priority="3996" mode="M10">
      <xsl:choose>
         <xsl:when test=".//rddl:resource"/>
         <xsl:otherwise>There should be at least one RDDL resource in the body.</xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M10"/>
   </xsl:template>
   <xsl:template match="rddl:resource" priority="3995" mode="M10">
      <xsl:choose>
         <xsl:when test="count(@*) = count(@id|@xml:base|@xml:lang|@xlink:title|@xlink:href|@xlink:arcrole|@xlink:role|@xlink:type|@xlink:show|@xlink:embed)"/>
         <xsl:otherwise>The element rddl:resource should contain only the attributes id, xml:base, xml:lang, xlink:href, xlink:arcrole, xlink:role, xlink:href.</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="count(*)=(count(h:*)+count(rddl:*))"/>
         <xsl:otherwise>The rddl:resource element should only have child elements from the XHTML and RDDL namespaces.</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="not(@xlink:type) or @xlink:type='simple'"/>
         <xsl:otherwise>RDDL resources are simple Xlinks.</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="(not(@xlink:embed) or @xlink:embed='none') and (not(@xlink:show) or @xlink:show='none')"/>
         <xsl:otherwise>xlink:embed,xlink:show are not used.</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="not(@xlink:role) or contains(@xlink:role,':') or starts-with(@xlink:role,'#')"/>
         <xsl:otherwise>The value of xlink:role cannot be a relative URI reference.</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="not(@xlink:arcrole) or contains(@xlink:arcrole,':') or starts-with(@xlink:arcrole,'#')"/>
         <xsl:otherwise>The value of xlink:arcrole cannot be a relative URI reference.</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="normalize-space(.) and *"/>
         <xsl:otherwise>A rddl:resource should have a description.</xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="h:h1|h:h2|h:h3|h:h4|h:h5|h:h6|h:ul|h:ol|h:dl|h:p|h:div|rddl:resource|h:pre|h:blockquote|h:address|h:table|h:form" priority="4000" mode="M11">
      <xsl:choose>
         <xsl:when test="parent::rddl:resource or     parent::h:div or     parent::h:dd or     parent::h:li or     parent::h:object or     parent::h:blockquote or     parent::h:body or    parent::h:td"/>
         <xsl:otherwise>Parent element [<xsl:text  xml:space="preserve"/>
            <xsl:value-of select="name(parent::*)"/>
            <xsl:text  xml:space="preserve"/>] must be either Flow.mix or Block.mix, Element [<xsl:text  xml:space="preserve"/>
            <xsl:value-of select="name(*)"/>
            <xsl:text  xml:space="preserve"/>]</xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="text()" priority="-1"/>
</xsl:stylesheet>
package org.openhealth.wowg.onx;

class OntologyBuilderImpl implements OntologyBuilder {
	static String ONT_CLASS = "ont:Class";
	static String ONT_PROPERTY = "ont:Property";
	static String ONT_NS = "http://www.3.org/2001/10/daml+oil#";
	static String CLASS = "Class";
	static String PROPERTY = "Property";
	static String RDF_ID = "rdf:ID";
	static String RDF_ABOUT = "rdf:about";
	static String DESCRIPTION = "Description";
	static String RDF_DESCRIPTION = "rdf:Description";
	static String SAMEPROPERTYAS = "samePropertyAs";
	static String SUBPROPERTYOF = "subPropertyOf";
	static String ONT_SAMEPROPERTYAS = SAMEPROPERTYAS;
	static String ONT_SUBPROPERTYOF = SUBPROPERTYOF;
	static Attributes noAtts = new AttributesImpl();
	org.xml.sax.ContentHandler sax;
  // class xx:foo () => <ont:Class rdf:ID="foo">
  void _class(String id)
  {
  	AttributesImpl att = new AttributesImpl();
	if (id) {
		if (id[0]=='#') {
			att.addAttribute(RDF_NS,"ID",RDF_ID,CDATA,id.substring(1));
		} else
			att.addAttribute(RDF_NS,"about",RDF_ABOUT,CDATA,id);
  	sax.startElement(ONT_NS,CLASS,ONT_CLASS,atts);
  }
  void endClass()
  {
  	sax.endElement(ONT_NS,CLASS,ONT_CLASS);
  }
  // pattern pattern => interleave
  void property(String id) {
  	AttributesImpl att = new AttributesImpl();
	if (id) {
		if (id[0]=='#') {
			att.addAttribute(RDF_NS,"ID",RDF_ID,CDATA,id.substring(1));
		} else
			att.addAttribute(RDF_NS,"about",RDF_ABOUT,CDATA,id);
  	}
	sax.startElement(ONT_NS,PROPERTY,ONT_PROPERTY,atts);
  }
  void endProperty()
  {
  	sax.endElement(ONT_NS,PROPERTY,ONT_PROPERTY);
  }
  void individual(String id)
  {
  	AttributesImpl att = new AttributesImpl();
	if (id) {
		if (id.charAt(0)=='#') {
			att.addAttribute(RDF_NS,"ID",RDF_ID,CDATA,id.substring(1));
		} else
			att.addAttribute(RDF_NS,"about",RDF_ABOUT,CDATA,id);
  	};   
	sax.startElement(RDF_NS,DESCRIPTION,RDF_DESCRIPTION,atts);
  }
  void endIndividual()
  {
  	sax.endElement(RDF_NS,DESCRIPTION,RDF_DESCRIPTION);
  }
  //
  void samePropertyAs(){
  	sax.startElement(ONT_NS,SAMEPROPERTYAS,ONT_SAMEPROPERTYAS,noAtts);
  }
  void endSamePropertyAs() {
    	sax.endElement(ONT_NS,SAMEPROPERTYAS,ONT_SAMEPROPERTYAS);
 }
  void subPropertyOf(){
  	sax.startElement(ONT_NS,SUBPROPERTYOF,ONT_SUBPROPERTYOF,noAtts);
  }
  void endSubPropertyOf() {
    	sax.endElement(ONT_NS,SUBPROPERTYOF,ONT_SUBPROPERTYOF);
 }
  //
  void domain(){}
  void endDomain(){}
  void range(){}
  void endRange(){}
  void datatypeRange(String id){}
  void endDatatypeRange(){}
  //
  void subClassOf(){}
  void endSubClassOf(){}
  void datavalue(String id,String value){}
  //
  void property(String id){}
  void uniquelyIdentifyingProperty(String id){}
  void transitiveProperty(String id){}
  void singleValuedProperty(String id){}
  void endProperty(){}
  //
  void cardinality(int c){}
  void minCardinality(int c){}
  void maxCardinality(int c){}
  //
  void datatypeProperty(String id){}
  void endDatatypeProperty(){}
  //
  void required(String id, boolean r){}
  void endRequired(){}
  void value(){}
  void endValue(){}
  //
  void propertyValue(String id){}
  void endPropertyValue(){}
  //
  void sameIndividual(){}
  void endSameIndividual(){}
  void differentIndividuals(){}
  void endDifferentIndividuals(){}
  // non-frame part
  //
  void sameClassAs(){}
  void endSameClassAs(){}
  void disjoint(){}
  void endDisjoint(){}
  void unionOf(){}
  void endUnionOf(){}
  void intersectionOf(){}
  void endIntersectionOf(){}
  void complementOf(){}
  void endComplementOf(){}
  void oneOf(){}
  void endOneOf(){}
  //
  void localRange(String id){}
  void endLocalRange(){}
  
  // pattern => optional
  void optional(){}
  // pattern => pattern
  void annotate(Annotations a){}
  void include(String uri, String baseUri, String ns, Annotations a){}
  // grammar => grammar
  void finishInclude(){}
  // grammar => grammar
  void finishOntology(){}
  // => value
  void value(String datatypeLibrary,
	     String type,
	     String value,
	     String ns,
	     Annotations a){}
  // => data
  void data(String datatypeLibrary,
	    String type,
	    Annotations a){}


  void startPrefixBinding(String prefix, String uri){}
  void endPrefixBinding(){}
}

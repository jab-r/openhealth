package org.openhealth.wowg.onx;

interface OntologyBuilder {

  // class xx:foo () => <ont:Class rdf:ID="foo">
  void _class(String id);
  void endClass();
  // pattern pattern => interleave
  void property(String id);
  void endProperty();
  void individual(String id);
  void endIndividual();
  //
  void samePropertyAs();
  void endSamePropertyAs();
  void subPropertyOf();
  void endSubPropertyOf();
  //
  void domain();
  void endDomain();
  void range();
  void endRange();
  void datatypeRange(String id);
  void endDatatypeRange();
  //
  void subClassOf();
  void endSubClassOf();
  void datavalue(String id,String value);
  //
  void property(String id);
  void uniquelyIdentifyingProperty(String id);
  void transitiveProperty(String id);
  void singleValuedProperty(String id);
  void endProperty();
  //
  void cardinality(int c);
  void minCardinality(int c);
  void maxCardinality(int c);
  //
  void datatypeProperty(String id);
  void endDatatypeProperty();
  //
  void required(String id, boolean r);
  void endRequired();
  void value();
  void endValue();
  //
  void propertyValue(String id);
  void endPropertyValue();
  //
  void sameIndividual();
  void endSameIndividual();
  void differentIndividuals();
  void endDifferentIndividuals();
  // non-frame part
  //
  void sameClassAs();
  void endSameClassAs();
  void disjoint();
  void endDisjoint();
  void unionOf();
  void endUnionOf();
  void intersectionOf();
  void endIntersectionOf();
  void complementOf();
  void endComplementOf();
  void oneOf();
  void endOneOf();
  //
  void localRange(String id);
  void endLocalRange();
  
  // pattern => optional
  void optional();
  // pattern => pattern
  void annotate(Annotations a);
  void include(String uri, String baseUri, String ns, Annotations a);
  // grammar => grammar
  void finishInclude();
  // grammar => grammar
  void finishGrammar();
  // => value
  void value(String datatypeLibrary,
	     String type,
	     String value,
	     String ns,
	     Annotations a);
  // => data
  void data(String datatypeLibrary,
	    String type,
	    Annotations a);
  // data => data
  void param(String name, Annotations a, String value);
  // data pattern => data
  void dataExcept();
  // data => data
  void finishData();
  // => name
  void name(String ns, String localName);
  // => name
  void prefixedName(String ns, String prefixedName);
  // nameClass nameClass => nameClassChoice
  void nameClassChoice();

  void startPrefixBinding(String prefix, String uri);
  void endPrefixBinding();
}

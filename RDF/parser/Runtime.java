package org.openhealth.rdf.parser;
import org.openhealth.rdf.parser.gen.NGCCRuntime;
/** 
 *	$runtime is a global variable used by the parse process.
 *	It is of type org.openhealth.rdf.parser.Runtime
 *
 *	String subject;
 *	String predicate;
 *	String object;
 *	String xmllang;
 *	String xmlbase;
 *	String propertyId;
 *	String datatype;
 *	String makeURI(String id);
 *	void pushStack();
 *	void popStack();
 *	void statement(String s,String p,String o,String base);
 *	void literalStatement(String s,String p,String lit,String dt,
 *											String lang,String base);
 *	static final int STATEMENT_OBJECT = 1;
 *	static final int STATEMENT_COLLECTION = 2;
 *	static final String RDF_FIRST = "http://www.w3.org/1999/02/22-rdf-syntax-ns#first";
 *	static final String RDF_REST = "http://www.w3.org/1999/02/22-rdf-syntax-ns#rest";
 *	static final String RDF_NS = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
 *	int parseMode;
**/
public class Runtime extends NGCCRuntime {
	public Statement s;
 	String makeURI(String id);
	Stack stack;
 	void pushStack() {
		stack.push(new Statement(s));
		s.subject = null;
		s.predicate = null;
		s.object = null;
		s.propertyId = null;
		s.datatype = null;
		};
 	void popStack() {
		s = stack.pop();
	}
 	void statement(String s,String p,String o,String base){
		printf(s,p,o,base);
	}
 	void literalStatement(String s,String p,String lit,String dt,
 											String lang,String base);
 	static final int STATEMENT_OBJECT = 1;
 	static final int STATEMENT_COLLECTION = 2;
 	static final String RDF_FIRST = "http://www.w3.org/1999/02/22-rdf-syntax-ns#first";
 	static final String RDF_REST = "http://www.w3.org/1999/02/22-rdf-syntax-ns#rest";
 	static final String RDF_NS = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
 	int parseMode;
}}

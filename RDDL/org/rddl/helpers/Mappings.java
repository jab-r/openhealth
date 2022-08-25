package org.rddl.helpers;

import org.rddl.*;

public class Mappings {

	static final public String XLINK_NS = "http://www.w3.org/1999/xlink";
	static final public String XHTML_NS = "http://www.w3.org/1999/xhtml";
	static final public String RDDL_NS = "http://www.rddl.org/";
	static final public String RDDL_resource = "http://www.rddl.org/#resource";
	static final public String MIME_URI_prefix = "http://www.isi.edu/in-notes/iana/assignments/media-types/";
	static final public String XML_NS = "http://www.w3.org/XML/1998/namespace";
	
	static final public String URI_CSS = "http://www.rddl.org/arcrole.htm#CSS";

	static final public String getContentTypeFromNature(String nature){
		if (nature.startsWith(MIME_URI_prefix))
			return nature.substring(MIME_URI_prefix.length());
		else
		return null;
		}
	static final public String getNatureFromContentType(String ct) {
		return MIME_URI_prefix + ct;
	}
	static final public String getRootNamespaceURIFromNature(String nature){
		return nature;
		}
}

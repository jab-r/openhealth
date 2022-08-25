// CCPPFrame.java
// $Id: CCPPFrame.java,v 1.7 2000/08/16 21:37:34 ylafon Exp $
// (c) COPYRIGHT MIT, INRIA and Keio, 2000.
// Please first read the full copyright statement in file COPYRIGHT.html

package org.rddl.jigsaw;

import java.io.InputStream;

import org.w3c.jigsaw.frames.HTTPExtFrame;
import org.w3c.jigsaw.http.Reply;
import org.w3c.jigsaw.http.Request;
import org.w3c.tools.resources.ProtocolException;
import org.w3c.tools.resources.ResourceException;

/**
 * @version $Revision: 1.7 $
 * @author  Benoît Mahé (bmahe@w3.org)
 */
public class RDDLFrame extends HTTPExtFrame {

    static {
	String classname = "org.rddl.jigsaw.RDDLFrame";
	String methods[] = { "GET", "POST", "HEAD" }; // FIXME PUT? ...
	registerExtension(RDDL.HTTP_EXT_ID, methods, classname);
    }

    /**
     * Get the CC/PP Request
     * @param request the HTTP Request
     * @return a CCPPRequest instance
     */
    public RDDLRequest getRDDLRequest(Request request) {
	return RDDLRequest.getRDDLRequest(request);
    }

    /**
     * Set the Ext and/or C-Ext Header if necessary.
     * @param request the incomming request.
     * @param reply the reply
     * @return the acknowledged reply instance
     */
    protected Reply acknowledgeExtension(Request request, Reply reply) {
	RDDLRequest rddl = getRDDLRequest(request);
	return rddl.acknowledge(reply);
    }

    /**
     * The default GET method.
     * @param request The request to handle.
     * @exception ProtocolException If processsing the request failed.
     * @exception ResourceException If the resource got a fatal error.
     */

    public Reply get(Request request)
	throws ProtocolException, ResourceException
    {
	RDDLRequest rddl  = getRDDLRequest(request);
	String nature = rddl.getRDDLHeaderValue("Nature");
	String purpose = rddl.getRDDLHeaderValue("Purpose");
	String id = rddl.getRDDLHeaderValue("Id");
	String lang = rddl.getRDDLHeaderValue("Lang");
	String href = null;
	Namespace ns = rddl.getNamespace();
	Request req = request.getClone();
	...remove RDDL extension headers
	if (id != null) {
		// see if the ID denotes a sub-container or single resource
		Resource res = ns.getResource(id);
		ns = (Namespace) res.getContainer();
		if (ns == null) {
		// return internal redirect to resource URI
			href = res.getHref();
			if (href ==null) {
				..signal error...
			};
		};
	};
	if (href == null) {
	SortedMap ress = null;
	if (nature != null) {
		ress = ns.getResourcesByNature(nature);
	};
	if (purpose != null) {
		ress = (ress == null) ? ns.getResourcesByPurpose(purpose) : (SortedMap) new ResourceMap(ress, ResourceMap.PURPOSE).subMap(purpose,purpose+"\0");
	};
	if (lang != null) {
		ress = (ress == null) ? ns.getResourcesByLang(lang) : (SortedMap) new ResourceMap(ress,ResourceMap.LANG).subMap(lang,lang+"\0");
	Resource[] resa = (Resource[]) ress.values().toArray();
	if (resa.length < 1) ... error
	if (resa.length > 1) ... warning
	Resource res = resa[0];
	href = res.getHref();
	};
		... BUGBUG :- if relative URI then internal redirect, else external redirect
		req.setURL(new URL(request.getURL(),(hasQuery) ? href+"?"+queryString : href));
	return getServer().perform(req);
	//Reply       reply = super.get(request);
	return reply;
    }

    /**
     * CCPP HEAD method
     */
    public Reply head(Request request)
	throws ProtocolException, ResourceException
    {
	Reply reply = null;
	reply = get(request) ;
	reply.setStream((InputStream) null);
	return reply;
    }

}



// RDDLRequest.java
// modified from
// $Id: CCPPRequest.java,v 1.4 2000/08/16 21:37:34 ylafon Exp $
// (c) COPYRIGHT MIT, INRIA and Keio, 2000.
// Please first read the full copyright statement in file COPYRIGHT.html

package org.rddl.jigsaw;

import org.w3c.jigsaw.http.Reply;
import org.w3c.jigsaw.http.Request;

import org.w3c.www.http.HttpExtList;
import org.w3c.www.http.HttpExt;
import org.w3c.www.http.HttpFactory;
import org.w3c.www.http.HttpTokenList;

/**
 * @version $Revision: 1.4 $
 * @author  Benoît Mahé (bmahe@w3.org)
 */
public class RDDLRequest implements RDDL {

    Request     request      = null;
    Namespace ns   = null;
    HttpExtList httpextlist  = null;

    /**
     * Get the HTTP Request
     * @return a Request
     */
    public Request getHTTPRequest() {
	return request;
    }

    /**
     * Get the standard CCPP reason phrase for the given warning code.
     * @param warning The given warning code.
     * @return A String giving the standard reason phrase, or
     * <strong>null</strong> if the status doesn't match any knowned error.
     */
    public static String getStandardWarning(int warning) {
	int category = warning / 100;
	int catcode  = warning % 100;
	switch(category) 
	    {
	    case 1:
		if ((catcode >= 0) && (catcode < msg_100.length))
		    return msg_100[catcode];
		break;
	    case 2:
		if ((catcode >= 0) && (catcode < msg_200.length))
		    return msg_200[catcode];
		break;
	    }
	return UNKNOWN_WARNING_MESSAGE;
    }

    /**
     * Get a header value (relative to the CC/PP Extension protocol)
     * @param request the HTTP Request
     * @param header the header name (ie "Profile")
     * @return a String.
     */
    public String getRDDLHeaderValue(String header) {
	return request.getExtHeader(HTTP_EXT_ID, header);
    }
	public Namespace getRDDLNamespace() {
		return ns;
	};
    /**
     * Get the CC/PP Request associated to the given HTTP Request
     * @param request the HTTP Request
     * @return a CCPPRequest instance
     */
    public static RDDLRequest getRDDLRequest(Request request) {
	if (request.hasState(RDDL_REQUEST_STATE)) {
	    return (RDDLRequest) request.getState(RDDL_REQUEST_STATE);
	} else {
	    RDDLRequest rddlrequest = new RDDLRequest(request);
	    request.setState(RDDL_REQUEST_STATE, rddlrequest);
	    return rddlrequest;
	}
    }

    /**
     * Set the Acknowledgement Headers if it's appropriate.
     * @param reply the reply
     * @return the aknowledged reply
     */
    protected Reply acknowledge(Reply reply) {
	HttpExtList man = request.getHttpManExtDecl();
	if ((man != null) && 
	    (man.getLength() == 1) &&
	    (man.getHttpExt(HTTP_EXT_ID) != null)) {
	    reply.setEnd2EndExtensionAcknowledgmentHeader();
	}

	HttpExtList cman = request.getHttpCManExtDecl();
	if ((cman != null) && 
	    (cman.getLength() == 1) &&
	    (cman.getHttpExt(HTTP_EXT_ID) != null)) {
	    reply.setHopByHopExtensionAcknowledgmentHeader();
	}

	return reply;
    }

    /**
     * Add a CC/PP Warning to the given reply.
     * @param reply the HTTP Reply
     * @param warning the CC/PP Warning code
     * @param reference the Profile reference
     */
    public void addWarning(Reply reply, int warning, String reference) {
	RDDLWarning ccppwarning = (RDDLWarning)
	    reply.getState(RDDLWarning.RDDLWARNING_STATE);
	if (rddlwarning == null) {
	    rddlwarning = new RDDLWarning();
	    reply.setState(RDDLWarning.RDDLWARNING_STATE, rddlwarning);
	}
	ccppwarning.addWarning(warning, reference);
	// is the extension declared?
	HttpExtList list = reply.getExtList(HTTP_EXT_ID);
	if (list == null) {
	    list = new  HttpExtList(httpextlist);
	    reply.setHttpExtDecl(list);
	}
	HttpExt ext = list.getHttpExt(HTTP_EXT_ID);
	reply.setExtensionHeader(ext, 
				 PROFILE_WARNING_HEADER, 
				 rddlwarning.toString());
    }

    private RDDLRequest(Request request) {
	this.request     = request;
	this.httpextlist = request.getExtList(HTTP_EXT_ID);
	this.ns = RDDLURL.getNamespace(request.getURL());
    }
}

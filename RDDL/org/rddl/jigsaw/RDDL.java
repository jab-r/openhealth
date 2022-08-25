// CCPP.java
// $Id: CCPP.java,v 1.2 2000/05/03 15:22:07 bmahe Exp $
// (c) COPYRIGHT MIT, INRIA and Keio, 2000.
// Please first read the full copyright statement in file COPYRIGHT.html

package org.rddl.jigsaw;

import org.w3c.jigsaw.http.Request;

/**
 * @version $Revision: 1.2 $
 * @author  Benoît Mahé (bmahe@w3.org)
 */
public interface RDDL {

    //
    // The HTTP Extension identifier of CC/PP
    //

    public static final String HTTP_EXT_ID = 
	"http://www.rddl.org/";

    //
    // The CC/PP Headers
    //
    public static final String NATURE_HEADER =	"Nature";

    public static final String PURPOSE_HEADER = "Purpose";

    public static final String ID_HEADER = 		"Id";
	
	public static final String LANG_HEADER = 	"Lang";

	public static final String HREF_HEADER = 	"Href";
    //
    // The Unknown warning message
    //

    public static final String UNKNOWN_WARNING_MESSAGE = "Unknonwn Warning";

    //
    // The CC/PP state
    //
    public static final String RDDL_REQUEST_STATE = 
	"org.rddl.jigsaw.rddlrequest";

    //
    // CC/PP Warning messages
    //

    public static final String msg_100[] = {
        "Ok",                                   // 100
        "Used stale profile",                   // 101
	"Not used profile"                      // 102
    };

    public static final String msg_200[] = {
        "Not applied",                          // 200
        "Content selection applied",            // 201
        "Content generation applied",           // 202
        "Transformation applied"                // 203
    };

    //
    // CC/PP Warning code
    //

    public static final int OK                         = 100;
    public static final int USED_STALE_PROFILE         = 101;
    public static final int NOT_USED_STALE_PROFILE     = 102;

    public static final int NOT_APPLIED                = 200;
    public static final int CONTENT_SELECTION_APPLIED  = 201;
    public static final int CONTENT_GENERATION_APPLIED = 202;
    public static final int TRANSFORMATION_APPLIED     = 203;

}

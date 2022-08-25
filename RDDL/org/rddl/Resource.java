/**
 *	Resource Directory Description Language (RDDL) API
 *
 *	An XML-DEV project
 *	http://www.rddl.org/
 *
 *	This module, both source code and documentation, is in the Public Domain, 
 *	and comes with NO WARRANTY
 *
 *	@filename: resource.java
 *  @class: org.rddl.Resource
 *	@version: 0.1
 *  @date: 2001-01-06
 *	@author: Jonathan Borden <a href="mailto:jonathan@openhealth.org">jonathan@openhealth.org</a>
 */
package org.rddl;
import java.net.URLConnection;
import java.io.InputStream;
/**
 * Resource
 *
 * <blockquote>
 * <em>This module, both source code and documentation, is in the
 * Public Domain, and comes with <strong>NO WARRANTY</strong>.</em>
 * </blockquote>
 *
 * @author Jonathan Borden <a href="mailto:jonathan@openhealth.org">jonathan@openhealth.org</a>
 */
public interface Resource {
    /** Get the resource xlink:arcrole.
     *
     * &lt;rddl:resource xlink:arcrole="..." /&gt;
     *
     * <p>This method gets the xlink:arcrole which corresponds to the type of the link.
     * The arcrole may be either an absolute or relative URI reference, though under most circumstances will be 
     * an absolute URI. A fragment identifier should be present. The base URI is the URI of
     * the RDDL document containing the resource. Purposes for well known types are
     * defined in <a href="http://www.rddl.org/purposes">this</a> RDDL document.</p>
     * @return The <code>purpose</code> for this resource
 */
 	public abstract String getPurpose();
/** <p>Get the <code>nature</code> of the referenced resource. The <code>nature</code> corresponds to the <code>xlink:role</code>.
 * </p>
 * @return The <code>nature</code>
 */        
 	public abstract String getNature();
/** The base URI may be indicated by the <code>xml:base</code> attribute.
 * @return A String representing the base URI.
 */        
	public abstract String getBaseURI();
    /** Get the resource xlink:href.
     *
     * &lt;rddl:resource xlink;href="..." /&gt;
     *
     * <p>This method gets the resource's URI which corresponds to the xlink:href. 
     * The href may be either an absolute or relative URI. The base URI is the URI of
     * the RDDL document containing the resource.</p>
     * @return The href
 */
 	public abstract String getHref();
/** The ID of this resource, if present
 * @return The id.
 */     
	public abstract String getId();
/** The fragment id of the resource is according to XPointer and is either a raw name, child sequence or full XPointer.
 * @return the fragment identifier
 */        
	public abstract String getFragmentId();
/** The URI referencing this resource.
 * @return the URI
 */        
	public abstract String getURI();
/** The <code>xml:lang</code> of this resource if any.
 * @return The language code.
 */        
	public abstract String getLang();
    /** Get the resource xlink:title.
     *
     * &lt;rddl:resource xlink:title=&quot;An example title&quot; /&gt;
     *
     * <p>The <code>title</code> of an XLink is a short descriptive string which may appear in a menu</p>
     * @return the title
 */

 	public abstract String getTitle();
/** The parent <a href="Container.html">container</a> of this resource.
 * @return the parent container
 */        
	public abstract Container getContainer();
};
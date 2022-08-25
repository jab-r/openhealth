package org.rddl;

import java.util.SortedMap;
import java.util.Iterator;
/**
 * <p>A <code>Namespace</code> is associated with a URI reference. The <code>Namespace</code> interface defines a
 * collection of <a href="Resource.html">resources</a>.</p>
 */
public interface Namespace {	
	/** A <a href="Resource.html">resource</a> is qualified by its 
         * <a href="http://www.rddl.org/natures">Nature</a>.
         * @param role The RDDL <code>nature</code> is specified by the xlink:role
         * @return {@link java.util.SortedMap java.util.SortedMap} the <a href="Resource.html">resources</a> having the specified <code>role</code>
 */
	public abstract SortedMap getResourcesFromNature(String role);
	/** A <a href="Resource.html">resource</a> is qualified by its
         * <a href="http://www.rddl.org/purposes">Purpose</a>.
         * @return The collection of resources matching the purpose
         * @param purpose The <code>purpose</code> of a RDDL resource is specified by an <code>xlink:arcrole</code>
 */
        public abstract SortedMap getResourcesFromPurpose(String purpose);
/** Select a set of resources given the destination <code>xlink:href</code>
 * @param href The <code>xlink:href</code> URI
 * @return The collection of resources matching the <code>xlink:href</code>
 */ 
	public abstract SortedMap getResourcesFromHref(String href);
/** Select a set of resources having a specified <code>xlink:title</code>
 * @param title The <code>xlink:title</code>
 * @return the collection of resources having the xlink:title
 */        
	public abstract SortedMap getResourcesFromTitle(String title);
/** Select a set of <a href="Resource.html">resources</a> having a specified <code>xml:lang</code>
 * @param lang The <code>xml:lang</code>
 * @return A collection of selected resources
 */        
	public abstract SortedMap getResourcesFromLang(String lang);
/** <p>Select a set of <a href="Resource.html">resources</a> given a range of <code>ids</code>.
 * The <code>ids</code> are specified in alphanumeric order.
 * The idiom: &quot;foo&quot;,&quot;foo/0&quot; is inclusive.
 * </p>
 * @param id0 The start of the range
 * @param id1 The end of the range
 * @return A collection of selected resources
 */        
	public abstract SortedMap getResourcesFromIdRange(String id0,String id1);
/** Selects a <a href="Resource.html">resource</a> given a particular <code>id</code>.
 * @param id The <code>id</code>
 * @return The selected resource
 */        
	public abstract Resource getResourceFromId(String id);
/** Obtain an <code>Iterator</code> over all the resources contained in the <a href="Namespace.html">namespace</a>.
 * @return The resources in the namespace
 */        
	public abstract Iterator getResources();
/** The namespace URI for the namespace.
 * @return A String representing the namespace URI.
 */        
	public abstract String getURI();
}

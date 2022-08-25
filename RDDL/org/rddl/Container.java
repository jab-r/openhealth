package org.rddl;

import java.util.SortedMap;
import java.util.Iterator;
/** <p>A Container extends the Namespace interface adding methods to contain
 * URIs and to add resources to the collection.</p>
 * @author Jonathan Borden <jonathan@openhealth.org>
 */
public interface Container extends Namespace {
	/*
	public abstract SortedMap getResourcesFromNature(String href);
	public abstract SortedMap getResourcesFromPurpose(String arcrole);
	public abstract SortedMap getResourcesFromHref(String href);
	public abstract SortedMap getResourcesFromTitle(String title);
	public abstract SortedMap getResourcesFromLang(String lang);
	public abstract SortedMap getResourcesFromIdRange(String id0,String id1);
	public abstract Resource getResourceFromId(String id);
	public abstract Iterator getResources();
	public abstract String getURI();
	*/
/** Lookup <a href="Resource.html">resource<a> given URI.
 * @param uri The URI reference associated with a resource in the collection.
 * @return A resource.
 */    
	public abstract Resource getResourceFromURI(String uri);
/** Resources in a collection are ordered. This method selects a set of resources associated with a given range of URI references.
 * @param uri0 The starting URI of the range
 * @param uri1 The ending URI of the range
 * @return A collection of resources
 */        
	public abstract SortedMap getResourcesFromURIRange(String uri0,String uri1);
/** Add a <a href="Resource.html">resource</a> to the collection
 * @param r The resource to add
 */        
	public abstract void addResource(Resource r);
}

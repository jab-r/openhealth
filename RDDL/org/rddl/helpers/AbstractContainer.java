package org.rddl.helpers;

import org.rddl.Container;
import org.rddl.Resource;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
/**
 *
 */
public class AbstractContainer implements Container {
	public SortedMap getResourcesFromPurpose(String arcrole)
	{
		return arcroleMap.subMap(arcrole,arcrole+"\0");
	}
	public SortedMap getResourcesFromHref(String href)
	{
		return hrefMap.subMap(href,href+"\0");
	}
	public SortedMap getResourcesFromNature(String role)
	{
		return roleMap.subMap(role,role+"\0");
	}
	public SortedMap getResourcesFromTitle(String title)
	{
		return titleMap.subMap(title,title+"\0");
	}
	public SortedMap getResourcesFromLang(String lang)
	{
		return langMap.subMap(lang,lang+"\0");
	}
	public Resource getResourceFromId(String id)
	{
		return (Resource) uriMap.get(baseURI+"#"+id);
	}
	public Resource getResourceFromURI(String uri)
	{
		return (Resource) uriMap.get(uri);
	}
	public SortedMap getResourcesFromIdRange(String id0,String id1)
	{
		return uriMap.subMap(baseURI+"#"+id0,baseURI+"#"+id1);
	}
	public SortedMap getResourcesFromURIRange(String uri0,String uri1)
	{
		if (uri0 == null) {
			if (uri1 == null)
				return uriMap;
			else 
				return uriMap.tailMap(uri1);
		} else if (uri1 == null) {
			return uriMap.headMap(uri0);
		} else
		return uriMap.subMap(uri0,uri1);

	}
	public Iterator getResources()
	{
		return roleMap.values().iterator();
	}
	public void addResource(Resource r) {
			roleMap.put(r.getNature(),r);
			String purpose = r.getPurpose();
			String lang = r.getLang();
			String uri = r.getURI();
			String title = r.getTitle();
			String href = r.getHref();
			if (purpose != null)
				arcroleMap.put(purpose,r);
			if (lang != null)
				langMap.put(lang,r);
			if (title != null)
				titleMap.put(title,r);
			if (href != null)
				hrefMap.put(href, r);
			if (uri != null)
				uriMap.put(uri,r);
	}
	public String getURI() {
		return baseURI;
	}
	public AbstractContainer(String baseURI) {
		this.baseURI = baseURI;
	}
	protected String baseURI;
	protected TreeMap arcroleMap = new TreeMap();
	protected TreeMap hrefMap = new TreeMap();
	protected TreeMap roleMap = new TreeMap();
	protected TreeMap titleMap = new TreeMap();
	protected TreeMap langMap = new TreeMap();
	protected TreeMap uriMap = new TreeMap();
}

package org.rddl.helpers;

import org.rddl.*;
import org.rddl.helpers.*;
import org.rddl.sax.RDDLFilter;
import org.xml.sax.helpers.XMLFilterImpl;
import org.xml.sax.*;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.TreeMap;
import java.util.Iterator;

import org.xml.sax.SAXException;

public class RDDLURL /* extends URL */ {
	public RDDLURL(String namespaceURL)
	{
		this.namespaceURI = namespaceURL;
	}
	public RDDLURL(String namespaceURL, String roleURI, String arcroleURI)
	{
		this.namespaceURI = namespaceURL;
		this.arcrole = arcroleURI;
		this.role = roleURI;
	}

	public String getContentType()
	{
		return contentType;
	}
	public void setContentType(String ct) 
	{
		contentType = ct;
	}
	public void setPurpose(String ar) 
	{
		arcrole = ar;
	}
	public String getPurpose()
	{
		return arcrole;
	}
	public void setNature(String ar) 
	{
		role = ar;
	}
	public String getNature()
	{
		return role;
	}
	public URLConnection openConnection() 
		throws IOException {
		/* 
			have we already parsed a RDDL NS URI?
		*/
		URL url;
		try {
		Namespace ns = getNamespace(this.namespaceURI);
		Resource res = null;
		Iterator iter = ns.getResourcesFromNature(this.role).values().iterator();
		
		if (this.arcrole == null) {
			if (!iter.hasNext())
				throw new IOException();
			res = (Resource) iter.next();
		} else {
			while ((res == null) && iter.hasNext())
			{
				Resource r = (Resource) iter.next();
				if (this.arcrole.equals(r.getPurpose()))
				{
					res = r;
				};
			};
		};
		if (res == null)
			throw new IOException();
		//	res = (Resource) ns.getResourcesFromNature(this.role).get(this.role);
		url = new URL(new URL(res.getBaseURI()), res.getHref() );
		} catch(Exception e) {
			throw new IOException();
		};
		return url.openConnection();
	}
	public InputStream getInputStream()
		throws IOException {
		try{
			URLConnection urlc = openConnection();
			return urlc.getInputStream();
		} catch(Exception e) {
			throw new IOException();
			}
	}
	static public synchronized  Namespace getNamespace(String url) 
	throws IOException,SAXException {
		Namespace ns;
		ns = (Namespace) namespaceMap.get(url);
		if (ns == null) {
			RDDLFilter filter = new RDDLFilter();
			filter.parse(url);
			ns = filter.getNamespace();
			namespaceMap.put(url,ns);
		};
		return ns;
	}
	protected String namespaceURI;
	protected String arcrole = null;
	protected String role = null;
	protected String contentType = null;
	static TreeMap namespaceMap = new TreeMap();
}
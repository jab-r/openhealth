/**
 *	Resource Directory Description Language (RDDL) API
 *
 *	An XML-DEV project
 *	http://www.rddl.org/
 *
 *	This module, both source code and documentation, is in the Public Domain, 
 *	and comes with NO WARRANTY
 *
 *	@filename: resourceimpl.java
 *  @class: org.rddl.ResourceImpl
 *	@version: 0.1
 *  @date: 2001-01-06
 *	@author: Jonathan Borden <a href="mailto:jonathan@openhealth.org">jonathan@openhealth.org</a>
 */
package org.rddl.helpers;

import org.rddl.*;
import java.io.BufferedInputStream;
import java.io.InputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URLConnection;
import java.net.URL;

import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
//
//
// ResourceImpl
//
//
public class ContainerResourceImpl extends AbstractContainer implements Resource 
{
	public String getHref() 
	{
		return href;
	}
	public String getPurpose() 
	{
		return arcrole;
	}
	public String getNature() 
	{
		return role;
	}
	public String getTitle()
	{
		return title;
	}
	public String getId() 
	{
		return id;
	}
	public String getLang() 
	{
		return lang;
	}
	public String getBaseURI() {
		return baseURI;
	}
	public String getFragmentId() {
		return fragId;
	}

	public String getURI() {
		return (baseURI==null) ? "#"+fragId : baseURI + "#" + fragId;
	}
	public Container getContainer() {
		return (Container) this;
	}
	public ContainerResourceImpl(
					String id,String base,String ar,String r,String hr,
					String title,String lang,String fragId)
	{
		super(base);
		this.baseURI = base;
		this.arcrole = ar;
		this.role = r;
		this.href = hr;
		this.id = id;
		this.lang = lang;
		this.title = title;
		this.fragId = fragId;
	};

	protected String href;
	protected String title;

	protected String role;
	protected String arcrole;
	protected String id;
	protected String lang;
	protected String baseURI;
	protected String fragId;

}


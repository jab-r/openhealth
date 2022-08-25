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

//
//
// ResourceImpl
//
//
public class ResourceImpl implements Resource
{
	final static String s_userAgent = "RDDL 1.0";
	final static String s_rddlNSURI = "http://www.rddl.org/";
	final static int s_defaultBufferLength = 2048;


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
	public String getContentType() 
	{
		return contentType;
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

	public URLConnection getConnection(boolean bUseContentNegotiation,String accept)
		throws MalformedURLException,IOException {
		if (urlc == null) {
			URL url = (baseURI != null) ? new URL(new URL(baseURI),href) : new URL(href);
			urlc = url.openConnection();
			if (bUseContentNegotiation) {
				if (accept != null) {
					urlc.setRequestProperty("accept",accept);
				} else if (contentType != null) {
					urlc.setRequestProperty("accept",contentType);
				};
			};
			urlc.setRequestProperty("user-agent",userAgent);
		};
		return urlc;
	}
	public InputStream getInputStream() 
	throws MalformedURLException,IOException {
		if (inputStream == null) {
			if (urlc == null) {
				urlc = getConnection(false,null);
			};
			int len = urlc.getContentLength();
			if (len == -1)
				len = s_defaultBufferLength;
			inputStream = (InputStream) new BufferedInputStream(urlc.getInputStream(),len);
		};
		return inputStream;
	}
	/* 
		this implements resources which have collections
		default is null
	*/
	public void addResource(Resource r) {
		if (m_container == null)
			m_container = new AbstractContainer(baseURI);
		m_container.addResource(r);
	}
	public Container getContainer(){
		return (Container) m_container;
	}
	public String getUserAgent(){ return userAgent; }
	public void setUserAgent(String ua) { userAgent = ua; }
	public ResourceImpl(	String id,String base,
							String ar,String r,String hr,
							String title,String ct,String lang,
							String fragId)
	{
		this.inputStream = null;
		this.baseURI = base;
		this.arcrole = ar;
		this.role = r;
		this.href = hr;
		this.contentType = ct;
		this.id = id;
		this.lang = lang;
		this.title = title;
		this.fragId = fragId;
	};
	public InputStream inputStream;
	public URLConnection urlc;
	protected String href;
	protected String title;
	protected String contentType;
	protected String role;
	protected String arcrole;
	protected String id;
	protected String lang;
	protected String baseURI;
	protected String fragId;
	protected String userAgent = s_userAgent;
	protected AbstractContainer m_container = null;
}


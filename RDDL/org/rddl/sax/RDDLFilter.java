/**
 *	Resource Directory Description Language (RDDL) API
 *
 *	An XML-DEV project
 *	http://www.rddl.org/
 *
 *	This module, both source code and documentation, is in the Public Domain, 
 *	and comes with NO WARRANTY
 *
 *	@filename: rddlfilter.java
 *  @class: org.rddl.sax.RDDLFilter
 *	@version: 0.5
 *  @date: 2001-01-26
 *	@author: Jonathan Borden <a href="mailto:jonathan@openhealth.org">jonathan@openhealth.org</a>
 */
package org.rddl.sax;

import org.rddl.*;
import org.rddl.helpers.*;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import java.util.Iterator;
import java.util.SortedMap;

import org.xml.sax.ContentHandler;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLFilter;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;
import org.xml.sax.helpers.XMLFilterImpl;

//
//
// RDDLFilter
//
//
public class RDDLFilter extends XMLFilterImpl
{
	static final String VERSION = "RDDL 1.0 Java 0.1";
	static final String RDDL_RESOURCE_URI = "http://www.rddl.org/#resource";
	static int s_DefaultBufferLength = 2048;
	public Namespace getNamespace() {
		return namespace;
	};
	/**
	 * <p>getConnection</p>
	 * <p>A helper class to build an HTTP request of the namespace URI.</p>
	 * @param userAgent an optional user-agent
	 * @param contentType an optional content-type for an accept header
	 * @returns URLConnection
	 */
 	public URLConnection getConnection() 
		throws MalformedURLException,IOException
	{
			connection = (new URL(namespaceURI)).openConnection();
			if (m_contentType != null)
				connection.setRequestProperty("accept",m_contentType);
			if (m_userAgent != null)
				connection.setRequestProperty("user-agent",m_userAgent);
			return connection;
	}
	/**
	 *
	 * <p>Algorithm for obtaining resource is roughly:</p>
	 * <p>-If this is a RDDL namespace return resource of arcrole.
	 * Well known arcroles are mapped to root namespace of resource.</p>
	 * <p>-If this is a non-RDDL namespace, and if arcrole == root namespace URI
	 * return resource. If this provides no result match arcrole to content-type</p>
	 * @param arcrole
	 * @returns Resource
	 * @exception AmbiguousMappingException -- more than one resource uses this arcrole
	 */
 	public Resource getResource(String nature,String purpose) 
	throws AmbiguousMappingException,IOException,SAXException
	{
		Namespace ns = RDDLURL.getNamespace(namespaceURI);
		Resource res = null;
		/* try this first */
		SortedMap map = null;
		if (nature != null) {
			map = ns.getResourcesFromNature(nature);
			if (purpose == null) {
				if (map.size()==1)
					res = (Resource) map.get(nature);
				else if (map.size()>1) {
					throw new AmbiguousMappingException();
				};
			} else {
				Iterator iter = map.values().iterator();
				while (iter.hasNext()) {
					Resource r = (Resource) iter.next();
					if (purpose.equals(r.getPurpose()))
						res = r;
				};
			};
		} else if (purpose != null) {
			map = ns.getResourcesFromPurpose(purpose);
			if (nature == null) {
				if (map.size()==1)
					res = (Resource) map.get(purpose);
				else if (map.size()>1) {
					throw new AmbiguousMappingException();
				};
			} else {
				Iterator iter = map.values().iterator();
				while (iter.hasNext()) {
					Resource r = (Resource) iter.next();
					if (nature.equals(r.getNature()))
						res = r;
				};
			};
		};
		if (res == null) {
			if (!bRDDLNamespace) {
			/* 
				<p>lookup content-type in well known arcrole directory (RDDL)
				if the content-type matches the content type of the response
				then return then return the identity resource (i.e. map the arcrole to
				the namespace URI.</p>
			*/
				String contentType = (nature != null) 
										? Mappings.getContentTypeFromNature(nature)
										: null;
				if ((contentType != null) &&
					(connection != null) && contentType.equals(connection.getContentType())) {
					map = ns.getResourcesFromNature(namespaceURI);
					if (map.size() == 1)
						res = (Resource) map.get(namespaceURI);
					else if (map.size() > 1)
						throw new AmbiguousMappingException();
				};
			};
		};
		return res;
	}
	/**
	 * @param nsURI a namespace URI to parse as RDDL if possible
	 */
	public void parse(String nsURI)
	throws IOException, SAXException
	{
		InputSource insrc = new InputSource(nsURI);
		parse(insrc);
	}
	/**
	 * @param insrc An InputSource to parse as RDDL if possible
	 */
	public void parse(InputSource insrc)
	throws IOException, SAXException
	{
		// the namespace URI is what we are parsing
		namespaceURI = insrc.getSystemId();
		// this is because most SAX2 drivers are buggy with endElement()
		org.xml.sax.helpers.ParserAdapter adapt = new org.xml.sax.helpers.ParserAdapter();
		XMLReader reader = (XMLReader) adapt; //XMLReaderFactory.createXMLReader();
		//reader.setFeature("http://xml.org/sax/features/namespace-prefixes",true);
		try{
			reader.setFeature("http://xml.org/sax/features/namespaces",true);
		} catch(Exception e) {
			e.printStackTrace();
			throw new SAXException(e);
		};

		/*
			this handler checks the namespace of the root element
			builds the maps in the parent as rddl:resource elemements are found
		*/
		Container cont = (Container) new AbstractContainer(namespaceURI);
		namespace = (Namespace) cont;
		RDDLHandler handler = new RDDLHandler(cont);
		reader.setContentHandler((ContentHandler)handler);
		reader.setEntityResolver((EntityResolver)this);
		InputStream inputStream = insrc.getByteStream();
		URLConnection urlc = null;
		int len = s_DefaultBufferLength;
		if (inputStream == null) {
			InputSource is = resolveEntity(insrc.getPublicId(),insrc.getSystemId());
			 if (is == null) {
				urlc = getConnection(); // sets connection
				len = urlc.getContentLength();
				if (len == -1) len = s_DefaultBufferLength;
				inputStream =  (InputStream) new BufferedInputStream(urlc.getInputStream(),len);
			 } else {
			 	inputStream = is.getByteStream();
			 }
		}
		if (!inputStream.markSupported())
				inputStream = (InputStream) new BufferedInputStream(inputStream,len);
		inputStream.mark(len);
		try{
			InputSource is = new InputSource(inputStream);
			insrc.setSystemId(namespaceURI);
			reader.parse(is);
			bRDDLNamespace = true;
			// this should be XHTML if we've got here
			contentURI = handler.rootNS;
			if (handler.resourceCount == 0)
				bRDDLNamespace = false;	
		} catch (SAXException e) {
			bRDDLNamespace = false;
			inputStream.reset();
			contentURI = handler.rootNS;
		};
		/* 
			now also build an identify resource which referenced the namespace URI directly
			for both RDDL and non-RDDL namespaces
		*/
		{
			String contentType = (urlc != null) ? urlc.getContentType() : null;
			/* nature and href are root namespace */
			String role = (handler.rootNS == null) ? Mappings.MIME_URI_prefix + contentType :
							handler.rootNS;
			String href = namespaceURI;
			String arcrole = Mappings.RDDL_resource;

			ResourceImpl res = new ResourceImpl(
										null, 			// this has no id
										namespaceURI, 	// baseURI
										arcrole,		// xlink:arcrole
										role,			// xlink:role
										href,			// xlink:href
										null,			// xlink:title
										contentType,	// contentType
										null,			// lang
										null			// no fragment id either
										);
			try{
				inputStream.reset();
				res.inputStream = inputStream;
			} catch (IOException e) {
				res.inputStream = null;
			};
			res.urlc = urlc;
			cont.addResource((Resource)res);
		};
	}
	public void setFeature(String feature,boolean flag) 
			throws org.xml.sax.SAXNotRecognizedException,
                   org.xml.sax.SAXNotSupportedException {
		if (feature.equals("http://www.rddl.org/object-model#containers"))
			containers = flag;
		else
			super.setFeature(feature,flag);
	}
	public void setContentType(String val)
	{
		m_contentType = val;
	}
	public void setUserAgent(String val)
	{
		m_userAgent = val;
	}

	/**
	 *	<p>namespaceURI</p>
	 *	<p>The URI of the namespace we are resolving</p>
	 */
	public String namespaceURI = null;
	/**
	 *	<p>contentURI</p>
	 *	<p>The URI of the root element of the resolved document.</p>
	 */
	public String contentURI = null;
	protected boolean bRDDLNamespace = false;
	protected URLConnection connection = null;
	protected String m_contentType = null;
	protected String m_userAgent = VERSION;
	protected Namespace namespace = null;
	protected boolean containers = true;
}


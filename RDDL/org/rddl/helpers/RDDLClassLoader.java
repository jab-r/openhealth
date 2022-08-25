/*
 * RDDLClassLoader.java
 *
 * Created on March 3, 2001, 10:55 AM
 */

package org.rddl.helpers;
import java.util.SortedMap;
import java.util.Vector;
import java.util.Iterator;
import java.net.URL;

import org.rddl.Resource;
/**
 *
 * @author  Jonathan Borden <jonathan@openhealth.org>
 * @version 
 */
public class RDDLClassLoader extends java.net.URLClassLoader {
    static final String STR_NATURE_JAVA = "http://www.rddl.org/natures#java";
    static final String STR_NATURE_JAR = "http://www.rddl.org/natures#JAR";
    /** Creates new RDDLClassLoader
     * @param nsUrl the namespace URI
     * @param purposeURI The <code>purpose</code> of this ClassLoader connection
     * @throws IOException
     * @throws SAXException
 */
    public RDDLClassLoader(String nsUrl,String purposeURI) throws java.io.IOException,org.xml.sax.SAXException{
        super(buildUriList(nsUrl,purposeURI));
    }

/** This is an internal static method that creates a URL array from the RDDL URI and purpose
 * The <code>nature</code> is either "java" or "JAR"
 * @param URI The namespace URI
 * @param purposeURI The RDDL <code>purpose</code>
 * @throws IOException
 * @throws SAXException
 * @return URL[] - an array of URLs -- this is typically passed to the
 * constructor of URLClassLoader()
 */    
    protected static URL[] buildUriList(java.lang.String URI,java.lang.String purposeURI) throws java.io.IOException,org.xml.sax.SAXException {
        org.rddl.Namespace ns = RDDLURL.getNamespace(URI);
        java.util.SortedMap ress0 = ns.getResourcesFromNature(STR_NATURE_JAVA);
        java.util.TreeMap ress = new java.util.TreeMap(ress0);
        ress.putAll(ns.getResourcesFromNature(STR_NATURE_JAR));
        java.util.Vector strArr = new java.util.Vector();
        Iterator iter = ress.values().iterator();
        while(iter.hasNext())
        {
            Resource res = (Resource)iter.next();
            if (purposeURI.equals(res.getPurpose()))
                strArr.addElement(res.getHref());
        }
        int len = strArr.size();
        URL[] uris = new URL[len];
        URL baseURL = new URL(URI);
        for(int i=0;i<len;i++){
            uris[i] = new URL(baseURL,(String)strArr.elementAt(i));
        };
        return uris;
    }
    
}

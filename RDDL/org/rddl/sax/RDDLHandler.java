/**
 *	Resource Directory Description Language (RDDL) API
 *
 *	An XML-DEV project
 *	http://www.rddl.org/
 *
 *	This module, both source code and documentation, is in the Public Domain, 
 *	and comes with NO WARRANTY
 *
 *	@filename: rddlhandler.java
 *  @class: org.rddl.sax.RDDLHandler
 *	@version: 0.5
 *  @date: 2001-01-26
 *	@author: Jonathan Borden <a href="mailto:jonathan@openhealth.org">jonathan@openhealth.org</a>
 */
package org.rddl.sax;

import org.rddl.*;
import org.rddl.helpers.*;

import java.util.Stack;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;

import org.xml.sax.helpers.DefaultHandler;

//
//
// RDDLHandler
//
//
class RDDLHandler extends DefaultHandler
{
	private final static boolean debug = true;
	protected Container parent;
	protected String rootNS = null;
	protected String rootLocalName = null;
	protected boolean bRoot = true;
	protected int resourceCount = 0;
	protected Stack stateStack = new Stack();
	// initial state
	protected boolean bStartFlag = true;
	protected int index = 0;
	protected int depth = 0;
	protected String currentId = null;
	protected Resource currentResource = null;
class State {
	protected int siblingIndex;
	protected String id;
	protected int depth;
	protected Resource resource;
	protected boolean bStartFlag;
	protected State(String id, int depth, Resource res, int sibcount, boolean bstart) {
		this.id = id;
		this.depth = depth;
		this.resource = res;
		this.siblingIndex = sibcount;
		this.bStartFlag = bstart;
		}
}
/**
 * @param namespaceURI - the namespace URI of the element, see SAX2
 * @param localName - the localName of the element, see SAX2
 * @param qName - the qName of the element
 * @param atts - the Attributes
 * @return void
 @ @exception SAXException
 */
    public void startElement (String namespaceURI, String localName,
			      String qName, Attributes atts)
				  throws SAXException {
		/*
			check what the namespace of the root element is
			if its XHTML then its RDDL (assuming rddl:resource elements are found)
			if not, then save the namespaceURI and punt ... the namespaceURI of the root
			element does tell us something about what we got back.
		*/
		/* first increment depth -- this isn't really that important
			currently we don't produce a real XPointer because only div and rddl:resource
			elements are being tracked -- to be more correct the ChildSeq should keep track
			of all the elements
		*/
		depth += 1;
		if (bRoot) {
			rootNS = namespaceURI;
			rootLocalName = localName;
			if (!rootNS.equals(Mappings.XHTML_NS))
				throw new SAXException(namespaceURI);
			bRoot = false;
			bStartFlag = true;
		} else if (namespaceURI.equals(Mappings.RDDL_NS) &&
			localName.equals("resource")) {
			resourceCount += 1;
				// save state of parent
		if (debug)
			System.out.println("pushing state ID="+currentId+" depth = "+(depth-1)+" index= " +index);

			// keep track of sibling index for ChildSeq generation
			if (bStartFlag)
				index = 1;
			else
				index += 1;
			/*
				tag state includes:
					siblingIndex -- bStartFlag resets count to 1
					bStartFlag -- set to true at end of startElement, false at end of endElement
					id
					resource -- parent resource for collection support
			*/
			stateStack.push(new State(currentId,depth-1,currentResource,index,bStartFlag));
			
			String arcrole = atts.getValue(Mappings.XLINK_NS,"arcrole");
			String href = atts.getValue(Mappings.XLINK_NS,"href");
			String role = atts.getValue(Mappings.XLINK_NS,"role");
			String title = atts.getValue(Mappings.XLINK_NS,"title");
			String lang = atts.getValue("xml:lang");
			String base = atts.getValue("xml:base");
			String id = atts.getValue("id");
			if (debug)
				System.out.println("Resource: (id="+id+" arcrole="+arcrole+" role="+role+" href="+href+")");
			//String rootNS = Mappings.getRootNamespaceURIFromArcrole(arcrole);
			if (id != null) {
				currentId = id;
			} else {
			/*
				currentId builds what ought to be a proper ChildSeq however
				not all XHTML elements are being tracked...
			*/
				currentId = ((currentId == null) ? "" : currentId) + "/" + (new Integer(index)).toString();
			};
			ResourceImpl res = new ResourceImpl(
										id,
										(base == null) ? parent.getURI() : base,
										arcrole,
										role,
										href,
										title,
										null,
										lang,
										currentId // this is our xpointer fragment id
										);
			if (role == null)
				role = Mappings.RDDL_resource;

			parent.addResource((Resource)res);
			if (debug) System.out.println("parent ID="+currentId);
			// set state of this element
			bStartFlag = true;

		if (debug)
			System.out.println("<"+localName+"> ID="+currentId+" depth = "+(depth-1)+" index= " +index);
			currentResource = res;

	
		} else if (namespaceURI.equals(Mappings.XHTML_NS) &&
					localName.equals("div")) {
			// set current sibling index
			if (bStartFlag)
				index = 1;
			else
				index += 1;
		if (debug)
			System.out.println("pushing state ID="+currentId+" depth = "+(depth-1)+" index= " +index);

			stateStack.push(new State(currentId,depth-1,currentResource,index,bStartFlag));

			String id = atts.getValue("id");
			String lang = atts.getValue(Mappings.XML_NS,"lang");
			ContainerResourceImpl cont = null;
			String role = "http://www.rddl.org/natures#container";
			String arcrole = null;
			if (id != null) {
				currentId = id;
			} else {
			/*
				currentId builds what ought to be a proper ChildSeq however
				not all XHTML elements are being tracked...
			*/
				currentId = ((currentId == null) ? "" : currentId) + "/" + (new Integer(index)).toString();
			};
	
			if (id != null) {
				cont = new ContainerResourceImpl(
										id,
										null,
										arcrole,
										role,
										null,
										null,
										lang,
										currentId
										);
			};

			bStartFlag = true;
		if (debug)
			System.out.println("<"+localName+"> ID="+currentId+" depth = "+(depth-1)+" index= " +index);
			currentResource = (Resource) cont;
		};
	}
	public void endElement( String namespaceURI,
              String localName,
              String qName ) throws SAXException {
		depth -= 1;
	
		if (namespaceURI.equals(Mappings.RDDL_NS) &&
					localName.equals("resource")) {
			State state = (State) stateStack.pop();
			currentId = state.id;
			currentResource = state.resource;
			index = state.siblingIndex;
			bStartFlag = false;
			if (debug) 
			System.out.println("</"+localName+"> popping state ID="+currentId+" depth = "+depth+" index= " +index);

		} else if (namespaceURI.equals(Mappings.XHTML_NS) &&
					localName.equals("div")) {
			State state = (State) stateStack.pop();
			currentId = state.id;
			currentResource = state.resource;
			index = state.siblingIndex;
			bStartFlag = false;
			if (debug) 
			System.out.println("</"+localName+"> popping state ID="+currentId+" depth = "+depth+" index= " +index);

		};
   }


	protected RDDLHandler(Container par) {
		resourceCount = 0;
		parent = par;
	};
}


public class Statement {
 	public String subject;
 	public String predicate;
 	public String object;
 	public String xmllang;
 	public String xmlbase;
 	public String propertyId;
 	public String datatype;
	public Statement(String s,String p,String o,String lang,String base,String pid,String dt)
	{
		subject = s;
		predicate = p;
		object = o;
		xmllang = lang;
		xmlbase = base;
		propertyId = pid;
		datatype = dt;
	}
}

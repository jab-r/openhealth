package org.rddl.helpers;

public class ResourceMap extends HashMap
{
	public static final int NATURE = 1;
	public static final int PURPOSE = 2;
	public static final int LANG = 4;
	public static final int ID = 8;
	public static final int LANG = 16;
	public static final int HREF = 32;
	public ResourceMap(SortedMap ress,int type)
	{
			Iterator iter = ress.values().iterator();
		if (type == NATURE) {
			for (Resource res = (Resource)iter.nextElement();iter.moreElements();)
			{
				put(res.getNature(),res);
			}
		} else if (type == PURPOSE) {
			for (Resource res = (Resource)iter.nextElement();iter.moreElements();)
			{
				put(res.getPurpose(),res);
			}
		} else if (type == LANG) {
			for (Resource res = (Resource)iter.nextElement();iter.moreElements();)
			{
				put(res.getLang(),res);
			}
		} else if (type == ID) {
			for (Resource res = (Resource)iter.nextElement();iter.moreElements();)
			{
				put(res.getId(),res);
			}
		} else if (type == HREF) {
			for (Resource res = (Resource)iter.nextElement();iter.moreElements();)
			{
				put(res.getHref(),res);
			}
		}
}
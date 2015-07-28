package sirius.seo;

/**
 * @author Rafael Moreira
 */

interface IItem {
	public var name:String;
	public var position:String;
	public var item:IItem;
}
package sirius.seo;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IItem {
	public var name:String;
	public var position:String;
	public var item:IItem;
}
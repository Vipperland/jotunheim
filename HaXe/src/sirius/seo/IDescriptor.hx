package sirius.seo;

/**
 * @author Rafael Moreira
 */

interface IDescriptor {
	public var name:String;
	public var url:String;
	public var logo:String;
	public var sameAs:Array<String>;
	public var address:IAddress;
	public var email:String;
	public var telephone:String;
}
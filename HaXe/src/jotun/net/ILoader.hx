package jotun.net;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
interface ILoader {

	public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void;

	public function request(url:String, ?data:Dynamic, ?method:String, ?handler:IRequest->Void, ?headers:Dynamic):Void;

	#if js
	public function fetch(url:String, ?data:Null<js.html.RequestInit>, ?handler:Null<IRequestHandler>):IRequestHandler;
	#end

}

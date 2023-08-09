package jotun.net;
import js.html.AbortController;
import js.html.DOMError;
import js.lib.Promise;

/**
 * @author Rafael Moreira
 */
typedef IRequestHandler = {
	var ?abort:Null<AbortController>;
	var ?before:Null<Dynamic->Dynamic>;
	var ?complete:Null<jotun.net.Response->Void>;
	var ?data:Dynamic;
	var ?error:DOMError;
	var ?module:Bool;
	var ?promise:Null<Promise<Dynamic>>;
	var ?pulsar:Bool;
	var ?request:js.html.Request;
	var ?response:js.html.Response;
	var ?type:Null<String>;
}
package jotun.net;
import js.html.AbortController;
import js.lib.Promise;

/**
 * @author Rafael Moreira
 */
typedef IRequestHandler = {
	var ?abort:Null<AbortController>;
	var ?before:Null<Dynamic->Dynamic>;
	var ?complete:Null<jotun.net.Response->Void>;
	var ?promise:Null<Promise<Dynamic>>;
	var ?type:Null<String>;
}
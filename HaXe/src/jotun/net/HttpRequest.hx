package jotun.net;
import haxe.Json;
import jotun.serial.JsonTool;
import jotun.utils.Dice;

/**
 * ... Modified version of Http.hx
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */

/*
 * Copyright (C)2005-2013 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#if sys

import sys.net.Host;
import sys.net.Socket;

private typedef AbstractSocket = {
	var input(default,null) : haxe.io.Input;
	var output(default,null) : haxe.io.Output;
	function connect( host : Host, port : Int ) : Void;
	function setTimeout( t : Float ) : Void;
	function write( str : String ) : Void;
	function close() : Void;
	function shutdown( read : Bool, write : Bool ) : Void;
}

#elseif js

import js.html.FormData;
import js.html.ProgressEvent;
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;

#end

/**
	This class can be used to handle Http requests consistently across
	platforms. There are two intended usages:

	- call haxe.Http.requestUrl(url) and receive the result as a String (not
	available on flash)
	- create a new haxe.Http(url), register your callbacks for onData, onError
	and onStatus, then call request().
**/
class HttpRequest {

	/**
		The url of `this` request. It is used only by the request() method and
		can be changed in order to send the same request to different target
		Urls.
	**/
	public var url : String;
	public var responseData(default, null) : Null<String>;
#if sys
	public var noShutdown : Bool;
	public var cnxTimeout : Float;
	public var responseHeaders : Map<String,String>;
	var chunk_size : Null<Int>;
	var chunk_buf : haxe.io.Bytes;
	var file : { param : String, filename : String, io : haxe.io.Input, size : Int, mimeType : String };
#elseif js
	public var async : Bool;
	public var data : FormData;
	public var responseHeaders : Dynamic;
#end
	var postData : String;
	var headers : Array<Dynamic>;
	var params : Array<Dynamic>;

	#if sys
	public static var PROXY : { host : String, port : Int, auth : { user : String, pass : String } } = null;
	#end

	/**
		Creates a new Http instance with `url` as parameter.

		This does not do a request until request() is called.

		If `url` is null, the field url must be set to a value before making the
		call to request(), or the result is unspecified.

		(Php) Https (SSL) connections are allowed only if the OpenSSL extension
		is enabled.
	**/
	public function new( url : String ) {
		this.url = url;
		headers = [];
		params = [];

		#if js
		async = true;
		#elseif sys
		cnxTimeout = 10;
		#end
		#if php
		noShutdown = !php.Syntax.codeDeref('function_exists({0})', 'stream_socket_shutdown');
		#end
	}

	/**
		Sets the header identified as `header` to value `value`.

		If `header` or `value` are null, the result is unspecified.

		This method provides a fluent interface.
	**/
	public function setHeader( header : String, value : String ):HttpRequest {
		headers.push({ header:header, value:value });
		return this;
	}

	public function addHeader( header : String, value : String ):HttpRequest {
		headers.push({ header:header, value:value });
		return this;
	}
	
	#if !js 
		/**
			Sets the parameter identified as `param` to value `value`.

			If `header` or `value` are null, the result is unspecified.

			This method provides a fluent interface.
		**/
		public function setParameter( param : String, value : String ):HttpRequest {
			params.push({ param:param, value:value });
			return this;
		}
	#end

	public function addParameter( param : String, value : Dynamic ):HttpRequest {
		#if js 
			if (data == null) 
				data = new FormData();
			data.append(param, value);
		#else
			params.push( { param:param, value:Std.string(value) } );
		#end
		return this;
	}

#if js
	
	var req:js.html.XMLHttpRequest;
	
	public function setData(data:FormData):HttpRequest {
		this.data = data;
		return this;
	}
	
	public function setOptions(data:Dynamic):Void {
		if (data != null){
			Dice.All(data, function(p:String, v:Dynamic):Void {
				Reflect.setField(req, p, v);
			});
		}
	}
	
	/**
		Cancels `this` Http request if `request` has been called and a response
		has not yet been received.
	**/
	public function cancel()
	{
		if (req == null) 
			return;
		req.abort();
	}
	
#end

	

	/**
		Sends `this` Http request to the Url specified by `this.url`.

		If `post` is true, the request is sent as POST request, otherwise it is
		sent as GET request.

		Depending on the outcome of the request, this method calls the
		onStatus(), onError() or onData() callback functions.

		If `this.url` is null, the result is unspecified.

		If `this.url` is an invalid or inaccessible Url, the onError() callback
		function is called.

		(Js) If `this.async` is false, the callback functions are called before
		this method returns.
	**/
		
	
	
	#if js
	
		private function _getData(r:XMLHttpRequest):Dynamic {
			if ((cast r.responseType) == '' || (cast r.responseType) == 'text'){
				return r.responseText;
			}else{
				return r.response;
			}
		}
		
		public function request(?method:String, ?data:Dynamic, ?progress:String->Int->Int->Void, ?options:Dynamic) : Void {
			var me = this;
			me.responseData = null;
			var r = req = js.Browser.createXMLHttpRequest();
			setOptions(options);
			var onreadystatechange = function(_) {
				if( r.readyState != 4 )
					return;
				var s = try r.status catch( e : Dynamic ) null;
				if ( s != null ) {
					// If the request is local and we have data: assume a success (jQuery approach):
					var protocol = js.Browser.location.protocol.toLowerCase();
					var rlocalProtocol = ~/^(?:about|app|app-storage|.+-extension|file|res|widget):$/;
					var isLocal = rlocalProtocol.match(protocol);
					if ( isLocal ){
						me.responseHeaders = me.req.getAllResponseHeaders();
						s = _getData(r) != null ? 200 : 404;
					}
				}
				if( s == js.Syntax.code("undefined") )
					s = null;
				if( s != null )
					me.onStatus(s);
				if ( s != null && s >= 200 && s < 400 ) {
					me.responseHeaders = _parseHeader(me.req.getAllResponseHeaders());
					me.req = null;
					me.onData(me.responseData = _getData(r));
				}
				else if ( s == null ) {
					me.req = null;
					me.onError("Failed to connect or resolve host");
				}
				else switch( s ) {
				case 12029:
					me.req = null;
					me.onError("Failed to connect to host");
				case 12007:
					me.req = null;
					me.onError("Unknown host");
				default:
					me.req = null;
					me.responseData = _getData(r);
					me.onError("Http Error #"+r.status);
				}
			};
			if ( async ){
				r.onreadystatechange = onreadystatechange;
			}
			var uri:Dynamic = null;
			try {
				if (progress != null){
					r.onprogress = function(e:ProgressEvent){
						if (e.lengthComputable)
							progress(url, e.loaded, e.total);
						else
							progress(url, e.loaded, 0);
					}
					r.onloadend = r.onloadstart = function(e:ProgressEvent){
						progress(url, 0, 0);
					}
				}
				r.open(method, url, async);
			} catch( e : Dynamic ) {
				me.req = null;
				onError(e.toString());
				return;
			}
			var is_json:Bool = false;
			if(headers.length > 0){
				Dice.Values(headers, function(v):Void {
					if (!is_json){
						is_json = v.header.toLowerCase() == "content-type" && v.value.toLowerCase() == 'application/json';
					}
					r.setRequestHeader(v.header, v.value);
				});
			}
			if (is_json){
				if (!Std.isOfType(data, String)){
					data = Json.stringify(data);
				}
				r.send(data);
			}else{
				r.send(this.data);
			}
			if( !async )
				onreadystatechange(null);
		}
		
		function _parseHeader(headers:String):Dynamic {
			var line:Array<String> = headers.split("\r\n");
			var res:Dynamic = {};
			Dice.Values(line, function(o:String){
				line = o.split(": ");
				var prop:String = line.shift().toLowerCase();
				var value:String = line.join('');
				Reflect.setField(res, prop, value);
			});
			return res;
		}
		
	#else
		public function request( ?post : Bool) : Void {
			var me = this;
			var me = this;
			var output = new haxe.io.BytesOutput();
			var old = onError;
			var err = false;
			onError = function(e) {
				#if neko
				me.responseData = neko.Lib.stringReference(output.getBytes());
				#else
				me.responseData = output.getBytes().toString();
				#end
				err = true;
				// Resetting back onError before calling it allows for a second "retry" request to be sent without onError being wrapped twice
				onError = old;
				onError(e);
			}
			customRequest(post,output);
			if( !err )
			#if neko
				me.onData(me.responseData = neko.Lib.stringReference(output.getBytes()));
			#else
				me.onData(me.responseData = output.getBytes().toString());
			#end
		}
	#end

#if sys

	/**
      Note: Deprecated in 4.0
	 **/
	@:noCompletion
	inline public function fileTransfert( argname : String, filename : String, file : haxe.io.Input, size : Int, mimeType = "application/octet-stream" ) {
	    fileTransfer(argname, filename, file, size, mimeType);
    }

	public function fileTransfer( argname : String, filename : String, file : haxe.io.Input, size : Int, mimeType = "application/octet-stream" ) {
		this.file = { param : argname, filename : filename, io : file, size : size, mimeType : mimeType };
	}

	public function customRequest( post : Bool, api : haxe.io.Output, ?sock : AbstractSocket, ?method : String  ) {
		this.responseData = null;
		var url_regexp = ~/^(https?:\/\/)?([a-zA-Z\.0-9_-]+)(:[0-9]+)?(.*)$/;
		if( !url_regexp.match(url) ) {
			onError("Invalid URL");
			return;
		}
		var secure = (url_regexp.matched(1) == "https://");
		if( sock == null ) {
			if( secure ) {
				#if php
					sock = new php.net.SslSocket();
					#elseif hxssl
						#if neko
							sock = new neko.tls.Socket();
						#else
							sock = new sys.ssl.Socket();
						#end
					#else
						throw "Https is only supported with -lib hxssl";
				#end
			} else
				sock = new Socket();
		}
		var host = url_regexp.matched(2);
		var portString = url_regexp.matched(3);
		var request = url_regexp.matched(4);
		if( request == "" )
			request = "/";
		var port = if ( portString == null || portString == "" ) secure ? 443 : 80 else Std.parseInt(portString.substr(1, portString.length - 1));
		var data;

		var multipart = (file != null);
		var boundary = null;
		var uri = null;
		if( multipart ) {
			post = true;
			boundary = Std.string(Std.random(1000))+Std.string(Std.random(1000))+Std.string(Std.random(1000))+Std.string(Std.random(1000));
			while( boundary.length < 38 )
				boundary = "-" + boundary;
			var b = new StringBuf();
			for( p in params ) {
				b.add("--");
				b.add(boundary);
				b.add("\r\n");
				b.add('Content-Disposition: form-data; name="');
				b.add(p.param);
				b.add('"');
				b.add("\r\n");
				b.add("\r\n");
				b.add(p.value);
				b.add("\r\n");
			}
			b.add("--");
			b.add(boundary);
			b.add("\r\n");
			b.add('Content-Disposition: form-data; name="');
			b.add(file.param);
			b.add('"; filename="');
			b.add(file.filename);
			b.add('"');
			b.add("\r\n");
			b.add("Content-Type: "+file.mimeType+"\r\n"+"\r\n");
			uri = b.toString();
		} else {
			for( p in params ) {
				if( uri == null )
					uri = "";
				else
					uri += "&";
				uri += StringTools.urlEncode(p.param)+"="+StringTools.urlEncode(p.value);
			}
		}

		var b = new StringBuf();
		if( method != null ) {
			b.add(method);
			b.add(" ");
		} else if( post )
			b.add("POST ");
		else
			b.add("GET ");

		if( HttpRequest.PROXY != null ) {
			b.add("http://");
			b.add(host);
			if( port != 80 ) {
				b.add(":");
				b.add(port);
			}
		}
		b.add(request);

		if( !post && uri != null ) {
			if( request.indexOf("?",0) >= 0 )
				b.add("&");
			else
				b.add("?");
			b.add(uri);
		}
		b.add(" HTTP/1.1\r\nHost: "+host+"\r\n");
		if( postData != null )
			b.add("Content-Length: "+postData.length+"\r\n");
		else if( post && uri != null ) {
			if( multipart || !Lambda.exists(headers, function(h) return h.header == "Content-Type") ) {
				b.add("Content-Type: ");
				if( multipart ) {
					b.add("multipart/form-data");
					b.add("; boundary=");
					b.add(boundary);
				} else
					b.add("application/x-www-form-urlencoded");
				b.add("\r\n");
			}
			if( multipart )
				b.add("Content-Length: "+(uri.length+file.size+boundary.length+6)+"\r\n");
			else
				b.add("Content-Length: "+uri.length+"\r\n");
		}
		for( h in headers ) {
			b.add(h.header);
			b.add(": ");
			b.add(h.value);
			b.add("\r\n");
		}
		b.add("\r\n");
		if( postData != null)
			b.add(postData);
		else if( post && uri != null )
			b.add(uri);
		try {
			if( HttpRequest.PROXY != null )
				sock.connect(new Host(HttpRequest.PROXY.host),HttpRequest.PROXY.port);
			else
				sock.connect(new Host(host),port);
			sock.write(b.toString());
			if( multipart ) {
				var bufsize = 4096;
				var buf = haxe.io.Bytes.alloc(bufsize);
				while( file.size > 0 ) {
					var size = if( file.size > bufsize ) bufsize else file.size;
					var len = 0;
					try {
						len = file.io.readBytes(buf,0,size);
					} catch( e : haxe.io.Eof ) break;
					sock.output.writeFullBytes(buf,0,len);
					file.size -= len;
				}
				sock.write("\r\n");
				sock.write("--");
				sock.write(boundary);
				sock.write("--");
			}
			readHttpResponse(api,sock);
			sock.close();
		} catch( e : Dynamic ) {
			try sock.close() catch( e : Dynamic ) { };
			onError(Std.string(e));
		}
	}

	function readHttpResponse( api : haxe.io.Output, sock : AbstractSocket ) {
		// READ the HTTP header (until \r\n\r\n)
		var b = new haxe.io.BytesBuffer();
		var k = 4;
		var s = haxe.io.Bytes.alloc(4);
		sock.setTimeout(cnxTimeout);
		while( true ) {
			var p = sock.input.readBytes(s,0,k);
			while( p != k )
				p += sock.input.readBytes(s,p,k - p);
			b.addBytes(s,0,k);
			switch( k ) {
			case 1:
				var c = s.get(0);
				if( c == 10 )
					break;
				if( c == 13 )
					k = 3;
				else
					k = 4;
			case 2:
				var c = s.get(1);
				if( c == 10 ) {
					if( s.get(0) == 13 )
						break;
					k = 4;
				} else if( c == 13 )
					k = 3;
				else
					k = 4;
			case 3:
				var c = s.get(2);
				if( c == 10 ) {
					if( s.get(1) != 13 )
						k = 4;
					else if( s.get(0) != 10 )
						k = 2;
					else
						break;
				} else if( c == 13 ) {
					if( s.get(1) != 10 || s.get(0) != 13 )
						k = 1;
					else
						k = 3;
				} else
					k = 4;
			case 4:
				var c = s.get(3);
				if( c == 10 ) {
					if( s.get(2) != 13 )
						continue;
					else if( s.get(1) != 10 || s.get(0) != 13 )
						k = 2;
					else
						break;
				} else if( c == 13 ) {
					if( s.get(2) != 10 || s.get(1) != 13 )
						k = 3;
					else
						k = 1;
				}
			}
		}
		#if neko
			var headers = neko.Lib.stringReference(b.getBytes()).split("\r\n");
		#else
			var headers = b.getBytes().toString().split("\r\n");
		#end
		var response = headers.shift();
		var rp = response.split(" ");
		var status = Std.parseInt(rp[1]);
		if( status == 0 || status == null )
			throw "Response status error";

		// remove the two lasts \r\n\r\n
		headers.pop();
		headers.pop();
		responseHeaders = new haxe.ds.StringMap();
		var size = null;
		var chunked = false;
		for( hline in headers ) {
			var a = hline.split(": ");
			var hname = a.shift();
			var hval = if( a.length == 1 ) a[0] else a.join(": ");
			hval = StringTools.ltrim( StringTools.rtrim( hval ) );
			responseHeaders.set(hname, hval);
			switch(hname.toLowerCase())
			{
				case "content-length":
					size = Std.parseInt(hval);
				case "transfer-encoding":
					chunked = (hval.toLowerCase() == "chunked");
			}
		}

		onStatus(status);

		var chunk_re = ~/^([0-9A-Fa-f]+)[ ]*\r\n/m;
		chunk_size = null;
		chunk_buf = null;

		var bufsize = 1024;
		var buf = haxe.io.Bytes.alloc(bufsize);
		if( size == null ) {
			if( !noShutdown )
				sock.shutdown(false,true);
			try {
				while( true ) {
					var len = sock.input.readBytes(buf,0,bufsize);
					if( chunked ) {
						if( !readChunk(chunk_re,api,buf,len) )
							break;
					} else
						api.writeBytes(buf,0,len);
				}
			} catch( e : haxe.io.Eof ) {
			}
		} else {
			api.prepare(size);
			try {
				while( size > 0 ) {
					var len = sock.input.readBytes(buf,0,if( size > bufsize ) bufsize else size);
					if( chunked ) {
						if( !readChunk(chunk_re,api,buf,len) )
							break;
					} else
						api.writeBytes(buf,0,len);
					size -= len;
				}
			} catch( e : haxe.io.Eof ) {
				throw "Transfer aborted";
			}
		}
		if( chunked && (chunk_size != null || chunk_buf != null) )
			throw "Invalid chunk";
		if( status < 200 || status >= 400 )
			throw "Http Error #"+status;
		api.close();
	}

	function readChunk(chunk_re : EReg, api : haxe.io.Output, buf : haxe.io.Bytes, len ) {
		if( chunk_size == null ) {
			if( chunk_buf != null ) {
				var b = new haxe.io.BytesBuffer();
				b.add(chunk_buf);
				b.addBytes(buf,0,len);
				buf = b.getBytes();
				len += chunk_buf.length;
				chunk_buf = null;
			}
			#if neko
			if( chunk_re.match(neko.Lib.stringReference(buf)) ) {
			#else
			if( chunk_re.match(buf.toString()) ) {
			#end
				var p = chunk_re.matchedPos();
				if( p.len <= len ) {
					var cstr = chunk_re.matched(1);
					chunk_size = Std.parseInt("0x"+cstr);
					if( cstr == "0" ) {
						chunk_size = null;
						chunk_buf = null;
						return false;
					}
					len -= p.len;
					return readChunk(chunk_re,api,buf.sub(p.len,len),len);
				}
			}
			// prevent buffer accumulation
			if( len > 10 ) {
				onError("Invalid chunk");
				return false;
			}
			chunk_buf = buf.sub(0,len);
			return true;
		}
		if( chunk_size > len ) {
			chunk_size -= len;
			api.writeBytes(buf,0,len);
			return true;
		}
		var end = chunk_size + 2;
		if( len >= end ) {
			if( chunk_size > 0 )
				api.writeBytes(buf,0,chunk_size);
			len -= end;
			chunk_size = null;
			if( len == 0 )
				return true;
			return readChunk(chunk_re,api,buf.sub(end,len),len);
		}
		if( chunk_size > 0 )
			api.writeBytes(buf,0,chunk_size);
		chunk_size -= len;
		return true;
	}

#end

	/**
		This method is called upon a successful request, with `data` containing
		the result String.

		The intended usage is to bind it to a custom function:
		`httpInstance.onData = function(data) { // handle result }`
	**/
	public dynamic function onData( data : String ) {
	}

	/**
		This method is called upon a request error, with `msg` containing the
		error description.

		The intended usage is to bind it to a custom function:
		`httpInstance.onError = function(msg) { // handle error }`
	**/
	public dynamic function onError( msg : String ) {
	}

	/**
		This method is called upon a Http status change, with `status` being the
		new status.

		The intended usage is to bind it to a custom function:
		`httpInstance.onStatus = function(status) { // handle status }`
	**/
	public dynamic function onStatus( status : Int ) {
	}

	/**
		Makes a synchronous request to `url`.

		This creates a new Http instance and makes a GET request by calling its
		request(false) method.

		If `url` is null, the result is unspecified.
	**/
	public static function requestUrl( url : String ) : String {
		var h = new HttpRequest(url);
	#if js
		h.async = false;
	#end
		var r = null;
		h.onData = function(d){
			r = d;
		}
		h.onError = function(e){
			throw e;
		}
		#if js
			h.request('GET');
		#else
			h.request(false);
		#end
		return r;
	}

}

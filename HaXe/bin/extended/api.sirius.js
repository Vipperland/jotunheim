(function (console, $hx_exports) { "use strict";
$hx_exports.utils = $hx_exports.utils || {};
$hx_exports.sru = $hx_exports.sru || {};
$hx_exports.sru.utils = $hx_exports.sru.utils || {};
;$hx_exports.sru.bit = $hx_exports.sru.bit || {};
;$hx_exports.sru.seo = $hx_exports.sru.seo || {};
;$hx_exports.sru.tools = $hx_exports.sru.tools || {};
;$hx_exports.sru.events = $hx_exports.sru.events || {};
;$hx_exports.sru.dom = $hx_exports.sru.dom || {};
;$hx_exports.sru.css = $hx_exports.sru.css || {};
;$hx_exports.sru.modules = $hx_exports.sru.modules || {};
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var DateTools = function() { };
DateTools.__name__ = ["DateTools"];
DateTools.delta = function(d,t) {
	var t1 = d.getTime() + t;
	var d1 = new Date();
	d1.setTime(t1);
	return d1;
};
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = ["Lambda"];
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
};
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
};
var List = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,iterator: function() {
		return new _$List_ListIterator(this.h);
	}
	,__class__: List
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
_$List_ListIterator.__name__ = ["_List","ListIterator"];
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
	,__class__: _$List_ListIterator
};
Math.__name__ = ["Math"];
var Reflect = function() { };
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
};
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) return null; else if(o.__properties__ && (tmp = o.__properties__["get_" + field])) return o[tmp](); else return o[field];
};
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.deleteField = function(o,field) {
	if(!Object.prototype.hasOwnProperty.call(o,field)) return false;
	delete(o[field]);
	return true;
};
var Std = function() { };
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.random = function(x) {
	if(x <= 0) return 0; else return Math.floor(Math.random() * x);
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
};
var Type = function() { };
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null; else return js_Boot.getClass(o);
};
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
var _$UInt_UInt_$Impl_$ = {};
_$UInt_UInt_$Impl_$.__name__ = ["_UInt","UInt_Impl_"];
_$UInt_UInt_$Impl_$.gt = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	if(aNeg != bNeg) return aNeg; else return a > b;
};
_$UInt_UInt_$Impl_$.gte = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	if(aNeg != bNeg) return aNeg; else return a >= b;
};
_$UInt_UInt_$Impl_$.toFloat = function(this1) {
	var $int = this1;
	if($int < 0) return 4294967296.0 + $int; else return $int + 0.0;
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = ["haxe","IMap"];
var haxe_Http = function(url) {
	this.url = url;
	this.headers = new List();
	this.params = new List();
	this.async = true;
};
haxe_Http.__name__ = ["haxe","Http"];
haxe_Http.prototype = {
	setParameter: function(param,value) {
		this.params = Lambda.filter(this.params,function(p) {
			return p.param != param;
		});
		this.params.push({ param : param, value : value});
		return this;
	}
	,request: function(post) {
		var me = this;
		me.responseData = null;
		var r = this.req = js_Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s;
			try {
				s = r.status;
			} catch( e ) {
				if (e instanceof js__$Boot_HaxeError) e = e.val;
				s = null;
			}
			if(s != null) {
				var protocol = window.location.protocol.toLowerCase();
				var rlocalProtocol = new EReg("^(?:about|app|app-storage|.+-extension|file|res|widget):$","");
				var isLocal = rlocalProtocol.match(protocol);
				if(isLocal) if(r.responseText != null) s = 200; else s = 404;
			}
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) {
				me.req = null;
				me.onData(me.responseData = r.responseText);
			} else if(s == null) {
				me.req = null;
				me.onError("Failed to connect or resolve host");
			} else switch(s) {
			case 12029:
				me.req = null;
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.req = null;
				me.onError("Unknown host");
				break;
			default:
				me.req = null;
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var _g_head = this.params.h;
			var _g_val = null;
			while(_g_head != null) {
				var p;
				p = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				if(uri == null) uri = ""; else uri += "&";
				uri += encodeURIComponent(p.param) + "=" + encodeURIComponent(p.value);
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e1 ) {
			if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
			me.req = null;
			this.onError(e1.toString());
			return;
		}
		if(!Lambda.exists(this.headers,function(h) {
			return h.header == "Content-Type";
		}) && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var _g_head1 = this.headers.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var h1;
			h1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			r.setRequestHeader(h1.header,h1.value);
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe_Http
};
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = ["haxe","_Int64","___Int64"];
haxe__$Int64__$_$_$Int64.prototype = {
	__class__: haxe__$Int64__$_$_$Int64
};
var haxe_Log = function() { };
haxe_Log.__name__ = ["haxe","Log"];
haxe_Log.trace = function(v,infos) {
	js_Boot.__trace(v,infos);
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = ["haxe","Timer"];
haxe_Timer.delay = function(f,time_ms) {
	var t = new haxe_Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
haxe_io_Bytes.__name__ = ["haxe","io","Bytes"];
haxe_io_Bytes.alloc = function(length) {
	return new haxe_io_Bytes(new ArrayBuffer(length));
};
haxe_io_Bytes.ofString = function(s) {
	var a = [];
	var i = 0;
	while(i < s.length) {
		var c = StringTools.fastCodeAt(s,i++);
		if(55296 <= c && c <= 56319) c = c - 55232 << 10 | StringTools.fastCodeAt(s,i++) & 1023;
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.prototype = {
	get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,getString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c21 = b[i++];
				var c3 = b[i++];
				var u = (c & 15) << 18 | (c21 & 127) << 12 | (c3 & 127) << 6 | b[i++] & 127;
				s += fcc((u >> 10) + 55232);
				s += fcc(u & 1023 | 56320);
			}
		}
		return s;
	}
	,toString: function() {
		return this.getString(0,this.length);
	}
	,__class__: haxe_io_Bytes
};
var haxe_crypto_Base64 = function() { };
haxe_crypto_Base64.__name__ = ["haxe","crypto","Base64"];
haxe_crypto_Base64.encode = function(bytes,complement) {
	if(complement == null) complement = true;
	var str = new haxe_crypto_BaseCode(haxe_crypto_Base64.BYTES).encodeBytes(bytes).toString();
	if(complement) {
		var _g = bytes.length % 3;
		switch(_g) {
		case 1:
			str += "==";
			break;
		case 2:
			str += "=";
			break;
		default:
		}
	}
	return str;
};
haxe_crypto_Base64.decode = function(str,complement) {
	if(complement == null) complement = true;
	if(complement) while(HxOverrides.cca(str,str.length - 1) == 61) str = HxOverrides.substr(str,0,-1);
	return new haxe_crypto_BaseCode(haxe_crypto_Base64.BYTES).decodeBytes(haxe_io_Bytes.ofString(str));
};
var haxe_crypto_BaseCode = function(base) {
	var len = base.length;
	var nbits = 1;
	while(len > 1 << nbits) nbits++;
	if(nbits > 8 || len != 1 << nbits) throw new js__$Boot_HaxeError("BaseCode : base length must be a power of two.");
	this.base = base;
	this.nbits = nbits;
};
haxe_crypto_BaseCode.__name__ = ["haxe","crypto","BaseCode"];
haxe_crypto_BaseCode.prototype = {
	encodeBytes: function(b) {
		var nbits = this.nbits;
		var base = this.base;
		var size = b.length * 8 / nbits | 0;
		var out = haxe_io_Bytes.alloc(size + (b.length * 8 % nbits == 0?0:1));
		var buf = 0;
		var curbits = 0;
		var mask = (1 << nbits) - 1;
		var pin = 0;
		var pout = 0;
		while(pout < size) {
			while(curbits < nbits) {
				curbits += 8;
				buf <<= 8;
				buf |= b.get(pin++);
			}
			curbits -= nbits;
			out.set(pout++,base.b[buf >> curbits & mask]);
		}
		if(curbits > 0) out.set(pout++,base.b[buf << nbits - curbits & mask]);
		return out;
	}
	,initTable: function() {
		var tbl = [];
		var _g = 0;
		while(_g < 256) {
			var i = _g++;
			tbl[i] = -1;
		}
		var _g1 = 0;
		var _g2 = this.base.length;
		while(_g1 < _g2) {
			var i1 = _g1++;
			tbl[this.base.b[i1]] = i1;
		}
		this.tbl = tbl;
	}
	,decodeBytes: function(b) {
		var nbits = this.nbits;
		var base = this.base;
		if(this.tbl == null) this.initTable();
		var tbl = this.tbl;
		var size = b.length * nbits >> 3;
		var out = haxe_io_Bytes.alloc(size);
		var buf = 0;
		var curbits = 0;
		var pin = 0;
		var pout = 0;
		while(pout < size) {
			while(curbits < 8) {
				curbits += nbits;
				buf <<= nbits;
				var i = tbl[b.get(pin++)];
				if(i == -1) throw new js__$Boot_HaxeError("BaseCode : invalid encoded char");
				buf |= i;
			}
			curbits -= 8;
			out.set(pout++,buf >> curbits & 255);
		}
		return out;
	}
	,__class__: haxe_crypto_BaseCode
};
var haxe_ds_Either = { __ename__ : true, __constructs__ : ["Left","Right"] };
haxe_ds_Either.Left = function(v) { var $x = ["Left",0,v]; $x.__enum__ = haxe_ds_Either; $x.toString = $estr; return $x; };
haxe_ds_Either.Right = function(v) { var $x = ["Right",1,v]; $x.__enum__ = haxe_ds_Either; $x.toString = $estr; return $x; };
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = ["haxe","ds","StringMap"];
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,__class__: haxe_ds_StringMap
};
var haxe_io_Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe_io_Error.Blocked = ["Blocked",0];
haxe_io_Error.Blocked.toString = $estr;
haxe_io_Error.Blocked.__enum__ = haxe_io_Error;
haxe_io_Error.Overflow = ["Overflow",1];
haxe_io_Error.Overflow.toString = $estr;
haxe_io_Error.Overflow.__enum__ = haxe_io_Error;
haxe_io_Error.OutsideBounds = ["OutsideBounds",2];
haxe_io_Error.OutsideBounds.toString = $estr;
haxe_io_Error.OutsideBounds.__enum__ = haxe_io_Error;
haxe_io_Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe_io_Error; $x.toString = $estr; return $x; };
var haxe_io_FPHelper = function() { };
haxe_io_FPHelper.__name__ = ["haxe","io","FPHelper"];
haxe_io_FPHelper.i32ToFloat = function(i) {
	var sign = 1 - (i >>> 31 << 1);
	var exp = i >>> 23 & 255;
	var sig = i & 8388607;
	if(sig == 0 && exp == 0) return 0.0;
	return sign * (1 + Math.pow(2,-23) * sig) * Math.pow(2,exp - 127);
};
haxe_io_FPHelper.floatToI32 = function(f) {
	if(f == 0) return 0;
	var af;
	if(f < 0) af = -f; else af = f;
	var exp = Math.floor(Math.log(af) / 0.6931471805599453);
	if(exp < -127) exp = -127; else if(exp > 128) exp = 128;
	var sig = Math.round((af / Math.pow(2,exp) - 1) * 8388608) & 8388607;
	return (f < 0?-2147483648:0) | exp + 127 << 23 | sig;
};
haxe_io_FPHelper.i64ToDouble = function(low,high) {
	var sign = 1 - (high >>> 31 << 1);
	var exp = (high >> 20 & 2047) - 1023;
	var sig = (high & 1048575) * 4294967296. + (low >>> 31) * 2147483648. + (low & 2147483647);
	if(sig == 0 && exp == -1023) return 0.0;
	return sign * (1.0 + Math.pow(2,-52) * sig) * Math.pow(2,exp);
};
haxe_io_FPHelper.doubleToI64 = function(v) {
	var i64 = haxe_io_FPHelper.i64tmp;
	if(v == 0) {
		i64.low = 0;
		i64.high = 0;
	} else {
		var av;
		if(v < 0) av = -v; else av = v;
		var exp = Math.floor(Math.log(av) / 0.6931471805599453);
		var sig;
		var v1 = (av / Math.pow(2,exp) - 1) * 4503599627370496.;
		sig = Math.round(v1);
		var sig_l = sig | 0;
		var sig_h = sig / 4294967296.0 | 0;
		i64.low = sig_l;
		i64.high = (v < 0?-2147483648:0) | exp + 1023 << 20 | sig_h;
	}
	return i64;
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = ["js","_Boot","HaxeError"];
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = ["js","Boot"];
js_Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js_Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js_Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js_Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js_Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return (Function("return typeof " + name + " != \"undefined\" ? " + name + " : null"))();
};
var js_Browser = function() { };
js_Browser.__name__ = ["js","Browser"];
js_Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw new js__$Boot_HaxeError("Unable to create XMLHttpRequest object.");
};
var js_Cookie = function() { };
js_Cookie.__name__ = ["js","Cookie"];
js_Cookie.set = function(name,value,expireDelay,path,domain) {
	var s = name + "=" + encodeURIComponent(value);
	if(expireDelay != null) {
		var d = DateTools.delta(new Date(),expireDelay * 1000);
		s += ";expires=" + d.toGMTString();
	}
	if(path != null) s += ";path=" + path;
	if(domain != null) s += ";domain=" + domain;
	window.document.cookie = s;
};
js_Cookie.all = function() {
	var h = new haxe_ds_StringMap();
	var a = window.document.cookie.split(";");
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		e = StringTools.ltrim(e);
		var t = e.split("=");
		if(t.length < 2) continue;
		h.set(t[0],decodeURIComponent(t[1].split("+").join(" ")));
	}
	return h;
};
js_Cookie.get = function(name) {
	return js_Cookie.all().get(name);
};
js_Cookie.exists = function(name) {
	return js_Cookie.all().exists(name);
};
js_Cookie.remove = function(name,path,domain) {
	js_Cookie.set(name,"",-10,path,domain);
};
var js_html_compat_ArrayBuffer = function(a) {
	if((a instanceof Array) && a.__enum__ == null) {
		this.a = a;
		this.byteLength = a.length;
	} else {
		var len = a;
		this.a = [];
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			this.a[i] = 0;
		}
		this.byteLength = len;
	}
};
js_html_compat_ArrayBuffer.__name__ = ["js","html","compat","ArrayBuffer"];
js_html_compat_ArrayBuffer.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null?null:end - begin);
	var result = new ArrayBuffer(u.byteLength);
	var resultArray = new Uint8Array(result);
	resultArray.set(u);
	return result;
};
js_html_compat_ArrayBuffer.prototype = {
	slice: function(begin,end) {
		return new js_html_compat_ArrayBuffer(this.a.slice(begin,end));
	}
	,__class__: js_html_compat_ArrayBuffer
};
var js_html_compat_DataView = function(buffer,byteOffset,byteLength) {
	this.buf = buffer;
	if(byteOffset == null) this.offset = 0; else this.offset = byteOffset;
	if(byteLength == null) this.length = buffer.byteLength - this.offset; else this.length = byteLength;
	if(this.offset < 0 || this.length < 0 || this.offset + this.length > buffer.byteLength) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
};
js_html_compat_DataView.__name__ = ["js","html","compat","DataView"];
js_html_compat_DataView.prototype = {
	getInt8: function(byteOffset) {
		var v = this.buf.a[this.offset + byteOffset];
		if(v >= 128) return v - 256; else return v;
	}
	,getUint8: function(byteOffset) {
		return this.buf.a[this.offset + byteOffset];
	}
	,getInt16: function(byteOffset,littleEndian) {
		var v = this.getUint16(byteOffset,littleEndian);
		if(v >= 32768) return v - 65536; else return v;
	}
	,getUint16: function(byteOffset,littleEndian) {
		if(littleEndian) return this.buf.a[this.offset + byteOffset] | this.buf.a[this.offset + byteOffset + 1] << 8; else return this.buf.a[this.offset + byteOffset] << 8 | this.buf.a[this.offset + byteOffset + 1];
	}
	,getInt32: function(byteOffset,littleEndian) {
		var p = this.offset + byteOffset;
		var a = this.buf.a[p++];
		var b = this.buf.a[p++];
		var c = this.buf.a[p++];
		var d = this.buf.a[p++];
		if(littleEndian) return a | b << 8 | c << 16 | d << 24; else return d | c << 8 | b << 16 | a << 24;
	}
	,getUint32: function(byteOffset,littleEndian) {
		var v = this.getInt32(byteOffset,littleEndian);
		if(v < 0) return v + 4294967296.; else return v;
	}
	,getFloat32: function(byteOffset,littleEndian) {
		return haxe_io_FPHelper.i32ToFloat(this.getInt32(byteOffset,littleEndian));
	}
	,getFloat64: function(byteOffset,littleEndian) {
		var a = this.getInt32(byteOffset,littleEndian);
		var b = this.getInt32(byteOffset + 4,littleEndian);
		return haxe_io_FPHelper.i64ToDouble(littleEndian?a:b,littleEndian?b:a);
	}
	,setInt8: function(byteOffset,value) {
		if(value < 0) this.buf.a[byteOffset + this.offset] = value + 128 & 255; else this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setUint8: function(byteOffset,value) {
		this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setInt16: function(byteOffset,value,littleEndian) {
		this.setUint16(byteOffset,value < 0?value + 65536:value,littleEndian);
	}
	,setUint16: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
		} else {
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p] = value & 255;
		}
	}
	,setInt32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,value,littleEndian);
	}
	,setUint32: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p++] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >>> 24;
		} else {
			this.buf.a[p++] = value >>> 24;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value & 255;
		}
	}
	,setFloat32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,haxe_io_FPHelper.floatToI32(value),littleEndian);
	}
	,setFloat64: function(byteOffset,value,littleEndian) {
		var i64 = haxe_io_FPHelper.doubleToI64(value);
		if(littleEndian) {
			this.setUint32(byteOffset,i64.low);
			this.setUint32(byteOffset,i64.high);
		} else {
			this.setUint32(byteOffset,i64.high);
			this.setUint32(byteOffset,i64.low);
		}
	}
	,__class__: js_html_compat_DataView
};
var js_html_compat_Uint8Array = function() { };
js_html_compat_Uint8Array.__name__ = ["js","html","compat","Uint8Array"];
js_html_compat_Uint8Array._new = function(arg1,offset,length) {
	var arr;
	if(typeof(arg1) == "number") {
		arr = [];
		var _g = 0;
		while(_g < arg1) {
			var i = _g++;
			arr[i] = 0;
		}
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else if(js_Boot.__instanceof(arg1,js_html_compat_ArrayBuffer)) {
		var buffer = arg1;
		if(offset == null) offset = 0;
		if(length == null) length = buffer.byteLength - offset;
		if(offset == 0) arr = buffer.a; else arr = buffer.a.slice(offset,offset + length);
		arr.byteLength = arr.length;
		arr.byteOffset = offset;
		arr.buffer = buffer;
	} else if((arg1 instanceof Array) && arg1.__enum__ == null) {
		arr = arg1.slice();
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else throw new js__$Boot_HaxeError("TODO " + Std.string(arg1));
	arr.subarray = js_html_compat_Uint8Array._subarray;
	arr.set = js_html_compat_Uint8Array._set;
	return arr;
};
js_html_compat_Uint8Array._set = function(arg,offset) {
	var t = this;
	if(js_Boot.__instanceof(arg.buffer,js_html_compat_ArrayBuffer)) {
		var a = arg;
		if(arg.byteLength + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g1 = 0;
		var _g = arg.byteLength;
		while(_g1 < _g) {
			var i = _g1++;
			t[i + offset] = a[i];
		}
	} else if((arg instanceof Array) && arg.__enum__ == null) {
		var a1 = arg;
		if(a1.length + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g11 = 0;
		var _g2 = a1.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			t[i1 + offset] = a1[i1];
		}
	} else throw new js__$Boot_HaxeError("TODO");
};
js_html_compat_Uint8Array._subarray = function(start,end) {
	var t = this;
	var a = js_html_compat_Uint8Array._new(t.slice(start,end));
	a.byteOffset = start;
	return a;
};
var sirius_tools_IAgent = function() { };
sirius_tools_IAgent.__name__ = ["sirius","tools","IAgent"];
sirius_tools_IAgent.prototype = {
	__class__: sirius_tools_IAgent
};
var sirius_tools_Agent = function() {
};
sirius_tools_Agent.__name__ = ["sirius","tools","Agent"];
sirius_tools_Agent.__interfaces__ = [sirius_tools_IAgent];
sirius_tools_Agent.prototype = {
	update: function(handler) {
		var ua = window.navigator.userAgent;
		var ie;
		if(new EReg("MSIE","i").match(ua)) ie = 8; else ie = 0;
		if(new EReg("MSIE 9","i").match(ua)) ie = 9; else ie = ie;
		if(new EReg("MSIE 10","i").match(ua)) ie = 10; else ie = ie;
		if(new EReg("rv:11.","i").match(ua)) ie = 11; else ie = ie;
		if(new EReg("Edge","i").match(ua)) ie = 12; else ie = ie;
		var opera = new EReg("OPR","i").match(ua);
		var safari = new EReg("Safari","i").match(ua);
		var firefox = new EReg("Firefox","i").match(ua);
		var chrome = new EReg("Chrome","i").match(ua);
		var chromium = new EReg("Chromium","i").match(ua);
		if(ie < 12) this.ie = ie; else this.ie = 0;
		this.edge = ie >= 12;
		this.opera = opera;
		this.firefox = firefox;
		this.safari = safari && !chrome && !chromium;
		this.chrome = chrome && !chromium && !opera;
		this.mobile = new EReg("Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini","i").match(ua);
		if(sirius_tools_Utils.matchMedia(sirius_css_CSSGroup.MEDIA_XS)) {
			this.xs = true;
			this.screen = 1;
		} else if(sirius_tools_Utils.matchMedia(sirius_css_CSSGroup.MEDIA_SM)) {
			this.sm = true;
			this.screen = 2;
		} else if(sirius_tools_Utils.matchMedia(sirius_css_CSSGroup.MEDIA_MD)) {
			this.md = true;
			this.screen = 3;
		} else if(sirius_tools_Utils.matchMedia(sirius_css_CSSGroup.MEDIA_LG)) {
			this.lg = true;
			this.screen = 4;
		} else this.screen = 0;
		this.jQuery = Reflect.hasField(window,"$") || Reflect.hasField(window,"jQuery");
		this.animator = sirius_transitions_Animator.available();
		this.display = sirius_tools_Utils.screenOrientation();
		if(handler != null) handler(this);
		return this;
	}
	,__class__: sirius_tools_Agent
};
var sirius_net_IDomain = function() { };
sirius_net_IDomain.__name__ = ["sirius","net","IDomain"];
sirius_net_IDomain.prototype = {
	__class__: sirius_net_IDomain
};
var sirius_net_Domain = function() {
	this._parseURI();
};
sirius_net_Domain.__name__ = ["sirius","net","Domain"];
sirius_net_Domain.__interfaces__ = [sirius_net_IDomain];
sirius_net_Domain.prototype = {
	_parseURI: function() {
		var l = window.location;
		var p = l.pathname;
		this.host = l.hostname;
		this.port = l.port;
		this.hash = HxOverrides.substr(l.hash,1,null);
		this.fragments = sirius_tools_Utils.clearArray(p.split("/"));
		this.firstFragment = this.fragment(0,"");
		this.lastFragment = this.fragment(this.fragments.length - 1,this.firstFragment);
		if(this.lastFragment.indexOf(".") != -1) {
			this.file = this.lastFragment;
			this.fragments.pop();
			this.lastFragment = this.fragment(this.fragments.length - 1,this.firstFragment);
		}
	}
	,fragment: function(i,a) {
		if(i >= 0 && i < this.fragments.length) return this.fragments[i]; else return a;
	}
	,reload: function(force) {
		if(force == null) force = false;
		window.location.reload(force);
	}
	,__class__: sirius_net_Domain
};
var sirius_modules_ILoader = function() { };
sirius_modules_ILoader.__name__ = ["sirius","modules","ILoader"];
sirius_modules_ILoader.prototype = {
	__class__: sirius_modules_ILoader
};
var sirius_modules_Loader = $hx_exports.sru.modules.Loader = function(noCache) {
	if(noCache == null) noCache = false;
	this._toload = [];
	this._noCache = noCache;
	this._onComplete = [];
	this._onError = [];
	this.totalLoaded = 0;
	this.totalFiles = 0;
};
sirius_modules_Loader.__name__ = ["sirius","modules","Loader"];
sirius_modules_Loader.__interfaces__ = [sirius_modules_ILoader];
sirius_modules_Loader.prototype = {
	progress: function() {
		return this.totalLoaded / this.totalFiles;
	}
	,listen: function(complete,error) {
		if(error != null && Lambda.indexOf(this._onError,error) == -1) this._onError[this._onError.length] = error;
		if(complete != null && Lambda.indexOf(this._onComplete,complete) == -1) this._onComplete[this._onComplete.length] = complete;
		return this;
	}
	,add: function(files,complete,error) {
		this.listen(complete,error);
		if(files != null && files.length > 0) {
			this._toload = this._toload.concat(files);
			this.totalFiles += files.length;
		}
		return this;
	}
	,start: function(complete,error) {
		if(!this._isBusy) {
			this.listen(complete,error);
			this._isBusy = true;
			this._loadNext();
		}
		return this;
	}
	,_loadNext: function() {
		var _g = this;
		if(this._toload.length > 0) {
			var f = this._toload.shift();
			var r = new haxe_Http(f + (this._noCache?"":"?t=" + new Date().getTime()));
			r.async = true;
			r.onError = function(e) {
				++_g.totalLoaded;
				if($bind(_g,_g._error) != null) _g._error(e);
				_g._loadNext();
			};
			r.onData = function(d) {
				++_g.totalLoaded;
				sirius_Sirius.resources.register(f,d);
				_g._loadNext();
			};
			r.request(false);
		} else {
			this._isBusy = false;
			this._complete();
		}
	}
	,_error: function(e) {
		var _g = this;
		if(typeof(e) == "string") this.lastError = new sirius_errors_Error(-1,e,this); else this.lastError = new sirius_errors_Error(-1,"Unknow",{ content : e, loader : this});
		sirius_utils_Dice.Values(this._onError,function(v) {
			if(v != null) v(_g.lastError);
		});
	}
	,_complete: function() {
		var _g = this;
		sirius_utils_Dice.Values(this._onComplete,function(v) {
			if(v != null) v(_g);
		});
		this._onComplete = [];
		this._onError = [];
	}
	,build: function(module,data,each) {
		return sirius_Sirius.resources.build(module,data,each);
	}
	,async: function(file,target,data,handler) {
		var _g = this;
		var h;
		if(file.indexOf("#") != -1) h = file.split("#"); else h = [file];
		var r = new haxe_Http(h[0] + (this._noCache?"":"?t=" + new Date().getTime()));
		r.async = true;
		r.onData = function(d) {
			sirius_Sirius.resources.register(file,d);
			if(h.length == 2) file = h[1]; else file = file;
			if(target != null) {
				if(typeof(target) == "string") {
					var e = sirius_Sirius.one(target,null);
					if(e != null) {
						if(!((data instanceof Array) && data.__enum__ == null)) data = [data];
						e.addChild(_g.build(file,data));
					}
				} else try {
					_g.build(file,data,target);
				} catch( e1 ) {
					if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
					sirius_Sirius.log(e1,10,3);
				}
			}
			if(handler != null) handler(file,d);
		};
		r.request(false);
	}
	,request: function(url,data,handler,method) {
		if(method == null) method = "post";
		var r = new haxe_Http(url + (this._noCache?"":"?t=" + new Date().getTime()));
		r.async = true;
		if(data != null) sirius_utils_Dice.All(data,$bind(r,r.setParameter));
		r.onData = function(d) {
			if(handler != null) handler(new sirius_modules_Request(true,d,null));
		};
		r.onError = function(d1) {
			if(handler != null) handler(new sirius_modules_Request(false,null,new sirius_errors_Error(-1,d1)));
		};
		r.request(method != null && method.toLowerCase() == "post");
	}
	,get: function(module,data) {
		return sirius_Sirius.resources.get(module,data);
	}
	,__class__: sirius_modules_Loader
};
var sirius_modules_ModLib = $hx_exports.sru.modules.ModLib = function() {
};
sirius_modules_ModLib.__name__ = ["sirius","modules","ModLib"];
sirius_modules_ModLib.prototype = {
	exists: function(module) {
		return Object.prototype.hasOwnProperty.call(sirius_modules_ModLib.CACHE,module);
	}
	,register: function(file,content) {
		var _g = this;
		content = content.split("[module:{").join("[!MOD!]");
		content = content.split("[Module:{").join("[!MOD!]");
		var sur = content.split("[!MOD!]");
		if(sur.length > 1) sirius_utils_Dice.All(sur,function(p,v) {
			if(p > 0) {
				var i = v.indexOf("}]");
				if(i != -1) {
					var mod = JSON.parse("{" + HxOverrides.substr(v,0,i) + "}");
					if(mod.name == null) mod.name = file;
					sirius_Sirius.log("Sirius->ModLib.build[ " + mod.name + " ]",10,1);
					var end = v.indexOf(";;;");
					content = v.substring(i + 2,end == -1?v.length:end);
					if(mod.require != null) {
						var dependencies = mod.require.split(";");
						sirius_Sirius.log("\tSirius->ModLib::dependencies [ FOR " + mod.name + " ]",10,1);
						sirius_utils_Dice.Values(dependencies,function(v1) {
							var set = Reflect.field(sirius_modules_ModLib.CACHE,v1.toLowerCase());
							if(set == null) sirius_Sirius.log("\t\tSirius->ModLib::dependency[ MISSING " + v1 + " ]",10,2); else {
								sirius_Sirius.log("\t\tSirius->ModLib::dependency[ OK " + v1 + " ]",10,1);
								content = content.split("<import " + v1 + "/>").join(set);
							}
						});
					}
					if(mod.types != null) {
						var p1 = mod.types.split(" ").join("").split(";");
						if(sirius_utils_Dice.Match(p1,"css") > 0) {
							sirius_css_Automator.build(content);
							content = null;
						}
					}
					if(mod.target != null) {
						var t = sirius_Sirius.one(mod.target);
						if(t != null) t.addChild(_g.build(mod.name));
					}
					if(content != null) Reflect.setField(sirius_modules_ModLib.CACHE,mod.name.toLowerCase(),content);
				} else sirius_Sirius.log("\tSirius->ModLib::status [ MISSING MODULE END IN " + file + "(" + HxOverrides.substr(v,0,15) + "...) ]",10,3);
			}
		}); else Reflect.setField(sirius_modules_ModLib.CACHE,file.toLowerCase(),content);
	}
	,get: function(name,data) {
		name = name.toLowerCase();
		if(!this.exists(name)) return "<span style='color:#ff0000;font-weight:bold;'>Undefined [Module:" + name + "]</span><br/>";
		var content = Reflect.field(sirius_modules_ModLib.CACHE,name);
		if(data != null) return sirius_utils_Filler.to(content,data); else return content;
	}
	,fill: function(module,data,sufix) {
		return sirius_utils_Filler.to(this.get(module),data,sufix);
	}
	,build: function(module,data,each) {
		var _g = this;
		if(each != null && ((data instanceof Array) && data.__enum__ == null)) {
			var d = new sirius_dom_Div();
			sirius_utils_Dice.Values(data,function(v) {
				v = new sirius_dom_Display().build(_g.get(module,v));
				v = each(v);
				if(v != null && js_Boot.__instanceof(v,sirius_dom_IDisplay)) d.addChild(v);
			});
			return d;
		} else return new sirius_dom_Display().build(this.get(module,data));
	}
	,__class__: sirius_modules_ModLib
};
var sirius_seo_SEOTool = $hx_exports.SEO = function() {
	this._publish = [];
};
sirius_seo_SEOTool.__name__ = ["sirius","seo","SEOTool"];
sirius_seo_SEOTool.prototype = {
	_create: function(t,O) {
		if(Reflect.field(this,t) == null) {
			O = new O();
			this[t] = O;
			this._publish[this._publish.length] = O;
		}
	}
	,init: function(types) {
		if(types == null) types = 0;
		if(types == 0 || sirius_tools_BitIO.Test(types,sirius_seo_SEOTool.WEBSITE)) this._create("website",sirius_seo_WebSite);
		if(sirius_tools_BitIO.Test(types,sirius_seo_SEOTool.BREADCRUMBS)) this._create("breadcrumbs",sirius_seo_Breadcrumbs);
		if(sirius_tools_BitIO.Test(types,sirius_seo_SEOTool.PRODUCT)) this._create("product",sirius_seo_Product);
		if(sirius_tools_BitIO.Test(types,sirius_seo_SEOTool.ORGANIZATION)) this._create("organization",sirius_seo_Organization);
		if(sirius_tools_BitIO.Test(types,sirius_seo_SEOTool.PERSON)) this._create("person",sirius_seo_Person);
		if(sirius_tools_BitIO.Test(types,sirius_seo_SEOTool.SEARCH)) this._create("search",sirius_seo_Search);
		return this;
	}
	,publish: function() {
		sirius_utils_Dice.Values(this._publish,function(seo) {
			seo.publish();
		});
	}
	,__class__: sirius_seo_SEOTool
};
var sirius_Sirius = $hx_exports.Sirius = function() { };
sirius_Sirius.__name__ = ["sirius","Sirius"];
sirius_Sirius.main = function() {
	sirius_Sirius._preInit();
};
sirius_Sirius._loadController = function(e) {
	sirius_Sirius.agent.update();
	sirius_transitions_Ease.update();
	var plist = window.sru ? window.sru.plugins : null;
	sirius_utils_Dice.All(plist,function(p,v) {
		sirius_Sirius.plugins[p] = v;
		sirius_Sirius.log("Sirius->Plugins::status[ " + p + "() ADDED]",10,1);
	});
	sirius_Sirius.log("Sirius->Core::status[ INITIALIZED ] ",10,1);
	sirius_Sirius._loaded = true;
	sirius_utils_Dice.Values(sirius_Sirius._loadPool,function(v1) {
		if(sirius_tools_Utils.isValid(v1)) v1();
	});
	window.document.removeEventListener("DOMContentLoaded",sirius_Sirius._loadController);
	sirius_Sirius._loadPool = null;
	sirius_Sirius.loader.start(sirius_Sirius._onLoaded);
};
sirius_Sirius._onLoaded = function(e) {
	if(sirius_Sirius.loader.totalFiles > 0) sirius_Sirius.log("Sirius->Resources::status [ MODULES (" + sirius_Sirius.loader.totalLoaded + "/" + sirius_Sirius.loader.totalFiles + ") ]",10,1);
};
sirius_Sirius.one = function(q,t,h) {
	if(q == null) q = "*";
	t = (t == null?window.document:t).querySelector(q);
	if(t != null) {
		t = sirius_tools_Utils.displayFrom(t);
		if(h != null) h(t);
		return t;
	} else {
		sirius_Sirius.log("Sirius->Table::status[ EMPTY (" + q + ") ]",20,3);
		return null;
	}
};
sirius_Sirius.all = function(q,t) {
	if(q == null) q = "*";
	return new sirius_utils_Table(q,t);
};
sirius_Sirius.jQuery = function(q) {
	if(q == null) q = "*";
	return $(q);;
};
sirius_Sirius.run = function(handler) {
	if(!sirius_Sirius._initialized) sirius_Sirius._preInit();
	if(handler != null) {
		if(!sirius_Sirius._loaded && sirius_Sirius._loadPool != null) sirius_Sirius._loadPool[sirius_Sirius._loadPool.length] = handler; else handler();
	}
};
sirius_Sirius.onInit = function(handler,files) {
	if(!sirius_Sirius._initialized) sirius_Sirius._preInit();
	if(!sirius_Sirius._loaded && files != null && files.length > 0) sirius_Sirius.loader.add(files,null,sirius_Sirius._fileError); else sirius_Sirius.run(handler);
};
sirius_Sirius.addScript = function(url,handler) {
	if(!((url instanceof Array) && url.__enum__ == null)) url = [url];
	sirius_dom_Script.require(url,handler);
};
sirius_Sirius._preInit = function() {
	if(!sirius_Sirius._initialized) {
		sirius_Sirius._initialized = true;
		sirius_Sirius._loadPool = [];
		sirius_Sirius.document = new sirius_dom_Document();
		window.document.addEventListener("DOMContentLoaded",sirius_Sirius._loadController);
		sirius_Sirius.log("Sirius->Core.init[ Waiting for DOM Loading Event... ]",10,2);
		sirius_css_Automator._init();
		Reflect.deleteField(sirius_Sirius,"_preInit");
	}
};
sirius_Sirius.status = function() {
	sirius_Sirius.log("Sirius->Core::status[ " + (sirius_Sirius._initialized?"READY ":"") + sirius_tools_Utils.toString(sirius_Sirius.agent,true) + " ] ",10,1);
};
sirius_Sirius._fileError = function(e) {
	sirius_Sirius.log("Sirius->Resources::status[ " + e.message + " ]",10,3);
};
sirius_Sirius.module = function(file,target,content,handler) {
	sirius_Sirius.run(function() {
		sirius_Sirius.loader.async(file,target,content,handler);
	});
};
sirius_Sirius.request = function(url,data,handler,method) {
	if(method == null) method = "post";
	sirius_Sirius.run(function() {
		sirius_Sirius.loader.request(url,data,handler,method);
	});
};
sirius_Sirius.log = function(q,level,type) {
	if(type == null) type = -1;
	if(level == null) level = 10;
	if(_$UInt_UInt_$Impl_$.gte(sirius_Sirius._loglevel,level)) {
		var t;
		switch(type) {
		case -1:
			t = "";
			break;
		case 0:
			t = "[MESSAGE] ";
			break;
		case 1:
			t = "[>SYSTEM] ";
			break;
		case 2:
			t = "[WARNING] ";
			break;
		case 3:
			t = "[!ERROR!] ";
			break;
		case 4:
			t = "[//TODO:] ";
			break;
		default:
			t = "";
		}
		haxe_Log.trace(t + Std.string(q),{ fileName : "Sirius.hx", lineNumber : 256, className : "sirius.Sirius", methodName : "log"});
	}
};
sirius_Sirius.logLevel = function(q) {
	sirius_Sirius._loglevel = q;
};
var sirius_User = function() { };
sirius_User.__name__ = ["sirius","User"];
sirius_User.prototype = {
	__class__: sirius_User
};
var sirius_css_CSSGroup = $hx_exports.sru.css.CSSGroup = function() {
	this.reset();
	if(this.container == null) {
		this.container = new sirius_dom_Style();
		this.CM = sirius_css_CSSGroup._style("**");
		this.XS = sirius_css_CSSGroup._style("xs");
		this.SM = sirius_css_CSSGroup._style("sm");
		this.MD = sirius_css_CSSGroup._style("md");
		this.LG = sirius_css_CSSGroup._style("lg");
		this.PR = sirius_css_CSSGroup._style("pr");
		window.document.head.appendChild(this.container.element);
	}
};
sirius_css_CSSGroup.__name__ = ["sirius","css","CSSGroup"];
sirius_css_CSSGroup._style = function(media) {
	var e;
	var _this = window.document;
	e = _this.createElement("style");
	e.setAttribute("media-type",media);
	e.type = "text/css";
	e.innerHTML = "";
	return e;
};
sirius_css_CSSGroup.prototype = {
	_checkSelector: function(value,content,current) {
		var iof = content.indexOf(value);
		var r = false;
		if(iof != -1) {
			r = true;
			if(current != null) {
				var eof = content.indexOf("}",iof);
				content = content.substring(iof,eof);
				r = current == content;
			}
		}
		return r;
	}
	,hasSelector: function(id,content,mode) {
		var k;
		if(mode != null) k = mode; else k = HxOverrides.substr(id,-2,2);
		id = (HxOverrides.substr(id,0,1) == "."?"":".") + id + "{";
		if(k != null && k != "") {
			if(k == "xs") return this._checkSelector(id,this.XS.innerHTML + this.styleXS,content);
			if(k == "sm") return this._checkSelector(id,this.SM.innerHTML + this.styleSM,content);
			if(k == "md") return this._checkSelector(id,this.MD.innerHTML + this.styleMD,content);
			if(k == "lg") return this._checkSelector(id,this.LG.innerHTML + this.styleLG,content);
			if(k == "pr") return this._checkSelector(id,this.PR.innerHTML + this.stylePR,content);
		}
		return this._checkSelector(id,this.CM.innerHTML + this.style,content);
	}
	,getByMedia: function(mode) {
		if(mode != null) {
			mode = mode.toLowerCase();
			if(mode == "xs") return this.XS;
			if(mode == "sm") return this.SM;
			if(mode == "md") return this.MD;
			if(mode == "lg") return this.LG;
			if(mode == "pr") return this.PR;
		}
		return this.CM;
	}
	,setSelector: function(id,style,mode) {
		if(!this.hasSelector(id,style,mode)) {
			if(mode == "xs") this.styleXS += this._add(id,style); else if(mode == "sm") this.styleSM += this._add(id,style); else if(mode == "md") this.styleMD += this._add(id,style); else if(mode == "lg") this.styleLG += this._add(id,style); else if(mode == "pr") this.stylePR += this._add(id,style); else this.style += this._add(id,style);
		}
	}
	,distribute: function(id,style) {
		this.setSelector(id + "-xs",style,"xs");
		this.setSelector(id + "-sm",style,"sm");
		this.setSelector(id + "-md",style,"md");
		this.setSelector(id + "-lg",style,"lg");
		this.setSelector(id + "-pr",style,"pr");
		this.setSelector(id,style,null);
	}
	,_add: function(id,style) {
		return id + "{" + (style != null?style:"/*<NULL>*/") + "}";
	}
	,_write: function(e,v,h) {
		if(v.length > 0) {
			if(h != "") e.innerHTML = (e.innerHTML.length > 0?h + e.innerHTML.split(h).join("").split(sirius_css_CSSGroup.EOF).join("") + v:h + v) + sirius_css_CSSGroup.EOF; else e.innerHTML = e.innerHTML + v;
			if(e.parentElement == null) this.container.element.appendChild(e);
		}
	}
	,build: function() {
		this._write(this.CM,this.style,"");
		this._write(this.XS,this.styleXS,sirius_css_CSSGroup.SOF + sirius_css_CSSGroup.MEDIA_XS + "{");
		this._write(this.SM,this.styleSM,sirius_css_CSSGroup.SOF + sirius_css_CSSGroup.MEDIA_SM + "{");
		this._write(this.MD,this.styleMD,sirius_css_CSSGroup.SOF + sirius_css_CSSGroup.MEDIA_MD + "{");
		this._write(this.LG,this.styleLG,sirius_css_CSSGroup.SOF + sirius_css_CSSGroup.MEDIA_LG + "{");
		this._write(this.PR,this.stylePR,sirius_css_CSSGroup.SOF + sirius_css_CSSGroup.MEDIA_PR + "{");
		this.reset();
	}
	,reset: function() {
		this.style = this.styleXS = this.styleSM = this.styleMD = this.styleLG = this.stylePR = "";
	}
	,__class__: sirius_css_CSSGroup
};
var sirius_dom_IDisplay = function() { };
sirius_dom_IDisplay.__name__ = ["sirius","dom","IDisplay"];
sirius_dom_IDisplay.prototype = {
	__class__: sirius_dom_IDisplay
};
var sirius_data_IDataSet = function() { };
sirius_data_IDataSet.__name__ = ["sirius","data","IDataSet"];
sirius_data_IDataSet.prototype = {
	__class__: sirius_data_IDataSet
};
var sirius_data_DataSet = function(q) {
	if(q != null) this._content = q; else this._content = { };
};
sirius_data_DataSet.__name__ = ["sirius","data","DataSet"];
sirius_data_DataSet.__interfaces__ = [sirius_data_IDataSet];
sirius_data_DataSet.prototype = {
	get: function(p) {
		return Reflect.field(this._content,p);
	}
	,set: function(p,v) {
		this._content[p] = v;
		return this;
	}
	,exists: function(p) {
		return Object.prototype.hasOwnProperty.call(this._content,p);
	}
	,clear: function() {
		this._content = { };
		return this;
	}
	,find: function(v) {
		var r = [];
		sirius_utils_Dice.All(this._content,function(p,x) {
			if(x != null && x.indexOf(v) != -1) r[r.length] = p;
		});
		return r;
	}
	,index: function() {
		var r = [];
		sirius_utils_Dice.Params(this._content,$arrayPushClosure(r));
		return r;
	}
	,values: function() {
		var r = [];
		sirius_utils_Dice.Values(this._content,$arrayPushClosure(r));
		return r;
	}
	,filter: function(p,handler) {
		var r = new sirius_data_DataSet();
		var h = handler != null;
		sirius_utils_Dice.All(this._content,function(p2,v) {
			if(js_Boot.__instanceof(v,sirius_data_IDataSet)) {
				if(v.exists(p)) r.set(p2,h?handler(v):v.get(p));
			} else if(Object.prototype.hasOwnProperty.call(v,p)) r.set(p2,h?handler(v):Reflect.field(v,p));
		});
		return r;
	}
	,each: function(handler) {
		sirius_utils_Dice.All(this._content,handler);
	}
	,structure: function() {
		return this._content;
	}
	,__class__: sirius_data_DataSet
};
var sirius_dom_Display = $hx_exports.sru.dom.Display = function(q,t,d) {
	if(typeof(q) == "string") q = sirius_Sirius.one(q,t); else if(js_Boot.__instanceof(q,sirius_dom_IDisplay)) q = q.element;
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("div");
	}
	this.element = q;
	this.events = new sirius_events_Dispatcher(this);
	if(d != null) this.css(d);
	if(this.element != window.document) {
		if(this.hasAttribute("sru-id")) this._uid = this.attribute("sru-id"); else this._uid = this.attribute("sru-id",sirius_tools_Key.GEN());
		if(!sirius_dom_Display._DATA.exists(this._uid)) sirius_dom_Display._DATA.set(this._uid,new sirius_data_DisplayData());
		this.data = sirius_dom_Display._DATA.get(this._uid);
	}
};
sirius_dom_Display.__name__ = ["sirius","dom","Display"];
sirius_dom_Display.__interfaces__ = [sirius_dom_IDisplay];
sirius_dom_Display.ofKind = function(q) {
	return new sirius_dom_Display(window.document.createElement(q));
};
sirius_dom_Display.create = function(q) {
	return new sirius_dom_Display(q);
};
sirius_dom_Display.getPosition = function(target) {
	var a = sirius_Sirius.document.body.getBounds();
	var b = target.getBoundingClientRect();
	return new sirius_math_Point(b.left - a.left,b.top - a.top);
};
sirius_dom_Display.prototype = {
	exists: function(q) {
		return this.element != null && this.element.querySelector(q) != null;
	}
	,enable: function(q) {
		var d = this.events;
		sirius_utils_Dice.Values(q,function(v) {
			if(!((v instanceof Array) && v.__enum__ == null)) v = [v,false];
			var o = v[0];
			var c = v[1];
			new o(d, c);
		});
		return this;
	}
	,alignCenter: function() {
		this.css("marg-a vert-m /float-l /float-r txt-c");
	}
	,alignLeft: function() {
		this.css("/marg-a /vert-m float-l /float-r /txt-c");
	}
	,alignRight: function() {
		this.css("/marg-a /vert-m /float-l float-r /txt-c");
	}
	,background: function(data,repeat,position,attachment) {
		if(data != null) {
			var value = data;
			if(js_Boot.__instanceof(value,sirius_math_IARGB)) value = value.css();
			if(value.indexOf("#") == 0) this.element.style.background = value; else if(value.indexOf("rgb") == 0) this.element.style.backgroundColor = value; else {
				var c;
				if(value.indexOf("#") == 0) c = value; else c = "url('" + Std.string(value) + "')";
				var r;
				if(repeat != null && repeat.length > 0) r = repeat; else r = "no-repeat";
				var p;
				if(position != null && position.length > 0) p = position; else p = "center center";
				this.element.style.backgroundImage = c;
				this.element.style.backgroundRepeat = r;
				this.element.style.backgroundOrigin = p;
				if(attachment != null && attachment.length > 0) this.element.style.backgroundAttachment = attachment;
			}
		}
		return this.element.style.background;
	}
	,all: function(q) {
		return sirius_Sirius.all(q,this.element);
	}
	,one: function(q) {
		return sirius_Sirius.one(q,this.element);
	}
	,children: function() {
		if(this._children == null) this._children = sirius_Sirius.all("*",this.element);
		return this._children;
	}
	,getScroll: function(o) {
		if(o == null) o = { };
		o.scrollX = this.element.scrollLeft;
		o.scrollY = this.element.scrollTop;
		o.x = this.element.offsetLeft;
		o.y = this.element.offsetTop;
		o.viewX = o.x - window.scrollX;
		o.viewY = o.y - window.scrollY;
		return o;
	}
	,getChild: function(i,update) {
		if(this._children == null || update == true) this._children = this.children();
		return this._children.obj(i);
	}
	,length: function() {
		return this.element.children.length;
	}
	,index: function() {
		if(this._parent != null) return this._parent.indexOf(this); else return -1;
	}
	,indexOf: function(q) {
		var r = -1;
		sirius_utils_Dice.Children(this.element,function(c,i) {
			return c == q.element;
		},function(o) {
			if(o.completed) r = o.value; else r = -1;
		});
		return r;
	}
	,addChild: function(q,at) {
		if(at == null) at = -1;
		q.events.apply();
		q._parent = this;
		if(at != -1 && at < this.length()) {
			var sw = this.element.childNodes.item(at);
			this.element.insertBefore(q.element,sw);
		} else this.element.appendChild(q.element);
		this._children = null;
		return this;
	}
	,addChildren: function(q) {
		q.each($bind(this,this.addChild));
		this._children = null;
		return this;
	}
	,addText: function(q) {
		this.addChild(new sirius_dom_Text(q));
		return this;
	}
	,removeChild: function(q) {
		q.remove();
		return this;
	}
	,remove: function() {
		this._parent = null;
		if(this.element.parentElement != null) this.element.parentElement.removeChild(this.element);
		return this;
	}
	,css: function(styles) {
		if(styles != null) {
			var s = styles.split(" ");
			var cl = this.element.classList;
			sirius_utils_Dice.Values(s,function(v) {
				if(v != null && v.length > 0) {
					if(HxOverrides.substr(v,0,1) == "/") {
						v = HxOverrides.substr(v,1,v.length - 1);
						if(cl.contains(v)) cl.remove(v);
					} else if(!cl.contains(v)) cl.add(v);
				}
			});
		}
		return this.element.className;
	}
	,cursor: function(value) {
		if(value != null) this.element.style.cursor = value;
		return this.element.style.cursor;
	}
	,detach: function() {
		sirius_css_Automator.build("pos-abs");
		this.css("pos-abs /pos-rel /pos-fix");
	}
	,attach: function() {
		sirius_css_Automator.build("pos-rel");
		this.css("/pos-abs pos-rel /pos-fix");
	}
	,pin: function() {
		sirius_css_Automator.build("pos-fix");
		this.css("/pos-abs /pos-rel pos-fix");
	}
	,show: function() {
		this.element.hidden = false;
	}
	,hide: function() {
		this.element.hidden = true;
	}
	,hasAttribute: function(name) {
		return ($_=this.element,$bind($_,$_.hasAttribute)) != null && this.element.hasAttribute(name) || Reflect.getProperty(this.element,name) != null;
	}
	,attribute: function(name,value) {
		if(name != null) {
			if(value != null) {
				if(($_=this.element,$bind($_,$_.setAttribute)) != null) this.element.setAttribute(name,value); else Reflect.setProperty(this.element,name,value);
			}
			if(($_=this.element,$bind($_,$_.getAttribute)) != null) return this.element.getAttribute(name); else Reflect.getProperty(this.element,name);
		}
		return null;
	}
	,attributes: function(values) {
		sirius_utils_Dice.All(values,$bind(this,this.attribute));
		return this;
	}
	,build: function(q,plainText) {
		if(plainText == null) plainText = false;
		if(plainText) this.element.innerText = q; else this.element.innerHTML = q;
		return this;
	}
	,style: function(p,v) {
		var _g = this;
		if(p != null) {
			if(typeof(p) == "string") {
				if(v != null) Reflect.setField(this.element.style,p,js_Boot.__instanceof(v,sirius_math_IARGB)?v.css():Std.string(v));
				v = Reflect.field(this.trueStyle(),p);
				if(p.toLowerCase().indexOf("color") > 0) v = new sirius_math_ARGB(v);
				return v;
			} else sirius_utils_Dice.All(p,function(p1,v1) {
				Reflect.setField(_g.element.style,p1,js_Boot.__instanceof(v1,sirius_math_IARGB)?v1.css():Std.string(v1));
			});
		}
		return this.trueStyle();
	}
	,trueStyle: function() {
		if(this.element.ownerDocument.defaultView.opener) return this.element.ownerDocument.defaultView.getComputedStyle(this.element); else return window.getComputedStyle(this.element);
	}
	,write: function(q) {
		var _g = this;
		var i = new sirius_dom_Display().build(q,false);
		i.children().each(function(v) {
			_g.addChild(v);
		});
		return this;
	}
	,clear: function(fast) {
		if(fast) this.element.innerHTML = ""; else {
			var i = this.element.children.length;
			while(i-- > 0) this.element.removeChild(this.element.childNodes.item(i));
		}
		return this;
	}
	,on: function(type,handler,mode) {
		this.events.auto(type,handler,mode);
		return this;
	}
	,fadeTo: function(value,time) {
		if(time == null) time = 1;
		this.tweenTo(time,{ opacity : value});
		return this;
	}
	,tweenTo: function(time,target,ease,complete) {
		if(time == null) time = 1;
		if(complete != null) target.onComplete = complete;
		if(ease != null) target.ease = ease;
		if(this.element != null) {
			sirius_transitions_Animator.stop(this.element);
			sirius_transitions_Animator.to(this.element,time,target);
		}
		return this;
	}
	,tweenFrom: function(time,target,ease,complete) {
		if(time == null) time = 1;
		if(complete != null) target.onComplete = complete;
		if(ease != null) target.ease = ease;
		if(this.element != null) {
			sirius_transitions_Animator.stop(this.element);
			sirius_transitions_Animator.from(this.element,time,target);
		}
		return this;
	}
	,tweenFromTo: function(time,from,to,ease,complete) {
		if(time == null) time = 1;
		if(complete != null) from.onComplete = complete;
		if(ease != null) from.ease = ease;
		if(this.element != null) {
			sirius_transitions_Animator.stop(this.element);
			sirius_transitions_Animator.fromTo(this.element,time,from,to);
		}
		return this;
	}
	,parent: function(levels) {
		if(levels == null) levels = 0;
		if(this.element.parentElement != null && this._parent == null) this._parent = sirius_tools_Utils.displayFrom(this.element.parentElement);
		if(_$UInt_UInt_$Impl_$.gt(levels,0) && this._parent != null) return this._parent.parent(--levels); else return this._parent;
	}
	,activate: function(handler) {
		sirius_tools_Ticker.add(handler);
		return this;
	}
	,deactivate: function(handler) {
		sirius_tools_Ticker.remove(handler);
		return this;
	}
	,width: function(value,pct) {
		if(value != null) this.element.style.width = value + (pct?"%":"px");
		return this.element.clientWidth;
	}
	,height: function(value,pct) {
		if(value != null) this.element.style.height = value + (pct?"%":"px");
		return this.element.clientHeight;
	}
	,fit: function(width,height,pct) {
		this.width(width,pct);
		this.height(height,pct);
		return this;
	}
	,overflow: function(mode) {
		if(mode != null) this.element.style.overflow = mode;
		return this.element.style.overflow;
	}
	,isFullyVisible: function() {
		return this._visibility == 2;
	}
	,isVisible: function() {
		return this._visibility > 0;
	}
	,checkVisibility: function(view,offsetY,offsetX) {
		if(offsetX == null) offsetX = 0;
		if(offsetY == null) offsetY = 0;
		var rect = this.element.getBoundingClientRect();
		var current = 0;
		if(rect.top + offsetY >= 0 && rect.left + offsetX >= 0 && rect.bottom - offsetY <= sirius_tools_Utils.viewportHeight() && rect.right - offsetX <= sirius_tools_Utils.viewportWidth()) current = 2; else if(rect.bottom >= 0 && rect.right >= 0 && rect.top <= sirius_tools_Utils.viewportHeight() && rect.left <= sirius_tools_Utils.viewportWidth()) current = 1;
		if(current != this._visibility) {
			this._visibility = current;
			this.events.visibility().call();
		}
		return this._visibility;
	}
	,getBounds: function() {
		return this.element.getBoundingClientRect();
	}
	,jQuery: function() {
		return sirius_Sirius.jQuery(this.element);
	}
	,typeOf: function() {
		return "[" + sirius_tools_Utils.getClassName(this) + "{element:" + this.element.tagName + ", length:" + this.length() + "}]";
	}
	,'is': function(tag) {
		var _g = this;
		var name = sirius_tools_Utils.getClassName(this).toLowerCase();
		var pre = name.split(".").pop();
		if(typeof(tag) == "string") tag = [tag];
		var r = sirius_utils_Dice.Values(tag,function(v) {
			v = v.toLowerCase();
			var c;
			if(v.indexOf(".") == -1) c = pre; else c = name;
			return v == c || v == _g.element.tagName;
		});
		return !r.completed;
	}
	,addTo: function(target) {
		if(target != null) target.addChild(this); else if(sirius_Sirius.document != null) sirius_Sirius.document.body.addChild(this);
		return this;
	}
	,addToBody: function() {
		if(sirius_Sirius.document != null) sirius_Sirius.document.body.addChild(this);
		return this;
	}
	,goFullSize: function() {
		this.style({ width : sirius_tools_Utils.viewportWidth() + "px", height : sirius_tools_Utils.viewportHeight() + "px"});
	}
	,position: function() {
		return sirius_dom_Display.getPosition(this.element);
	}
	,__class__: sirius_dom_Display
};
var sirius_dom_Style = $hx_exports.sru.dom.Style = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("style");
	}
	sirius_dom_Display.call(this,q,null,d);
	this.object = this.element;
	this.object.type = "text/css";
};
sirius_dom_Style.__name__ = ["sirius","dom","Style"];
sirius_dom_Style.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Style.__super__ = sirius_dom_Display;
sirius_dom_Style.prototype = $extend(sirius_dom_Display.prototype,{
	publish: function() {
		window.document.head.appendChild(this.element);
	}
	,__class__: sirius_dom_Style
});
var sirius_dom_A = $hx_exports.sru.dom.A = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("a");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_A.__name__ = ["sirius","dom","A"];
sirius_dom_A.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_A.__super__ = sirius_dom_Display;
sirius_dom_A.prototype = $extend(sirius_dom_Display.prototype,{
	href: function(url) {
		return this.attribute("href",url);
	}
	,__class__: sirius_dom_A
});
var sirius_dom_Applet = $hx_exports.sru.dom.Applet = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("applet");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Applet.__name__ = ["sirius","dom","Applet"];
sirius_dom_Applet.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Applet.__super__ = sirius_dom_Display;
sirius_dom_Applet.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Applet
});
var sirius_dom_Area = $hx_exports.sru.dom.Area = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("area");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Area.__name__ = ["sirius","dom","Area"];
sirius_dom_Area.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Area.__super__ = sirius_dom_Display;
sirius_dom_Area.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Area
});
var sirius_dom_Audio = $hx_exports.sru.dom.Audio = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("audio");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Audio.__name__ = ["sirius","dom","Audio"];
sirius_dom_Audio.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Audio.__super__ = sirius_dom_Display;
sirius_dom_Audio.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Audio
});
var sirius_dom_B = $hx_exports.sru.dom.B = function(q,d) {
	if(q == null) q = window.document.createElement("B");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_B.__name__ = ["sirius","dom","B"];
sirius_dom_B.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_B.__super__ = sirius_dom_Display;
sirius_dom_B.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_B
});
var sirius_dom_Base = $hx_exports.sru.dom.Base = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("base");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Base.__name__ = ["sirius","dom","Base"];
sirius_dom_Base.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Base.__super__ = sirius_dom_Display;
sirius_dom_Base.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Base
});
var sirius_dom_Body = $hx_exports.sru.dom.Body = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("body");
	}
	sirius_dom_Display.call(this,q,null,d);
	this._body = this.element;
	window.addEventListener("resize",$bind(this,this._wResize));
};
sirius_dom_Body.__name__ = ["sirius","dom","Body"];
sirius_dom_Body.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Body.__super__ = sirius_dom_Display;
sirius_dom_Body.prototype = $extend(sirius_dom_Display.prototype,{
	_wResize: function(e) {
		this.events.resize().call();
	}
	,enlarge: function(scroll) {
		if(scroll == null) scroll = "over-hid";
		this.css("w-100pc h-100pc" + (scroll != null?" " + scroll:"") + " padd-0 marg-0 pos-abs");
		return this;
	}
	,maxScrollX: function() {
		return this._body.scrollWidth - sirius_tools_Utils.viewportWidth();
	}
	,maxScrollY: function() {
		return this._body.scrollHeight - sirius_tools_Utils.viewportHeight();
	}
	,__class__: sirius_dom_Body
});
var sirius_dom_BR = $hx_exports.sru.dom.BR = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("br");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_BR.__name__ = ["sirius","dom","BR"];
sirius_dom_BR.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_BR.__super__ = sirius_dom_Display;
sirius_dom_BR.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_BR
});
var sirius_dom_Div = $hx_exports.sru.dom.Div = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("div");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Div.__name__ = ["sirius","dom","Div"];
sirius_dom_Div.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Div.__super__ = sirius_dom_Display;
sirius_dom_Div.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Div
});
var sirius_dom_Button = function(q,d) {
	sirius_dom_Div.call(this,q,d);
	this.cursor("pointer");
};
sirius_dom_Button.__name__ = ["sirius","dom","Button"];
sirius_dom_Button.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Button.__super__ = sirius_dom_Div;
sirius_dom_Button.prototype = $extend(sirius_dom_Div.prototype,{
	__class__: sirius_dom_Button
});
var sirius_dom_Canvas = $hx_exports.sru.dom.Canvas = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("canvas");
	}
	sirius_dom_Display.call(this,q,null,d);
	this.paper = this.element;
};
sirius_dom_Canvas.__name__ = ["sirius","dom","Canvas"];
sirius_dom_Canvas.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Canvas.__super__ = sirius_dom_Display;
sirius_dom_Canvas.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Canvas
});
var sirius_dom_Caption = $hx_exports.sru.dom.Caption = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("caption");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Caption.__name__ = ["sirius","dom","Caption"];
sirius_dom_Caption.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Caption.__super__ = sirius_dom_Display;
sirius_dom_Caption.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Caption
});
var sirius_dom_Col = $hx_exports.sru.dom.Col = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("col");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Col.__name__ = ["sirius","dom","Col"];
sirius_dom_Col.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Col.__super__ = sirius_dom_Display;
sirius_dom_Col.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Col
});
var sirius_dom_Content = $hx_exports.sru.dom.Content = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("content");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Content.__name__ = ["sirius","dom","Content"];
sirius_dom_Content.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Content.__super__ = sirius_dom_Display;
sirius_dom_Content.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Content
});
var sirius_dom_DataList = $hx_exports.sru.dom.DataList = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("datalist");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_DataList.__name__ = ["sirius","dom","DataList"];
sirius_dom_DataList.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_DataList.__super__ = sirius_dom_Display;
sirius_dom_DataList.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_DataList
});
var sirius_dom_Dir = $hx_exports.sru.dom.Dir = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("dir");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Dir.__name__ = ["sirius","dom","Dir"];
sirius_dom_Dir.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Dir.__super__ = sirius_dom_Display;
sirius_dom_Dir.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Dir
});
var sirius_dom_IDisplay3D = function() { };
sirius_dom_IDisplay3D.__name__ = ["sirius","dom","IDisplay3D"];
sirius_dom_IDisplay3D.__interfaces__ = [sirius_dom_IDisplay];
sirius_dom_IDisplay3D.prototype = {
	__class__: sirius_dom_IDisplay3D
};
var sirius_dom_Display3D = $hx_exports.sru.dom.Display3D = function(q,d) {
	sirius_dom_Div.call(this,q,d);
	this.rotation = new sirius_math_Point3D(0,0,0);
	this.location = new sirius_math_Point3D(0,0,0);
	this.scale = new sirius_math_Point3D(1,1,1);
	this.xcss = new sirius_css_XCSS();
	this.backFace = "visible";
	this.preserve3d().update();
};
sirius_dom_Display3D.__name__ = ["sirius","dom","Display3D"];
sirius_dom_Display3D.__interfaces__ = [sirius_dom_IDisplay3D];
sirius_dom_Display3D.__super__ = sirius_dom_Div;
sirius_dom_Display3D.prototype = $extend(sirius_dom_Div.prototype,{
	preserve3d: function() {
		this.transformStyle = "preserve-3d";
		return this;
	}
	,setPerspective: function(value,origin) {
		if(value != null) this.perspective = value;
		if(origin != null) this.transformOrigin = origin;
		return this;
	}
	,rotateAll: function(x,y,z,add) {
		this.rotationX(x,add);
		this.rotationY(y,add);
		if(z != null) this.rotationZ(z,add);
		return this;
	}
	,rotationX: function(value,add) {
		if(value != null) {
			if(add) this.rotation.x += value; else this.rotation.x = value;
			if(this.rotation.x < -180) this.rotation.x += 360; else if(this.rotation.x > 180) this.rotation.x -= 360;
		}
		return this.rotation.x;
	}
	,rotationY: function(value,add) {
		if(value != null) {
			if(add) this.rotation.y += value; else this.rotation.y = value;
			if(this.rotation.y < -180) this.rotation.y += 360; else if(this.rotation.y > 180) this.rotation.y -= 360;
		}
		return this.rotation.y;
	}
	,rotationZ: function(value,add) {
		if(value != null) {
			if(add) this.rotation.z += value; else this.rotation.z = value;
			if(this.rotation.z < -180) this.rotation.z += 360; else if(this.rotation.z > 180) this.rotation.z -= 360;
		}
		return this.rotation.z;
	}
	,moveTo: function(x,y,z,add) {
		this.locationX(x,add);
		this.locationY(y,add);
		if(z != null) this.locationZ(z,add);
		return this;
	}
	,locationX: function(value,add) {
		if(value != null) {
			if(add) this.location.x += value; else this.location.x = value;
		}
		return this.location.x;
	}
	,locationY: function(value,add) {
		if(value != null) {
			if(add) this.location.y += value; else this.location.y = value;
		}
		return this.location.y;
	}
	,locationZ: function(value,add) {
		if(value != null) {
			if(add) this.location.z += value; else this.location.z = value;
		}
		return this.location.z;
	}
	,scaleAll: function(x,y,z,add) {
		this.scaleX(x,add);
		this.scaleY(y,add);
		if(z != null) this.scaleZ(z,add);
		return this;
	}
	,transform: function(x,y,x1,y1,w,h) {
		return this.moveTo(x,y,null).rotateAll(x1,y1,null).scaleAll(w,h,null);
	}
	,transform3D: function(x,y,z,x1,y1,z1,w,h,d) {
		return this.moveTo(x,y,z).rotateAll(x1,y1,z1).scaleAll(w,h,d);
	}
	,scaleX: function(value,add) {
		if(value != null) {
			if(add) this.scale.x += value; else this.scale.x = value;
		}
		return this.scale.x;
	}
	,scaleY: function(value,add) {
		if(value != null) {
			if(add) this.scale.y += value; else this.scale.y = value;
		}
		return this.scale.y;
	}
	,scaleZ: function(value,add) {
		if(value != null) {
			if(add) this.scale.z += value; else this.scale.z = value;
		}
		return this.scale.z;
	}
	,update: function() {
		if(this.perspective != null) this.xcss.write("perspective",this.perspective);
		if(this.transformOrigin != null) this.xcss.write("transformOrigin",this.transformOrigin);
		if(this.transformStyle != null) this.xcss.write("transformStyle",this.transformStyle);
		if(this.backFace != null) this.xcss.write("backfaceVisibility",this.backFace);
		this.xcss.write("transform","rotateX(" + this.rotation.x + "deg) rotateY(" + this.rotation.y + "deg) rotateZ(" + this.rotation.z + "deg) translate3d(" + this.location.x + "px," + this.location.y + "px," + this.location.z + "px) scale3d(" + this.scale.x + "," + this.scale.y + "," + this.scale.z + ")");
		this.xcss.apply(this);
		return this;
	}
	,doubleSided: function(value) {
		if(value) this.backFace = "visible"; else this.backFace = "hidden";
		return this;
	}
	,flipHorizontal: function() {
		this.rotationY(180,true);
		return this;
	}
	,flipVertical: function() {
		this.rotationX(180,true);
		return this;
	}
	,__class__: sirius_dom_Display3D
});
var sirius_dom_DL = $hx_exports.sru.dom.DL = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("dl");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_DL.__name__ = ["sirius","dom","DL"];
sirius_dom_DL.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_DL.__super__ = sirius_dom_Display;
sirius_dom_DL.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_DL
});
var sirius_dom_Document = $hx_exports.sru.dom.Document = function() {
	sirius_dom_Display.call(this,window.document);
	this.element = window.document.documentElement;
	this.events.wheel($bind(this,this.stopScroll),true);
	this.body = new sirius_dom_Body(window.document.body);
	this.head = new sirius_dom_Head(window.document.head);
};
sirius_dom_Document.__name__ = ["sirius","dom","Document"];
sirius_dom_Document._applyScroll = function() {
	window.scroll(sirius_dom_Document.__scroll__.x,sirius_dom_Document.__scroll__.y);
};
sirius_dom_Document.__super__ = sirius_dom_Display;
sirius_dom_Document.prototype = $extend(sirius_dom_Display.prototype,{
	scroll: function(x,y) {
		window.scroll(x,y);
	}
	,addScroll: function(x,y) {
		var current = this.getScroll();
		window.scroll(current.x + x,current.y + y);
	}
	,getScrollRange: function(o,pct) {
		if(pct == null) pct = false;
		var current = this.getScroll(o);
		if(this.body != null) {
			current.x /= this.body.maxScrollX();
			current.y /= this.body.maxScrollY();
			if(pct) {
				current.x *= 100;
				current.y *= 100;
			}
		} else current.reset();
		return current;
	}
	,getScroll: function(o) {
		if(o == null) o = new sirius_math_Point(0,0);
		if(window.pageXOffset != null) {
			o.x = window.pageXOffset;
			o.y = window.pageYOffset;
		} else if(this.body != null) {
			o.x = this.body.element.scrollLeft;
			o.y = this.body.element.scrollTop;
		} else {
			o.x = this.element.scrollLeft;
			o.y = this.element.scrollTop;
		}
		return o;
	}
	,easeScroll: function(x,y,time,ease) {
		if(time == null) time = 1;
		this.stopScroll();
		this.getScroll(sirius_dom_Document.__scroll__);
		sirius_transitions_Animator.to(sirius_dom_Document.__scroll__,time,{ x : x, y : y, ease : ease, onUpdate : sirius_dom_Document._applyScroll});
	}
	,stopScroll: function(e) {
		sirius_transitions_Animator.stop(sirius_dom_Document.__scroll__);
	}
	,scrollTo: function(target,time,ease,offX,offY) {
		if(offY == null) offY = 0;
		if(offX == null) offX = 0;
		if(time == null) time = 1;
		if(typeof(target) == "string") target = sirius_Sirius.one(target).element;
		if(js_Boot.__instanceof(target,sirius_dom_IDisplay)) target = target.element;
		var pos = sirius_dom_Display.getPosition(target);
		if(sirius_transitions_Animator.available()) this.easeScroll(pos.x - offX,pos.y - offY,time,ease); else this.scroll(pos.x - offX,pos.y - offY);
	}
	,trackCursor: function() {
		if(sirius_dom_Document.__cursor__.enabled) return;
		sirius_dom_Document.__cursor__.enabled = true;
		this.events.mouseMove(function(e) {
			var me = e.event;
			sirius_dom_Document.__cursor__.x = me.clientX;
			sirius_dom_Document.__cursor__.y = me.clientY;
		},true);
	}
	,cursorX: function() {
		return sirius_dom_Document.__cursor__.x;
	}
	,cursorY: function() {
		return sirius_dom_Document.__cursor__.y;
	}
	,focus: function(target) {
		if(target != null) target.element.focus();
		return sirius_tools_Utils.displayFrom(window.document.activeElement);
	}
	,print: function(selector,exclude) {
		if(exclude == null) exclude = "button, img, .no-print";
		var i = this.body.children();
		var success = false;
		if(i.length() > 0) {
			i.hide();
			var content = "";
			i.each(function(d) {
				if(!d["is"](["script","style"])) {
					content += d.element.outerHTML;
					d.hide();
				}
			});
			if(content.length > 0) {
				var r = new sirius_dom_Div();
				r.build(content);
				r.all(exclude).remove();
				this.body.addChild(r);
				try {
					window.print();
					success = true;
				} catch( e ) {
					if (e instanceof js__$Boot_HaxeError) e = e.val;
					if( js_Boot.__instanceof(e,Error) ) {
						success = false;
					} else throw(e);
				}
				this.body.removeChild(r);
			}
			i.show();
		}
		return success;
	}
	,__class__: sirius_dom_Document
});
var sirius_dom_Embed = $hx_exports.sru.dom.Embed = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("embed");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Embed.__name__ = ["sirius","dom","Embed"];
sirius_dom_Embed.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Embed.__super__ = sirius_dom_Display;
sirius_dom_Embed.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Embed
});
var sirius_dom_FieldSet = $hx_exports.sru.dom.FieldSet = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("fieldset");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_FieldSet.__name__ = ["sirius","dom","FieldSet"];
sirius_dom_FieldSet.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_FieldSet.__super__ = sirius_dom_Display;
sirius_dom_FieldSet.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_FieldSet
});
var sirius_dom_Font = $hx_exports.sru.dom.Font = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("font");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Font.__name__ = ["sirius","dom","Font"];
sirius_dom_Font.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Font.__super__ = sirius_dom_Display;
sirius_dom_Font.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Font
});
var sirius_dom_Form = $hx_exports.sru.dom.Form = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("form");
	}
	sirius_dom_Display.call(this,q,null,d);
	this.object = this.element;
};
sirius_dom_Form.__name__ = ["sirius","dom","Form"];
sirius_dom_Form.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Form.__super__ = sirius_dom_Display;
sirius_dom_Form.prototype = $extend(sirius_dom_Display.prototype,{
	validate: function() {
		this.checkSubmit().object.click();
		return this.object.checkValidity();
	}
	,checkSubmit: function() {
		if(this._submit == null) {
			var i;
			if(!this.exists("input[type=submit]")) {
				i = new sirius_dom_Input();
				i.type("submit");
				i.hide();
				this.addChild(i);
			} else i = this.one("input[type=submit]");
			this._submit = i;
		}
		return this._submit;
	}
	,submit: function() {
		this.object.submit();
	}
	,formData: function() {
		if(this.inputData == null) this.inputData = new sirius_data_FormData(this); else this.inputData.scan(this);
		return this.inputData;
	}
	,getAsInput: function(i,update) {
		if(this._children == null || update == true) this._children = this.children();
		return this._children.obj(i);
	}
	,__class__: sirius_dom_Form
});
var sirius_dom_Frame = $hx_exports.sru.dom.Frame = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("frame");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Frame.__name__ = ["sirius","dom","Frame"];
sirius_dom_Frame.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Frame.__super__ = sirius_dom_Display;
sirius_dom_Frame.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Frame
});
var sirius_dom_FrameSet = $hx_exports.sru.dom.FrameSet = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("frameset");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_FrameSet.__name__ = ["sirius","dom","FrameSet"];
sirius_dom_FrameSet.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_FrameSet.__super__ = sirius_dom_Display;
sirius_dom_FrameSet.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_FrameSet
});
var sirius_dom_H1 = $hx_exports.sru.dom.H1 = function(q,d) {
	if(q == null) q = window.document.createElement("h1");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_H1.__name__ = ["sirius","dom","H1"];
sirius_dom_H1.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_H1.__super__ = sirius_dom_Display;
sirius_dom_H1.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_H1
});
var sirius_dom_H2 = $hx_exports.sru.dom.H2 = function(q,d) {
	if(q == null) q = window.document.createElement("h2");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_H2.__name__ = ["sirius","dom","H2"];
sirius_dom_H2.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_H2.__super__ = sirius_dom_Display;
sirius_dom_H2.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_H2
});
var sirius_dom_H3 = $hx_exports.sru.dom.H3 = function(q,d) {
	if(q == null) q = window.document.createElement("h3");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_H3.__name__ = ["sirius","dom","H3"];
sirius_dom_H3.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_H3.__super__ = sirius_dom_Display;
sirius_dom_H3.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_H3
});
var sirius_dom_H4 = $hx_exports.sru.dom.H4 = function(q,d) {
	if(q == null) q = window.document.createElement("h4");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_H4.__name__ = ["sirius","dom","H4"];
sirius_dom_H4.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_H4.__super__ = sirius_dom_Display;
sirius_dom_H4.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_H4
});
var sirius_dom_H5 = $hx_exports.sru.dom.H5 = function(q,d) {
	if(q == null) q = window.document.createElement("h5");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_H5.__name__ = ["sirius","dom","H5"];
sirius_dom_H5.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_H5.__super__ = sirius_dom_Display;
sirius_dom_H5.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_H5
});
var sirius_dom_H6 = $hx_exports.sru.dom.H6 = function(q,d) {
	if(q == null) q = window.document.createElement("h6");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_H6.__name__ = ["sirius","dom","H6"];
sirius_dom_H6.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_H6.__super__ = sirius_dom_Display;
sirius_dom_H6.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_H6
});
var sirius_dom_Head = $hx_exports.sru.dom.Head = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("head");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Head.__name__ = ["sirius","dom","Head"];
sirius_dom_Head.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Head.__super__ = sirius_dom_Display;
sirius_dom_Head.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Head
});
var sirius_dom_HR = $hx_exports.sru.dom.HR = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("hr");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_HR.__name__ = ["sirius","dom","HR"];
sirius_dom_HR.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_HR.__super__ = sirius_dom_Display;
sirius_dom_HR.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_HR
});
var sirius_dom_Html = $hx_exports.sru.dom.Html = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("html");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Html.__name__ = ["sirius","dom","Html"];
sirius_dom_Html.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Html.__super__ = sirius_dom_Display;
sirius_dom_Html.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Html
});
var sirius_dom_I = $hx_exports.sru.dom.I = function(q,d) {
	if(q == null) q = window.document.createElement("I");
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_I.__name__ = ["sirius","dom","I"];
sirius_dom_I.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_I.__super__ = sirius_dom_Display;
sirius_dom_I.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_I
});
var sirius_dom_IFrame = $hx_exports.sru.dom.IFrame = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("iframe");
	}
	sirius_dom_Display.call(this,q,null,d);
	this.object = this.element;
};
sirius_dom_IFrame.__name__ = ["sirius","dom","IFrame"];
sirius_dom_IFrame.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_IFrame.__super__ = sirius_dom_Display;
sirius_dom_IFrame.prototype = $extend(sirius_dom_Display.prototype,{
	src: function(url) {
		this.object.src = url;
	}
	,noScroll: function() {
		this.object.scrolling = "no";
	}
	,__class__: sirius_dom_IFrame
});
var sirius_dom_Img = $hx_exports.sru.dom.Img = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("img");
	}
	sirius_dom_Display.call(this,q,null,d);
	this.object = this.element;
};
sirius_dom_Img.__name__ = ["sirius","dom","Img"];
sirius_dom_Img.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Img.__super__ = sirius_dom_Display;
sirius_dom_Img.prototype = $extend(sirius_dom_Display.prototype,{
	src: function(value) {
		var a;
		if(value != null) this.object.src = value;
		return this.object.src;
	}
	,alt: function(value) {
		if(value != null) this.object.alt = value;
		return this.object.alt;
	}
	,__class__: sirius_dom_Img
});
var sirius_dom_Input = $hx_exports.sru.dom.Input = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("input");
	}
	sirius_dom_Display.call(this,q,null,d);
	this.object = this.element;
};
sirius_dom_Input.__name__ = ["sirius","dom","Input"];
sirius_dom_Input.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Input.__super__ = sirius_dom_Display;
sirius_dom_Input.prototype = $extend(sirius_dom_Display.prototype,{
	_update: function(e) {
		if(this._rtc.match(this.object.value)) {
			var s = this.object.selectionStart - 1;
			this.object.value = this._rtc.replace(this.object.value,"");
			this.object.setSelectionRange(s,s);
		}
	}
	,type: function(q) {
		if(q != null) this.object.type = q;
		return this.object.type;
	}
	,required: function(q) {
		if(q != null) this.object.required = q;
		return this.object.required;
	}
	,pattern: function(q) {
		if(q != null) this.object.pattern = q;
		return this.object.pattern;
	}
	,placeholder: function(q) {
		if(q != null) this.object.placeholder = q;
		return this.object.placeholder;
	}
	,validateDate: function() {
		this.pattern("\\d{1,2}/\\d{1,2}/\\d{4}");
	}
	,validateURL: function() {
		this.pattern("https?://.+");
	}
	,validateIPv4: function() {
		this.pattern("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");
	}
	,validateCurrency: function() {
		this.pattern("\\d+(\\.\\d{2})?");
	}
	,validateEmail: function() {
		this.pattern("/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$/");
	}
	,restrict: function(q) {
		if(this._rtc == null && q != null) {
			this.events.keyDown($bind(this,this._update),0);
			this.events.keyUp($bind(this,this._update),0);
			this.events.focusOut($bind(this,this._update),0);
		} else if(q == null) {
			this.events.keyDown($bind(this,this._update),-1);
			this.events.keyUp($bind(this,this._update),-1);
			this.events.focusOut($bind(this,this._update),-1);
		}
		this._rtc = q;
	}
	,restrictNumbers: function() {
		this.restrict(new EReg("[^0-9]","gi"));
	}
	,restrictLetters: function() {
		this.restrict(new EReg("[^A-Za-z]","giu"));
	}
	,value: function(q) {
		if(q != null) this.object.value = q;
		return this.object.value;
	}
	,isValid: function() {
		return this.object.value.length > 0;
	}
	,files: function() {
		return this.attribute("files");
	}
	,__class__: sirius_dom_Input
});
var sirius_dom_Label = $hx_exports.sru.dom.Label = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("label");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Label.__name__ = ["sirius","dom","Label"];
sirius_dom_Label.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Label.__super__ = sirius_dom_Display;
sirius_dom_Label.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Label
});
var sirius_dom_Legend = $hx_exports.sru.dom.Legend = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("legend");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Legend.__name__ = ["sirius","dom","Legend"];
sirius_dom_Legend.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Legend.__super__ = sirius_dom_Display;
sirius_dom_Legend.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Legend
});
var sirius_dom_LI = $hx_exports.sru.dom.LI = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("li");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_LI.__name__ = ["sirius","dom","LI"];
sirius_dom_LI.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_LI.__super__ = sirius_dom_Display;
sirius_dom_LI.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_LI
});
var sirius_dom_Link = $hx_exports.sru.dom.Link = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("link");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Link.__name__ = ["sirius","dom","Link"];
sirius_dom_Link.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Link.__super__ = sirius_dom_Display;
sirius_dom_Link.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Link
});
var sirius_dom_Map = $hx_exports.sru.dom.Map = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("map");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Map.__name__ = ["sirius","dom","Map"];
sirius_dom_Map.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Map.__super__ = sirius_dom_Display;
sirius_dom_Map.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Map
});
var sirius_dom_Media = $hx_exports.sru.dom.Media = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("media");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Media.__name__ = ["sirius","dom","Media"];
sirius_dom_Media.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Media.__super__ = sirius_dom_Display;
sirius_dom_Media.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Media
});
var sirius_dom_Menu = $hx_exports.sru.dom.Menu = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("menu");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Menu.__name__ = ["sirius","dom","Menu"];
sirius_dom_Menu.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Menu.__super__ = sirius_dom_Display;
sirius_dom_Menu.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Menu
});
var sirius_dom_Meta = $hx_exports.sru.dom.Meta = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("meta");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Meta.__name__ = ["sirius","dom","Meta"];
sirius_dom_Meta.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Meta.__super__ = sirius_dom_Display;
sirius_dom_Meta.prototype = $extend(sirius_dom_Display.prototype,{
	set: function(name,content) {
		this.attribute("name",name);
		this.attribute("content",content);
	}
	,charset: function(q,vr) {
		if(vr == null) vr = 5;
		if(vr >= 5) this.attribute("charset",q); else if(vr < 5) {
			this.attribute("http-equiv","content-type");
			this.attribute("charset","text/html; charset=UTF-8");
		}
	}
	,__class__: sirius_dom_Meta
});
var sirius_dom_Meter = $hx_exports.sru.dom.Meter = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("meter");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Meter.__name__ = ["sirius","dom","Meter"];
sirius_dom_Meter.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Meter.__super__ = sirius_dom_Display;
sirius_dom_Meter.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Meter
});
var sirius_dom_Mod = $hx_exports.sru.dom.Mod = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("mod");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Mod.__name__ = ["sirius","dom","Mod"];
sirius_dom_Mod.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Mod.__super__ = sirius_dom_Display;
sirius_dom_Mod.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Mod
});
var sirius_dom_Object = $hx_exports.sru.dom.Object = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("object");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Object.__name__ = ["sirius","dom","Object"];
sirius_dom_Object.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Object.__super__ = sirius_dom_Display;
sirius_dom_Object.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Object
});
var sirius_dom_OL = $hx_exports.sru.dom.OL = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("ol");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_OL.__name__ = ["sirius","dom","OL"];
sirius_dom_OL.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_OL.__super__ = sirius_dom_Display;
sirius_dom_OL.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_OL
});
var sirius_dom_OptGroup = $hx_exports.sru.dom.OptGroup = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("optgroup");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_OptGroup.__name__ = ["sirius","dom","OptGroup"];
sirius_dom_OptGroup.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_OptGroup.__super__ = sirius_dom_Display;
sirius_dom_OptGroup.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_OptGroup
});
var sirius_dom_Option = $hx_exports.sru.dom.Option = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("option");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Option.__name__ = ["sirius","dom","Option"];
sirius_dom_Option.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Option.__super__ = sirius_dom_Display;
sirius_dom_Option.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Option
});
var sirius_dom_Output = $hx_exports.sru.dom.Output = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("output");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Output.__name__ = ["sirius","dom","Output"];
sirius_dom_Output.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Output.__super__ = sirius_dom_Display;
sirius_dom_Output.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Output
});
var sirius_dom_P = $hx_exports.sru.dom.P = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("p");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_P.__name__ = ["sirius","dom","P"];
sirius_dom_P.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_P.__super__ = sirius_dom_Display;
sirius_dom_P.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_P
});
var sirius_dom_Param = $hx_exports.sru.dom.Param = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("param");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Param.__name__ = ["sirius","dom","Param"];
sirius_dom_Param.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Param.__super__ = sirius_dom_Display;
sirius_dom_Param.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Param
});
var sirius_dom_Picture = $hx_exports.sru.dom.Picture = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("picture");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Picture.__name__ = ["sirius","dom","Picture"];
sirius_dom_Picture.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Picture.__super__ = sirius_dom_Display;
sirius_dom_Picture.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Picture
});
var sirius_dom_Pre = $hx_exports.sru.dom.Pre = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("pre");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Pre.__name__ = ["sirius","dom","Pre"];
sirius_dom_Pre.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Pre.__super__ = sirius_dom_Display;
sirius_dom_Pre.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Pre
});
var sirius_dom_Progress = $hx_exports.sru.dom.Progress = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("progress");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Progress.__name__ = ["sirius","dom","Progress"];
sirius_dom_Progress.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Progress.__super__ = sirius_dom_Display;
sirius_dom_Progress.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Progress
});
var sirius_dom_Quote = $hx_exports.sru.dom.Quote = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("quote");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Quote.__name__ = ["sirius","dom","Quote"];
sirius_dom_Quote.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Quote.__super__ = sirius_dom_Display;
sirius_dom_Quote.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Quote
});
var sirius_dom_Script = $hx_exports.sru.dom.Script = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("script");
	}
	sirius_dom_Display.call(this,q,null,d);
	this.content = this.element;
};
sirius_dom_Script.__name__ = ["sirius","dom","Script"];
sirius_dom_Script.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Script.require = function(url,handler) {
	if(url.length > 0) {
		var file = url.shift();
		if(file != null) {
			var s = new sirius_dom_Script();
			sirius_Sirius.document.head.addChild(s);
			s.load(file,function(e) {
				sirius_dom_Script.require(url,handler);
			});
		}
	} else if(handler != null) handler(null);
};
sirius_dom_Script.__super__ = sirius_dom_Display;
sirius_dom_Script.prototype = $extend(sirius_dom_Display.prototype,{
	load: function(url,handler) {
		this.content.src = url;
		if(handler != null) this.events.load(handler,1);
	}
	,async: function() {
		this.content.async = true;
	}
	,__class__: sirius_dom_Script
});
var sirius_dom_Select = $hx_exports.sru.dom.Select = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("select");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Select.__name__ = ["sirius","dom","Select"];
sirius_dom_Select.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Select.__super__ = sirius_dom_Display;
sirius_dom_Select.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Select
});
var sirius_dom_Shadow = $hx_exports.sru.dom.Shadow = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("shadow");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Shadow.__name__ = ["sirius","dom","Shadow"];
sirius_dom_Shadow.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Shadow.__super__ = sirius_dom_Display;
sirius_dom_Shadow.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Shadow
});
var sirius_dom_Source = $hx_exports.sru.dom.Source = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("source");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Source.__name__ = ["sirius","dom","Source"];
sirius_dom_Source.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Source.__super__ = sirius_dom_Display;
sirius_dom_Source.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Source
});
var sirius_dom_Span = $hx_exports.sru.dom.Span = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("span");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Span.__name__ = ["sirius","dom","Span"];
sirius_dom_Span.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Span.__super__ = sirius_dom_Display;
sirius_dom_Span.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Span
});
var sirius_dom_Sprite = $hx_exports.sru.dom.Sprite = function(q,d) {
	if(d == null) d = "w-100pc h-100pc disp-table";
	sirius_dom_Div.call(this,q,d);
	if(q == null) this.attribute("sru-dom","sprite");
	this.content = this.one("div");
	if(this.content == null) {
		this.content = new sirius_dom_Div();
		this.addChild(this.content);
	}
	this.content.css("disp-table-cell vert-m");
};
sirius_dom_Sprite.__name__ = ["sirius","dom","Sprite"];
sirius_dom_Sprite.__super__ = sirius_dom_Div;
sirius_dom_Sprite.prototype = $extend(sirius_dom_Div.prototype,{
	__class__: sirius_dom_Sprite
});
var sirius_dom_Sprite3D = $hx_exports.sru.dom.Sprite3D = function(q,d) {
	if(d == null) d = "w-100pc h-100pc disp-table";
	sirius_dom_Display3D.call(this,null,d);
	this.setPerspective("1000px");
	this.content = new sirius_dom_Display3D(q);
	this.content.preserve3d().update();
	if(this.content.parent() == null) this.addChild(this.content);
	this.content.css("disp-table-cell vert-m");
	this.update();
};
sirius_dom_Sprite3D.__name__ = ["sirius","dom","Sprite3D"];
sirius_dom_Sprite3D.__super__ = sirius_dom_Display3D;
sirius_dom_Sprite3D.prototype = $extend(sirius_dom_Display3D.prototype,{
	__class__: sirius_dom_Sprite3D
});
var sirius_dom_Table = $hx_exports.sru.dom.Table = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("table");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Table.__name__ = ["sirius","dom","Table"];
sirius_dom_Table.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Table.__super__ = sirius_dom_Display;
sirius_dom_Table.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Table
});
var sirius_dom_TD = $hx_exports.sru.dom.TD = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("td");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_TD.__name__ = ["sirius","dom","TD"];
sirius_dom_TD.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_TD.__super__ = sirius_dom_Display;
sirius_dom_TD.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_TD
});
var sirius_dom_Text = function(q,d) {
	q = window.document.createTextNode(q);
	sirius_dom_Display.call(this,q,null,d);
	this.node = q;
};
sirius_dom_Text.__name__ = ["sirius","dom","Text"];
sirius_dom_Text.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Text.__super__ = sirius_dom_Display;
sirius_dom_Text.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Text
});
var sirius_dom_TextArea = $hx_exports.sru.dom.TextArea = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("textarea");
	}
	sirius_dom_Input.call(this,q,d);
};
sirius_dom_TextArea.__name__ = ["sirius","dom","TextArea"];
sirius_dom_TextArea.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_TextArea.__super__ = sirius_dom_Input;
sirius_dom_TextArea.prototype = $extend(sirius_dom_Input.prototype,{
	__class__: sirius_dom_TextArea
});
var sirius_dom_Thead = $hx_exports.sru.dom.Thead = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("thead");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Thead.__name__ = ["sirius","dom","Thead"];
sirius_dom_Thead.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Thead.__super__ = sirius_dom_Display;
sirius_dom_Thead.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Thead
});
var sirius_dom_Title = $hx_exports.sru.dom.Title = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("title");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Title.__name__ = ["sirius","dom","Title"];
sirius_dom_Title.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Title.__super__ = sirius_dom_Display;
sirius_dom_Title.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Title
});
var sirius_dom_TR = $hx_exports.sru.dom.TR = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("tr");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_TR.__name__ = ["sirius","dom","TR"];
sirius_dom_TR.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_TR.__super__ = sirius_dom_Display;
sirius_dom_TR.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_TR
});
var sirius_dom_Track = $hx_exports.sru.dom.Track = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("track");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Track.__name__ = ["sirius","dom","Track"];
sirius_dom_Track.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Track.__super__ = sirius_dom_Display;
sirius_dom_Track.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Track
});
var sirius_dom_UL = $hx_exports.sru.dom.UL = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("ul");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_UL.__name__ = ["sirius","dom","UL"];
sirius_dom_UL.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_UL.__super__ = sirius_dom_Display;
sirius_dom_UL.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_UL
});
var sirius_dom_Video = $hx_exports.sru.dom.Video = function(q,d) {
	if(q == null) {
		var _this = window.document;
		q = _this.createElement("video");
	}
	sirius_dom_Display.call(this,q,null,d);
};
sirius_dom_Video.__name__ = ["sirius","dom","Video"];
sirius_dom_Video.get = function(q,h) {
	return sirius_Sirius.one(q,null,h);
};
sirius_dom_Video.__super__ = sirius_dom_Display;
sirius_dom_Video.prototype = $extend(sirius_dom_Display.prototype,{
	__class__: sirius_dom_Video
});
var sirius_tools_Utils = $hx_exports.Utils = function() { };
sirius_tools_Utils.__name__ = ["sirius","tools","Utils"];
sirius_tools_Utils.matchMedia = function(value) {
	return window.matchMedia(value).matches;
};
sirius_tools_Utils.screenOrientation = function() {
	if(sirius_tools_Utils.matchMedia("(orientation: portrait)")) return "portrait"; else return "landscape";
};
sirius_tools_Utils.viewportWidth = function() {
	return window.innerWidth || document.documentElement.clientWidth;
};
sirius_tools_Utils.viewportHeight = function() {
	return window.innerHeight || document.documentElement.clientHeight;
};
sirius_tools_Utils.mathLocation = function(uri) {
	return window.location.href.indexOf(uri) != -1;
};
sirius_tools_Utils.screenInfo = function() {
	return sirius_tools_Utils.screenOrientation() + "(" + sirius_tools_Utils.viewportWidth() + "x" + sirius_tools_Utils.viewportHeight() + ")";
};
sirius_tools_Utils.displayFrom = function(t) {
	if(t.nodeType != 1) return new sirius_dom_Display(t);
	var OC = Reflect.field(sirius_tools_Utils._typeOf,(t.hasAttribute("sru-dom")?t.getAttribute("sru-dom"):t.tagName).toLowerCase());
	if(OC == null) return new sirius_dom_Display(t); else {
		return new OC(t);
	}
};
sirius_tools_Utils.clearArray = function(path,filter) {
	var copy = [];
	sirius_utils_Dice.Values(path,function(v) {
		if(v != null && v != "" && (filter == null || filter(v))) copy[copy.length] = v;
	});
	return copy;
};
sirius_tools_Utils.toString = function(o,json) {
	if(json == true) return JSON.stringify(o); else return Std.string(o);
};
sirius_tools_Utils.isValid = function(o) {
	if(o != null) {
		if(typeof(o) == "string") return o.length > 0; else return true;
	}
	return false;
};
sirius_tools_Utils.getClassName = function(o) {
	if(o != null) return Type.getClassName(Type.getClass(o)); else return "null";
};
var sirius_events_IDispatcher = function() { };
sirius_events_IDispatcher.__name__ = ["sirius","events","IDispatcher"];
sirius_events_IDispatcher.prototype = {
	__class__: sirius_events_IDispatcher
};
var sirius_events_Dispatcher = $hx_exports.sru.events.Dispatcher = function(q) {
	this._b = { };
	this._e = { };
	this._i = { };
	this.target = q;
};
sirius_events_Dispatcher.__name__ = ["sirius","events","Dispatcher"];
sirius_events_Dispatcher.__interfaces__ = [sirius_events_IDispatcher];
sirius_events_Dispatcher.PREVENT_DEFAULT = function(e) {
	e.event.preventDefault();
};
sirius_events_Dispatcher.prototype = {
	event: function(name) {
		var dis = null;
		if(!this.hasEvent(name)) {
			dis = new sirius_events_EventGroup(this,name);
			dis.prepare(this.target);
			this._e[name] = dis;
		} else dis = Reflect.field(this._e,name);
		return dis;
	}
	,hasEvent: function(name) {
		return Object.prototype.hasOwnProperty.call(this._e,name);
	}
	,apply: function() {
		var _g = this;
		sirius_utils_Dice.Values(this._e,function(v) {
			v.prepare(_g.target);
		});
	}
	,auto: function(type,handler,mode) {
		var ie = this.event(type);
		if(mode == null) return ie.add(handler,false); else switch(mode) {
		case 1:case true:case "capture":
			return ie.add(handler,true);
		case 0:case false:
			return ie.add(handler,false);
		case -1:case "remove":
			return ie.remove(handler);
		default:
			return ie;
		}
	}
	,wheel: function(handler,mode) {
		return this.auto("wheel",handler,mode);
	}
	,copy: function(handler,mode) {
		return this.auto("copy",handler,mode);
	}
	,cut: function(handler,mode) {
		return this.auto("cut",handler,mode);
	}
	,paste: function(handler,mode) {
		return this.auto("paste",handler,mode);
	}
	,abort: function(handler,mode) {
		return this.auto("abort",handler,mode);
	}
	,blur: function(handler,mode) {
		return this.auto("blur",handler,mode);
	}
	,focusIn: function(handler,mode) {
		return this.auto("focusin",handler,mode);
	}
	,focusOut: function(handler,mode) {
		return this.auto("focusout",handler,mode);
	}
	,canPlay: function(handler,mode) {
		return this.auto("canplay",handler,mode);
	}
	,canPlayThrough: function(handler,mode) {
		return this.auto("canplaythrough",handler,mode);
	}
	,change: function(handler,mode) {
		return this.auto("change",handler,mode);
	}
	,click: function(handler,mode) {
		return this.auto("click",handler,mode);
	}
	,contextMenu: function(handler,mode) {
		return this.auto("contextmenu",handler,mode);
	}
	,dblClick: function(handler,mode) {
		return this.auto("dblclick",handler,mode);
	}
	,drag: function(handler,mode) {
		return this.auto("drag",handler,mode);
	}
	,dragEnd: function(handler,mode) {
		return this.auto("dragend",handler,mode);
	}
	,dragEnter: function(handler,mode) {
		return this.auto("dragenter",handler,mode);
	}
	,dragLeave: function(handler,mode) {
		return this.auto("dragleave",handler,mode);
	}
	,dragOver: function(handler,mode) {
		return this.auto("dragover",handler,mode);
	}
	,dragStart: function(handler,mode) {
		return this.auto("dragstart",handler,mode);
	}
	,drop: function(handler,mode) {
		return this.auto("drop",handler,mode);
	}
	,durationChange: function(handler,mode) {
		return this.auto("durationchange",handler,mode);
	}
	,emptied: function(handler,mode) {
		return this.auto("emptied",handler,mode);
	}
	,ended: function(handler,mode) {
		return this.auto("ended",handler,mode);
	}
	,input: function(handler,mode) {
		return this.auto("input",handler,mode);
	}
	,invalid: function(handler,mode) {
		return this.auto("invalid",handler,mode);
	}
	,keyDown: function(handler,mode) {
		return this.auto("keydown",handler,mode);
	}
	,keyPress: function(handler,mode) {
		return this.auto("keypress",handler,mode);
	}
	,keyUp: function(handler,mode) {
		return this.auto("keyup",handler,mode);
	}
	,load: function(handler,mode) {
		return this.auto("load",handler,mode);
	}
	,loadedData: function(handler,mode) {
		return this.auto("loadeddata",handler,mode);
	}
	,loadedMetadata: function(handler,mode) {
		return this.auto("loadedmetadata",handler,mode);
	}
	,loadStart: function(handler,mode) {
		return this.auto("loadstart",handler,mode);
	}
	,mouseDown: function(handler,mode) {
		return this.auto("mousedown",handler,mode);
	}
	,mouseEnter: function(handler,mode) {
		return this.auto("mouseenter",handler,mode);
	}
	,mouseLeave: function(handler,mode) {
		return this.auto("mouseleave",handler,mode);
	}
	,mouseMove: function(handler,mode) {
		return this.auto("mousemove",handler,mode);
	}
	,mouseOut: function(handler,mode) {
		return this.auto("mouseout",handler,mode);
	}
	,mouseOver: function(handler,mode) {
		return this.auto("mouseover",handler,mode);
	}
	,mouseUp: function(handler,mode) {
		return this.auto("mouseup",handler,mode);
	}
	,pause: function(handler,mode) {
		return this.auto("pause",handler,mode);
	}
	,play: function(handler,mode) {
		return this.auto("play",handler,mode);
	}
	,playing: function(handler,mode) {
		return this.auto("playing",handler,mode);
	}
	,progress: function(handler,mode) {
		return this.auto("progress",handler,mode);
	}
	,rateChange: function(handler,mode) {
		return this.auto("ratechange",handler,mode);
	}
	,reset: function(handler,mode) {
		return this.auto("reset",handler,mode);
	}
	,scroll: function(handler,mode) {
		return this.auto("scroll",handler,mode);
	}
	,seeked: function(handler,mode) {
		return this.auto("seeked",handler,mode);
	}
	,seeking: function(handler,mode) {
		return this.auto("seeking",handler,mode);
	}
	,select: function(handler,mode) {
		return this.auto("select",handler,mode);
	}
	,show: function(handler,mode) {
		return this.auto("show",handler,mode);
	}
	,stalled: function(handler,mode) {
		return this.auto("stalled",handler,mode);
	}
	,submit: function(handler,mode) {
		return this.auto("submit",handler,mode);
	}
	,suspEnd: function(handler,mode) {
		return this.auto("suspend",handler,mode);
	}
	,timeUpdate: function(handler,mode) {
		return this.auto("timeupdate",handler,mode);
	}
	,volumeChange: function(handler,mode) {
		return this.auto("volumechange",handler,mode);
	}
	,waiting: function(handler,mode) {
		return this.auto("waiting",handler,mode);
	}
	,pointerCancel: function(handler,mode) {
		return this.auto("pointercancel",handler,mode);
	}
	,pointerDown: function(handler,mode) {
		return this.auto("pointerdown",handler,mode);
	}
	,pointerUp: function(handler,mode) {
		return this.auto("pointerup",handler,mode);
	}
	,pointerMove: function(handler,mode) {
		return this.auto("pointermove",handler,mode);
	}
	,pointerOut: function(handler,mode) {
		return this.auto("pointerout",handler,mode);
	}
	,pointerOver: function(handler,mode) {
		return this.auto("pointerover",handler,mode);
	}
	,pointerEnter: function(handler,mode) {
		return this.auto("pointerenter",handler,mode);
	}
	,pointerLeave: function(handler,mode) {
		return this.auto("pointerleave",handler,mode);
	}
	,gotPointerCapture: function(handler,mode) {
		return this.auto("gotpointercapture",handler,mode);
	}
	,lostPointerCapture: function(handler,mode) {
		return this.auto("lostpointercapture",handler,mode);
	}
	,pointerLockChange: function(handler,mode) {
		return this.auto("pointerlockchange",handler,mode);
	}
	,pointerLockError: function(handler,mode) {
		return this.auto("pointerlockerror",handler,mode);
	}
	,error: function(handler,mode) {
		return this.auto("error",handler,mode);
	}
	,touchStart: function(handler,mode) {
		return this.auto("touchstart",handler,mode);
	}
	,touchEnd: function(handler,mode) {
		return this.auto("touchend",handler,mode);
	}
	,touchMove: function(handler,mode) {
		return this.auto("touchmove",handler,mode);
	}
	,touchCancel: function(handler,mode) {
		return this.auto("touchcancel",handler,mode);
	}
	,readyState: function(handler,mode) {
		return this.auto("readystatechange",handler,mode);
	}
	,visibility: function(handler,mode) {
		return this.auto("visibility",handler,mode);
	}
	,resize: function(handler,mode) {
		return this.auto("resize",handler,mode);
	}
	,__class__: sirius_events_Dispatcher
};
var sirius_tools_Key = $hx_exports.sru.tools.Key = function() { };
sirius_tools_Key.__name__ = ["sirius","tools","Key"];
sirius_tools_Key.COUNTER = function() {
	return sirius_tools_Key._counter++;
};
sirius_tools_Key.GEN = function(size,table,mixCase) {
	if(mixCase == null) mixCase = true;
	if(size == null) size = 9;
	var s = "";
	if(table == null) table = sirius_tools_Key.TABLE;
	var l = table.length;
	var c = null;
	while(_$UInt_UInt_$Impl_$.gt(size,s.length)) {
		var pos = Std.random(l);
		c = HxOverrides.substr(table,pos,1);
		if(mixCase) {
			if(Math.random() < .5) c = c.toUpperCase(); else c = c.toLowerCase();
		}
		s += c;
	}
	return s;
};
var sirius_data_DisplayData = function() {
	this.__data__ = new sirius_data_DataSet();
	sirius_data_DataSet.call(this);
};
sirius_data_DisplayData.__name__ = ["sirius","data","DisplayData"];
sirius_data_DisplayData.__super__ = sirius_data_DataSet;
sirius_data_DisplayData.prototype = $extend(sirius_data_DataSet.prototype,{
	clear: function() {
		var d = this.__data__;
		sirius_data_DataSet.prototype.clear.call(this);
		this.__data__ = d;
		return this;
	}
	,__class__: sirius_data_DisplayData
});
var sirius_css_Automator = $hx_exports.Automator = function() { };
sirius_css_Automator.__name__ = ["sirius","css","Automator"];
sirius_css_Automator.enableLogging = function() {
	sirius_css_Automator._dev = true;
};
sirius_css_Automator.disableLogging = function() {
	sirius_css_Automator._dev = false;
};
sirius_css_Automator.scan = function(dev,force) {
	if(force == null) force = false;
	if(dev == null) dev = false;
	sirius_Sirius.log("Sirius->Automator.scanner[ " + (dev == true?"Infinity":"1x") + " ]",10,1);
	sirius_css_Automator._dev = dev == true;
	if(force) sirius_css_Automator._scanBody(); else if(!sirius_css_Automator._dev) sirius_css_Automator._scanBody(); else sirius_css_Automator._activate();
};
sirius_css_Automator._activate = function() {
	sirius_css_Automator._scanBody();
	sirius_tools_Delayer.create(sirius_css_Automator._scanBody,1).call(0);
};
sirius_css_Automator._scanBody = function() {
	sirius_css_Automator.search(sirius_Sirius.document.element);
};
sirius_css_Automator.search = function(t) {
	if(t == null) return;
	if(!(typeof(t) == "string")) {
		if(js_Boot.__instanceof(t,sirius_dom_IDisplay)) t = t.element.outerHTML; else if(js_Boot.__instanceof(t,HTMLElement)) t = t.outerHTML; else t = Std.string(t);
	}
	var t1 = t.split("class=");
	if(t1.length > 0) t1.shift();
	sirius_utils_Dice.Values(t1,function(v) {
		var i = HxOverrides.substr(v,0,1);
		var j = v.indexOf(i,1);
		if(j > 1) {
			v = v.substring(1,j);
			if(v.length > 0) sirius_css_Automator.build(v,null,true);
		}
	});
	sirius_css_Automator.css.build();
};
sirius_css_Automator.build4All = function(query,group,silent) {
	sirius_css_Automator.build(query,group + "-xs",silent);
	sirius_css_Automator.build(query,group + "-sm",silent);
	sirius_css_Automator.build(query,group + "-md",silent);
	sirius_css_Automator.build(query,group + "-lg",silent);
	sirius_css_Automator.build(query,group + "-pr",silent);
	sirius_css_Automator.build(query,group,silent);
};
sirius_css_Automator.build = function(query,group,silent) {
	var c = query.split(" ");
	var m = null;
	var s;
	var g = group != null && group.length > 0;
	var r = "";
	if(g) m = sirius_css_Automator._screen(group.split("-"));
	sirius_utils_Dice.Values(c,function(v) {
		if(v.length > 1) {
			v = v.split("\r").join(" ").split("\n").join(" ").split("\t").join(" ");
			c = v.split("-");
			if(g) {
				sirius_css_Automator._screen(c);
				var en = sirius_css_Automator._parse(c);
				s = en.build();
				if(s != null) r += s + ";"; else sirius_Sirius.log("Sirius->Automator.build::error( [" + Std.string(en) + "] )");
			} else {
				m = sirius_css_Automator._screen(c);
				if(!sirius_css_Automator.css.hasSelector(v,m)) {
					s = sirius_css_Automator._parse(c).build();
					if(sirius_tools_Utils.isValid(s)) {
						if(sirius_css_Automator._dev == true) sirius_Sirius.log("Sirius->Automator.build[ ." + v + " {" + s + ";} ]",10,1);
						sirius_css_Automator.css.setSelector("." + v,s,m);
					}
				}
			}
		}
	});
	if(g) {
		if(sirius_css_Automator._dev == true) sirius_Sirius.log("Sirius->Automator.build[ " + group + " {" + r + "} ]",10,1);
		sirius_css_Automator.css.setSelector(group,r,m);
	}
	if(silent == null) sirius_css_Automator.css.build();
};
sirius_css_Automator.addGrid = function(size) {
	if(!((size instanceof Array) && size.__enum__ == null)) size = [size];
	sirius_utils_Dice.Values(size,function(v) {
		sirius_css_Automator._createGridCol(v);
	});
};
sirius_css_Automator._createGridCol = function(size) {
	var n = ".mosaic-" + size;
	if(!sirius_css_Automator.css.hasSelector(n,null,"")) sirius_utils_Dice.Count(0,size,function(a,b,c) {
		++a;
		var s = (a/b*100).toFixed(9).split(".").join("d") + "pc";
		var n1 = ".cel-" + a + "x" + b;
		sirius_css_Automator.build4All("w-" + s + " padd-10",n1);
		if(a < b - 1) {
			sirius_css_Automator.build4All("pull-l",n1);
			sirius_css_Automator.build4All("marg-l-" + s,"skip-" + n1);
		}
		return null;
	});
};
sirius_css_Automator._init = function() {
	sirius_css_Automator.build("marg-0 padd-0 bord-0 outline-0 font-inherit vert-baseline transparent","*");
	sirius_css_Automator.build("arial txt-12","body");
	sirius_css_Automator.build("txt-decoration-none","a,a:link,a:visited,a:active,a:hover");
	sirius_css_Automator.build("list-style-none","ol,ul,dl");
	sirius_css_Automator.build("padd-5","hr");
	sirius_css_Automator.build("disp-table content-void",".grid:before,.grid:after");
	sirius_css_Automator.build("clear-both",".grid:after");
	sirius_css_Automator.css.setSelector("@-ms-viewport","width:device-width;");
	sirius_css_Automator.css.setSelector("*,*:before,*:after","-webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;");
	sirius_css_Automator.build("marg-a vert-m float-l float-r txt-c");
	Reflect.deleteField(sirius_css_Automator,"_init");
};
sirius_css_Automator._screen = function(args) {
	if(sirius_css_Automator._scx.indexOf("#" + args[args.length - 1] + "#") != -1) return args.pop(); else return null;
};
sirius_css_Automator._parse = function(args) {
	var r = [];
	sirius_utils_Dice.All(args,function(p,v) {
		if(v.length > 0) {
			var val = sirius_css_AutomatorRules.get(v);
			var v2;
			if(val != null) v2 = val.value; else v2 = null;
			r[p] = { index : p, key : v, entry : val, position : sirius_css_Automator._position(v2,v), measure : sirius_css_Automator._measure(v2,v), color : sirius_css_Automator._color(v2,v)};
		}
	});
	return new sirius_css_Entry(r,sirius_css_AutomatorRules.keys());
};
sirius_css_Automator._position = function(r,x) {
	return "tblr".indexOf(x) != -1;
};
sirius_css_Automator._color = function(r,x) {
	if(HxOverrides.substr(x,0,1) == "x" && (x.length == 4 || x.length == 7)) return "#" + x.substring(1,x.length); else if(sirius_tools_Utils.isValid(r) && HxOverrides.substr(r,0,1) == "#") return r;
	return null;
};
sirius_css_Automator._measure = function(r,x) {
	if(r == null) {
		var l = x.length;
		if(HxOverrides.substr(x,l - 2,2) == "pc") r = x.split("d").join(".").split("pc").join("%"); else if(HxOverrides.substr(x,l - 1,1) == "n" && Std.parseInt(HxOverrides.substr(x,0,2)) != null) r = "-" + x.split("n").join("") + "px"; else {
			var n = Std.parseInt(x);
			if(n != null) r = n + "px";
		}
		return r;
	} else return null;
};
var sirius_math_IARGB = function() { };
sirius_math_IARGB.__name__ = ["sirius","math","IARGB"];
sirius_math_IARGB.prototype = {
	__class__: sirius_math_IARGB
};
var sirius_math_ARGB = $hx_exports.ARGB = function(q,g,b,a) {
	var s = typeof(q) == "string" && (q.substr(0,3) == "rgb" || q.substr(0,2) == "0x" || q.substr(0,1) == "#");
	if(s && q.substr(0,3) == "rgb") {
		s = false;
		q = q.split("rgba").join("").q.split("rgb").join("").split("(").join("").split(")").join("").split(" ").join("");
		q = q.split(",");
		if(q.length == 4) a = Std.parseInt(q[3]);
		b = Std.parseInt(q[2]);
		g = Std.parseInt(q[1]);
		q = Std.parseInt(q[0]);
	}
	if(!s && q <= 255 && g != null) {
		if(a <= 255) {
			if(a < 0) this.a = 0; else this.a = a;
		} else this.a = 255;
		if(q <= 255) {
			if(q < 0) this.r = 0; else this.r = q;
		} else this.r = 255;
		if(g <= 255) {
			if(g < 0) this.g = 0; else this.g = g;
		} else this.g = 255;
		if(b <= 255) {
			if(b < 0) this.b = 0; else this.b = b;
		} else this.b = 255;
	} else {
		var x;
		if(s) x = Std.parseInt(q.split("#").join("0x")); else x = q;
		this.a = x >> 24 & 255;
		this.r = x >> 16 & 255;
		this.g = x >> 8 & 255;
		this.b = x & 255;
	}
	if(a == null) a = 255;
};
sirius_math_ARGB.__name__ = ["sirius","math","ARGB"];
sirius_math_ARGB.__interfaces__ = [sirius_math_IARGB];
sirius_math_ARGB.from = function(q,g,b,a) {
	return new sirius_math_ARGB(q,g,b,a);
};
sirius_math_ARGB.prototype = {
	value32: function() {
		return this.a << 24 | this.r << 16 | this.g << 8 | this.b;
	}
	,value: function() {
		return this.r << 16 | this.g << 8 | this.b;
	}
	,invert: function() {
		return new sirius_math_ARGB(255 - this.r,255 - this.g,255 - this.b,this.a);
	}
	,range: function(rate,alpha) {
		if(alpha == null) alpha = 0;
		if(rate < .01) rate = .01;
		var r2;
		r2 = (this.r == 0?1:this.r) * rate | 0;
		var g2;
		g2 = (this.g == 0?1:this.g) * rate | 0;
		var b2;
		b2 = (this.b == 0?1:this.b) * rate | 0;
		return new sirius_math_ARGB(r2 > 255?255:r2,g2 > 255?255:g2,b2 > 255?255:b2,alpha == 0?this.a:alpha * this.a | 0);
	}
	,change: function(ammount) {
		var r2 = this.r + ammount;
		var g2 = this.g + ammount;
		var b2 = this.b + ammount;
		return new sirius_math_ARGB(r2 > 255?255:r2,g2 > 255?255:g2,b2 > 255?255:b2,this.a);
	}
	,hex: function() {
		var r = this.value().toString(16);
		while(r.length < 6) r = "0" + r;
		return "#" + r;
	}
	,css: function() {
		if(this.a == 255) return "rgb(" + this.r + "," + this.g + "," + this.b + ")"; else return "rgba(" + this.r + "," + this.g + "," + this.b + "," + (this.a / 255).toFixed(2) + ")";
	}
	,__class__: sirius_math_ARGB
};
var sirius_utils_Dice = $hx_exports.Dice = function() { };
sirius_utils_Dice.__name__ = ["sirius","utils","Dice"];
sirius_utils_Dice.All = function(q,each,complete) {
	var v = null;
	var p = null;
	var i = true;
	var k = 0;
	if(q != null) {
		var _g = 0;
		var _g1 = Reflect.fields(q);
		while(_g < _g1.length) {
			var p1 = _g1[_g];
			++_g;
			v = Reflect.field(q,p1);
			if(each(p1,v) == true) {
				i = false;
				break;
			} else {
				++k;
				p1 = null;
				v = null;
			}
		}
	}
	var r = { param : p, value : v, completed : i, object : q, keys : k};
	if(complete != null) complete(r);
	return r;
};
sirius_utils_Dice.Params = function(q,each,complete) {
	return sirius_utils_Dice.All(q,function(p,v) {
		return each(p);
	},complete);
};
sirius_utils_Dice.Values = function(q,each,complete) {
	return sirius_utils_Dice.All(q,function(p,v) {
		return each(v);
	},complete);
};
sirius_utils_Dice.Call = function(q,method,args) {
	if(args == null) args = [];
	return sirius_utils_Dice.All(q,function(p,v) {
		Reflect.callMethod(v,Reflect.field(v,method),args);
	},null);
};
sirius_utils_Dice.Count = function(from,to,each,complete,increment) {
	if(increment == null) increment = 1;
	var a = Math.min(from,to);
	var b = Math.max(from,to);
	if(increment == null || _$UInt_UInt_$Impl_$.gt(1,increment)) increment = 1;
	while(a < b) if(each(a,b,(a = _$UInt_UInt_$Impl_$.toFloat(increment) + a) == b) == true) break;
	var c = a == b;
	var r = { from : from, to : b, completed : c, value : a};
	if(complete != null) complete(r);
	return r;
};
sirius_utils_Dice.One = function(from,alt) {
	if((from instanceof Array) && from.__enum__ == null) sirius_utils_Dice.Values(from,function(v) {
		from = v;
		return from == null;
	});
	return { value : sirius_tools_Utils.isValid(from)?from:alt, object : from};
};
sirius_utils_Dice.Match = function(table,values,limit) {
	if(limit == null) limit = 0;
	if(!((values instanceof Array) && values.__enum__ == null)) values = [values];
	var r = 0;
	sirius_utils_Dice.Values(values,function(v) {
		if(Lambda.indexOf(table,v) != -1) ++r;
		if(_$UInt_UInt_$Impl_$.gt(limit,0)) {
			var a = --limit;
			return a == 0;
		}
		return false;
	});
	return r;
};
sirius_utils_Dice.Children = function(of,each,complete) {
	var r = { children : []};
	var l = 0;
	var c;
	if(of != null) {
		if(js_Boot.__instanceof(of,sirius_dom_IDisplay)) of = of.element;
		sirius_utils_Dice.Count(0,of.childNodes.length,function(i,j,k) {
			c = of.childNodes.item(i);
			r.children[l] = c;
			return each(c,i);
		},complete);
	}
	return r;
};
var sirius_css_Entry = function(keys,dict) {
	this.keys = keys;
	this.head = keys[0];
	this.tail = keys[keys.length - 1];
	this.missing = 0;
	this.canceled = false;
};
sirius_css_Entry.__name__ = ["sirius","css","Entry"];
sirius_css_Entry.prototype = {
	build: function() {
		var _g = this;
		var r = null;
		if(this.head != null) {
			r = "";
			var c = 0;
			var t = this.keys.length;
			sirius_utils_Dice.Values(this.keys,function(v) {
				_g.next = _g.keys[++c];
				if(v.entry != null) r += v.entry.verifier(_g,v,_g.next); else r += _g._valueOf(v,t,c);
				return _g.canceled;
			});
		}
		return r;
	}
	,cancel: function() {
		this.canceled = true;
	}
	,_valueOf: function(v,t,c) {
		if(v.color != null) return v.color;
		if(v.measure != null) return v.measure;
		++this.missing;
		return v.key + (t == c?"":t - 1 == c?":":"-");
	}
	,__class__: sirius_css_Entry
};
var sirius_css_AutomatorRules = function() { };
sirius_css_AutomatorRules.__name__ = ["sirius","css","AutomatorRules"];
sirius_css_AutomatorRules.numericKey = function(d,k,n) {
	var v = k.entry.value;
	if(n != null && !n.position) {
		if(n.color != null) return v + "-color:";
		if(d.head.key == "bord") return sirius_css_AutomatorRules.borderFix(v,d,k,n);
		if(n.measure != null) return v + ":";
		return v + ":";
	}
	return v + (k.index == 0?"-":"");
};
sirius_css_AutomatorRules.borderFix = function(v,d,k,n) {
	if(n.measure != null) return v + "-width:";
	return v + (d.keys[1].key == "rad"?"-":"-style:");
};
sirius_css_AutomatorRules.mosaicKey = function(d,k,n) {
	if(d.head == k) {
		if(n != null) sirius_css_Automator.addGrid(Std.parseInt(n.key)); else sirius_css_Automator.addGrid(12);
		d.cancel();
		return null;
	}
	return k.entry.value;
};
sirius_css_AutomatorRules.shiftKey = function(d,k,n) {
	return "-" + k.entry.value;
};
sirius_css_AutomatorRules.commonKey = function(d,k,n) {
	return k.entry.value + (n != null?":":"");
};
sirius_css_AutomatorRules.pushKey = function(d,k,n) {
	return k.entry.value + "-";
};
sirius_css_AutomatorRules.valueKey = function(d,k,n) {
	return k.entry.value + ":";
};
sirius_css_AutomatorRules.alphaKey = function(d,k,n) {
	if(d.head == k) {
		d.cancel();
		var o = Std.parseInt(n.key);
		if(o > 100) o = 100; else if(o < 0) o = 0;
		return k.entry.value + ":" + o / 100;
	} else return sirius_css_AutomatorRules.valueKey(d,k,n);
};
sirius_css_AutomatorRules.appendKey = function(d,k,n) {
	return k.entry.value + (n != null?"-":"");
};
sirius_css_AutomatorRules.displayKey = function(d,k,n) {
	if(d.head == k) return "display:" + (k.key == "hidden"?"none":"block"); else return k.entry.value;
};
sirius_css_AutomatorRules.scrollKey = function(d,k,n) {
	var v = k.entry.value;
	if(d.head.key == "scroll") {
		if(k.index == 0) return "";
		var scroll = "scroll";
		if(v == "none") {
			v = "x";
			scroll = "none";
		}
		return "overflow-" + v + ":" + scroll + ";overflow-" + (v == "x"?"y":"x") + ":hidden";
	}
	return sirius_css_AutomatorRules.commonKey(d,k,n);
};
sirius_css_AutomatorRules.shadowKey = function(d,k,n) {
	if(d.head == k) {
		d.cancel();
		var i = d.tail.key == "i";
		var s = n.key == "txt";
		var t = new sirius_math_ARGB(d.keys[s?2:1].color);
		var r = "0 1px 0 " + t.range(.7).hex() + ",0 2px 0 " + t.range(.6).hex() + ",0 3px 0 " + t.range(.5).hex() + ",0 4px 0 " + t.range(.4).hex() + ",0 5px 0 " + t.range(.3).hex() + ",0 6px 1px rgba(0,0,0,.1),0 0 5px rgba(0,0,0,.1),0 1px 3px rgba(0,0,0,.3),0 3px 5px rgba(0,0,0,.2),0 5px 10px rgba(0,0,0,.25),0 10px 10px rgba(0,0,0,.2),0 20px 20px rgba(0,0,0,.15);";
		return (s?"text-shadow":"box-shadow") + ":" + r + (i?" !important":"");
	}
	return "shadow";
};
sirius_css_AutomatorRules.textKey = function(d,k,n) {
	if(k.index == 0) {
		if(n != null && !n.position) {
			if(n.color != null) return "color:";
			if(n.measure != null) return "font-size:";
		}
		if(n.key != "decoration") return "text-align:";
	}
	return "text-";
};
sirius_css_AutomatorRules.set = function(rule,value) {
	if((rule instanceof Array) && rule.__enum__ == null) sirius_utils_Dice.All(rule,function(p,v) {
		sirius_css_AutomatorRules._KEYS[p] = v;
	}); else if(value != null) Reflect.setField(sirius_css_AutomatorRules._KEYS,rule,value);
};
sirius_css_AutomatorRules.get = function(name) {
	var e = Reflect.field(sirius_css_AutomatorRules._KEYS,name);
	return e;
};
sirius_css_AutomatorRules.blank = function(name) {
	var e = { value : name, verifier : sirius_css_AutomatorRules.commonKey};
	sirius_css_AutomatorRules._KEYS[name] = e;
	return e;
};
sirius_css_AutomatorRules.keys = function() {
	return sirius_css_AutomatorRules._KEYS;
};
var sirius_css_IEntry = function() { };
sirius_css_IEntry.__name__ = ["sirius","css","IEntry"];
sirius_css_IEntry.prototype = {
	__class__: sirius_css_IEntry
};
var sirius_css_IKey = function() { };
sirius_css_IKey.__name__ = ["sirius","css","IKey"];
sirius_css_IKey.prototype = {
	__class__: sirius_css_IKey
};
var sirius_css_XCSS = $hx_exports.XCSS = function(data) {
	this.reset();
	if(data != null) this.flush(data);
};
sirius_css_XCSS.__name__ = ["sirius","css","XCSS"];
sirius_css_XCSS.create = function(target,data) {
	return new sirius_css_XCSS(data).apply(target);
};
sirius_css_XCSS.prototype = {
	flush: function(data) {
		sirius_utils_Dice.All(data,$bind(this,this.write));
	}
	,write: function(param,value) {
		if(sirius_css_XCSS.enabled == true) {
			var cx = HxOverrides.substr(param,0,1).toUpperCase() + HxOverrides.substr(param,1,param.length - 1);
			this.data["webkit" + cx] = value;
			this.data["Moz" + cx] = value;
			this.data["ms" + cx] = value;
			this.data["O" + cx] = value;
		}
		this.data[param] = value;
	}
	,apply: function(target) {
		target.style(this.data);
		return this;
	}
	,reset: function() {
		this.data = { };
		return this;
	}
	,__class__: sirius_css_XCSS
};
var sirius_data_IDataCache = function() { };
sirius_data_IDataCache.__name__ = ["sirius","data","IDataCache"];
sirius_data_IDataCache.prototype = {
	__class__: sirius_data_IDataCache
};
var sirius_data_DataCache = function(name,path,expire) {
	if(expire == null) expire = 0;
	this._name = name;
	this._path = path;
	this._expire = expire;
	this.clear();
};
sirius_data_DataCache.__name__ = ["sirius","data","DataCache"];
sirius_data_DataCache.__interfaces__ = [sirius_data_IDataCache];
sirius_data_DataCache.prototype = {
	_now: function() {
		return new Date().getTime();
	}
	,clear: function(p) {
		if(p != null) Reflect.deleteField(this._DB,p); else if(p != "__time__") {
			this._DB = { '__time__' : this._now()};
			js_Cookie.remove(this._name,this._path);
		}
		return this;
	}
	,set: function(p,v) {
		this._DB[p] = v;
		return this;
	}
	,merge: function(p,v) {
		if((v instanceof Array) && v.__enum__ == null && Object.prototype.hasOwnProperty.call(this._DB,this._name)) {
			var t = this.get(p);
			if((t instanceof Array) && t.__enum__ == null) return this.set(p,t.concat(v));
		}
		this._DB[p] = v;
		return this;
	}
	,get: function(id) {
		var d;
		if(id != null) d = Reflect.field(this._DB,id); else d = null;
		if(d == null) {
			d = { };
			this.set(id,d);
		}
		return d;
	}
	,exists: function(name) {
		if(name != null) return Object.prototype.hasOwnProperty.call(this._DB,this._name); else return this._loaded;
	}
	,save: function() {
		js_Cookie.set(this._name,sirius_utils_Criptog.encodeBase64(this._DB),0,this._path);
		return this;
	}
	,_sign: function(add) {
		if(add) this._DB.__time__ = this._now(); else {
			this.__time__ = this._DB.__time__;
			Reflect.deleteField(this._DB,"__time__");
		}
	}
	,load: function() {
		this._DB = null;
		if(js_Cookie.exists(this._name)) this._DB = sirius_utils_Criptog.decodeBase64(js_Cookie.get(this._name),true);
		if(this._DB == null || this._expire != 0 && (this._DB.__time__ == null || this._now() - this._DB.__time__ >= this._expire)) {
			this._DB = { };
			this._loaded = false;
		} else {
			this._sign(false);
			this._loaded = true;
		}
		return this;
	}
	,refresh: function() {
		this.__time__ = this._now();
		return this;
	}
	,getData: function() {
		return this._DB;
	}
	,json: function(print) {
		var result = JSON.stringify(this._DB);
		if(print) {
			if(print) haxe_Log.trace(result,{ fileName : "DataCache.hx", lineNumber : 195, className : "sirius.data.DataCache", methodName : "json"});
		}
		return result;
	}
	,base64: function(print) {
		var result = sirius_utils_Criptog.encodeBase64(this._DB);
		if(print) {
			if(print) haxe_Log.trace(result,{ fileName : "DataCache.hx", lineNumber : 201, className : "sirius.data.DataCache", methodName : "base64"});
		}
		return result;
	}
	,__class__: sirius_data_DataCache
};
var sirius_data_IFormData = function() { };
sirius_data_IFormData.__name__ = ["sirius","data","IFormData"];
sirius_data_IFormData.prototype = {
	__class__: sirius_data_IFormData
};
var sirius_data_FormData = function(target) {
	if(target != null) this.scan(target);
};
sirius_data_FormData.__name__ = ["sirius","data","FormData"];
sirius_data_FormData.__interfaces__ = [sirius_data_IFormData];
sirius_data_FormData.prototype = {
	reset: function() {
		this.params = [];
		return this;
	}
	,scan: function(target) {
		var _g = this;
		this.reset();
		if(target == null) this._form = sirius_Sirius.document; else this._form = target;
		target.all("[form-data]").each(function(el) {
			_g.params[_g.params.length] = new sirius_data_FormParam(el);
		});
		return this;
	}
	,valueOf: function(p) {
		var res = sirius_utils_Dice.Values(this.params,function(v) {
			return v.getName() == p;
		});
		return res.value;
	}
	,isValid: function() {
		var _g = this;
		this.errors = [];
		sirius_utils_Dice.Values(this.params,function(v) {
			if(!v.isValid()) _g.errors[_g.errors.length] = v;
		});
		return this.errors.length == 0;
	}
	,getParam: function(p) {
		var res = sirius_utils_Dice.Values(this.params,function(v) {
			return v.getName() == p;
		});
		return res.value;
	}
	,getData: function() {
		var d = { };
		sirius_utils_Dice.Values(this.params,function(v) {
			Reflect.setField(d,v.getName(),v.getValue());
			return;
		});
		return d;
	}
	,clear: function() {
		sirius_utils_Dice.Values(this.params,function(v) {
			v.clear();
		});
		return this;
	}
	,__class__: sirius_data_FormData
};
var sirius_data_FormParam = function(e) {
	this._e = e;
};
sirius_data_FormParam.__name__ = ["sirius","data","FormParam"];
sirius_data_FormParam.prototype = {
	getName: function() {
		return this._e.attribute("form-data");
	}
	,isRequired: function() {
		return this._e.hasAttribute("form-required") && sirius_utils_Dice.Match(["1","true","yes"],this._e.attribute("form-required")) > 0;
	}
	,getMessage: function() {
		return this._e.attribute("form-message");
	}
	,getValue: function() {
		return this._e.attribute("value");
	}
	,isValid: function() {
		return !this.isRequired() || sirius_tools_Utils.isValid(this.getValue());
	}
	,clear: function() {
		if(sirius_utils_Dice.Match(["1","true","yes"],this._e.attribute("form-persistent")) == 0) this._e.attribute("value","");
	}
	,__class__: sirius_data_FormParam
};
var sirius_errors_IError = function() { };
sirius_errors_IError.__name__ = ["sirius","errors","IError"];
sirius_errors_IError.prototype = {
	__class__: sirius_errors_IError
};
var sirius_errors_Error = function(code,message,object) {
	this.object = object;
	this.message = message;
	this.code = code;
};
sirius_errors_Error.__name__ = ["sirius","errors","Error"];
sirius_errors_Error.__interfaces__ = [sirius_errors_IError];
sirius_errors_Error.prototype = {
	__class__: sirius_errors_Error
};
var sirius_events_IEvent = function() { };
sirius_events_IEvent.__name__ = ["sirius","events","IEvent"];
sirius_events_IEvent.prototype = {
	__class__: sirius_events_IEvent
};
var sirius_events_Event = $hx_exports.sru.events.Event = function(from,ticket,event) {
	this.event = event;
	this.ticket = ticket;
	this.from = from;
	this.target = from.target;
	if(js_Boot.__instanceof(from.target,sirius_dom_IDisplay3D)) this.target3d = from.target; else this.target3d = null;
};
sirius_events_Event.__name__ = ["sirius","events","Event"];
sirius_events_Event.__interfaces__ = [sirius_events_IEvent];
sirius_events_Event.prototype = {
	description: function() {
		return "[Event{name:" + this.ticket.name + ",target:" + this.from.target.typeOf() + "}]";
	}
	,__class__: sirius_events_Event
};
var sirius_events_IEventGroup = function() { };
sirius_events_IEventGroup.__name__ = ["sirius","events","IEventGroup"];
sirius_events_IEventGroup.prototype = {
	__class__: sirius_events_IEventGroup
};
var sirius_events_EventGroup = $hx_exports.sru.events.EventGroup = function(dispatcher,name) {
	this.dispatcher = dispatcher;
	this.name = name;
	this.enabled = true;
	this.events = [];
};
sirius_events_EventGroup.__name__ = ["sirius","events","EventGroup"];
sirius_events_EventGroup.__interfaces__ = [sirius_events_IEventGroup];
sirius_events_EventGroup.prototype = {
	add: function(handler,capture) {
		if(capture != null) this.capture = capture;
		if(handler != null) this.events.push(handler);
		return this;
	}
	,remove: function(handler) {
		var iof = Lambda.indexOf(this.events,handler);
		if(iof != -1) this.events.splice(iof,1);
		return this;
	}
	,prepare: function(t) {
		t.element.removeEventListener(this.name,$bind(this,this._runner),this.capture);
		t.element.addEventListener(this.name,$bind(this,this._runner),this.capture);
		return this;
	}
	,cancel: function() {
		this.propagation = false;
		return this;
	}
	,preventDefault: function() {
		this._pd = true;
	}
	,reset: function() {
		this.events = [];
		return this;
	}
	,_runner: function(e) {
		var _g = this;
		if(!this.enabled) return;
		var evt = new sirius_events_Event(this.dispatcher,this,e);
		sirius_utils_Dice.Values(this.events,function(v) {
			if(v != null) v(evt);
			return !_g.propagation;
		});
		if(this._pd && e != null) evt.event.preventDefault();
		this.propagation = true;
	}
	,call: function() {
		this._runner(null);
		return this;
	}
	,__class__: sirius_events_EventGroup
};
var sirius_math_IPoint = function() { };
sirius_math_IPoint.__name__ = ["sirius","math","IPoint"];
sirius_math_IPoint.prototype = {
	__class__: sirius_math_IPoint
};
var sirius_math_IPoint3D = function() { };
sirius_math_IPoint3D.__name__ = ["sirius","math","IPoint3D"];
sirius_math_IPoint3D.prototype = {
	__class__: sirius_math_IPoint3D
};
var sirius_math_Point = function(x,y) {
	this.x = x;
	this.y = y;
};
sirius_math_Point.__name__ = ["sirius","math","Point"];
sirius_math_Point.__interfaces__ = [sirius_math_IPoint];
sirius_math_Point.prototype = {
	reset: function() {
		this.x = this.y = 0;
	}
	,match: function(o,round) {
		if(round) return Math.round(o.x) == Math.round(this.x) && Math.round(o.y) == Math.round(this.y); else return o.x == this.x && o.y == this.y;
	}
	,add: function(q) {
		this.x += q.x;
		this.y += q.y;
		return this;
	}
	,__class__: sirius_math_Point
};
var sirius_math_Point3D = function(x,y,z) {
	this.x = x;
	this.y = y;
	this.z = z;
};
sirius_math_Point3D.__name__ = ["sirius","math","Point3D"];
sirius_math_Point3D.__interfaces__ = [sirius_math_IPoint3D];
sirius_math_Point3D.prototype = {
	reset: function() {
		this.x = this.y = this.z = 0;
	}
	,match: function(o,round) {
		if(round) return Math.round(o.x) == Math.round(this.x) && Math.round(o.y) == Math.round(this.y) && Math.round(o.z) == Math.round(this.z); else return o.x == this.x && o.y == this.y && o.z == this.z;
	}
	,__class__: sirius_math_Point3D
};
var sirius_modules_IMod = function() { };
sirius_modules_IMod.__name__ = ["sirius","modules","IMod"];
sirius_modules_IMod.prototype = {
	__class__: sirius_modules_IMod
};
var sirius_modules_IRequest = function() { };
sirius_modules_IRequest.__name__ = ["sirius","modules","IRequest"];
sirius_modules_IRequest.prototype = {
	__class__: sirius_modules_IRequest
};
var sirius_modules_Request = function(success,data,error) {
	this.error = error;
	this.data = data;
	this.success = success;
};
sirius_modules_Request.__name__ = ["sirius","modules","Request"];
sirius_modules_Request.__interfaces__ = [sirius_modules_IRequest];
sirius_modules_Request.prototype = {
	object: function() {
		if(this.data != null && this.data.length > 1) return JSON.parse(this.data); else return null;
	}
	,__class__: sirius_modules_Request
};
var sirius_net_IDomainData = function() { };
sirius_net_IDomainData.__name__ = ["sirius","net","IDomainData"];
sirius_net_IDomainData.prototype = {
	__class__: sirius_net_IDomainData
};
var sirius_seo_SEO = function(type) {
	this.data = { };
	this.data["@context"] = "http://schema.org/";
	this.data["@type"] = type;
	var _this = window.document;
	this.object = _this.createElement("script");
	this.object.type = "application/ld+json";
};
sirius_seo_SEO.__name__ = ["sirius","seo","SEO"];
sirius_seo_SEO.sign = function(o,type,context) {
	if(context == null) context = true;
	if(context) o["@context"] = "http://schema.org";
	o["@type"] = type;
	return o;
};
sirius_seo_SEO.prototype = {
	publish: function() {
		this.object.innerHTML = JSON.stringify(this.data);
		if(this.object.parentElement == null) window.document.head.appendChild(this.object);
	}
	,typeOf: function() {
		return Reflect.field(this.data,"@type");
	}
	,__class__: sirius_seo_SEO
};
var sirius_seo_Breadcrumbs = function() {
	sirius_seo_SEO.call(this,"BreadcrumbList");
	this._setup();
};
sirius_seo_Breadcrumbs.__name__ = ["sirius","seo","Breadcrumbs"];
sirius_seo_Breadcrumbs.__super__ = sirius_seo_SEO;
sirius_seo_Breadcrumbs.prototype = $extend(sirius_seo_SEO.prototype,{
	_setup: function() {
		this.elements = [];
		this.data.itemListElement = this.elements;
	}
	,add: function(name,url) {
		this.elements[this.elements.length] = { '@type' : "ListItem", position : this.elements.length, item : { '@id' : url, name : name}};
	}
	,reset: function() {
		this.elements.splice(0,this.elements.length);
		return this;
	}
	,__class__: sirius_seo_Breadcrumbs
});
var sirius_seo_Descriptor = function(q) {
	sirius_seo_SEO.call(this,q);
	this._d = this.data;
};
sirius_seo_Descriptor.__name__ = ["sirius","seo","Descriptor"];
sirius_seo_Descriptor.__super__ = sirius_seo_SEO;
sirius_seo_Descriptor.prototype = $extend(sirius_seo_SEO.prototype,{
	name: function(q) {
		if(q != null) this._d.name = q;
		return this._d.name;
	}
	,url: function(q) {
		if(q != null) this._d.url = q;
		return this._d.url;
	}
	,logo: function(q) {
		if(q != null) this._d.logo = q;
		return this._d.logo;
	}
	,email: function(v) {
		if(v != null) this._d.email = v;
		return this._d.email;
	}
	,address: function(country,state,city,street,code) {
		if(this._d.address == null) this._d.address = sirius_seo_SEO.sign({ },"PostalAddress",false);
		if(country != null) this._d.address.addressCountry = country;
		if(state != null) this._d.address.addressRegion = state;
		if(city != null) this._d.address.addressLocality = city;
		if(street != null) this._d.address.streetAddress = street;
		if(code != null) this._d.address.postalCode = code;
		return this._d.address;
	}
	,social: function(q) {
		var _g = this;
		if(q != null) {
			if(this._d.sameAs == null) this._d.sameAs = [];
			sirius_utils_Dice.Values(q,function(v) {
				if(HxOverrides.indexOf(_g._d.sameAs,v,0) == -1) _g._d.sameAs[_g._d.sameAs.length] = v;
			});
		}
		return this._d.sameAs;
	}
	,__class__: sirius_seo_Descriptor
});
var sirius_seo_IAddress = function() { };
sirius_seo_IAddress.__name__ = ["sirius","seo","IAddress"];
sirius_seo_IAddress.prototype = {
	__class__: sirius_seo_IAddress
};
var sirius_seo_IBrand = function() { };
sirius_seo_IBrand.__name__ = ["sirius","seo","IBrand"];
sirius_seo_IBrand.prototype = {
	__class__: sirius_seo_IBrand
};
var sirius_seo_IContact = function() { };
sirius_seo_IContact.__name__ = ["sirius","seo","IContact"];
sirius_seo_IContact.prototype = {
	__class__: sirius_seo_IContact
};
var sirius_seo_IDescriptor = function() { };
sirius_seo_IDescriptor.__name__ = ["sirius","seo","IDescriptor"];
sirius_seo_IDescriptor.prototype = {
	__class__: sirius_seo_IDescriptor
};
var sirius_seo_IItem = function() { };
sirius_seo_IItem.__name__ = ["sirius","seo","IItem"];
sirius_seo_IItem.prototype = {
	__class__: sirius_seo_IItem
};
var sirius_seo_IOffer = function() { };
sirius_seo_IOffer.__name__ = ["sirius","seo","IOffer"];
sirius_seo_IOffer.prototype = {
	__class__: sirius_seo_IOffer
};
var sirius_seo_IOrgDescriptor = function() { };
sirius_seo_IOrgDescriptor.__name__ = ["sirius","seo","IOrgDescriptor"];
sirius_seo_IOrgDescriptor.__interfaces__ = [sirius_seo_IDescriptor];
sirius_seo_IOrgDescriptor.prototype = {
	__class__: sirius_seo_IOrgDescriptor
};
var sirius_seo_IReview = function() { };
sirius_seo_IReview.__name__ = ["sirius","seo","IReview"];
sirius_seo_IReview.prototype = {
	__class__: sirius_seo_IReview
};
var sirius_seo_ISearchBox = function() { };
sirius_seo_ISearchBox.__name__ = ["sirius","seo","ISearchBox"];
sirius_seo_ISearchBox.prototype = {
	__class__: sirius_seo_ISearchBox
};
var sirius_seo_IWebSite = function() { };
sirius_seo_IWebSite.__name__ = ["sirius","seo","IWebSite"];
sirius_seo_IWebSite.prototype = {
	__class__: sirius_seo_IWebSite
};
var sirius_seo_Organization = function() {
	sirius_seo_Descriptor.call(this,"Organization");
	this._e = this.data;
};
sirius_seo_Organization.__name__ = ["sirius","seo","Organization"];
sirius_seo_Organization.__super__ = sirius_seo_Descriptor;
sirius_seo_Organization.prototype = $extend(sirius_seo_Descriptor.prototype,{
	build: function(name,url,logo,email,social) {
		this.name(name);
		this.url(url);
		this.logo(logo);
		this.email(email);
		this.social(social);
	}
	,contact: function(phone,type,area,language,options) {
		if(this._e.contactPoint == null) this._e.contactPoint = [];
		var c = sirius_seo_SEO.sign({ },"ContactPoint",false);
		if(phone != null) c.telephone = phone;
		if(type != null) c.contactType = type;
		if(area != null) c.areaServed = area;
		if(language != null) c.availableLanguage = language;
		if(options != null) c.contactOption = options;
		this._e.contactPoint[this._e.contactPoint.length] = c;
		return this;
	}
	,__class__: sirius_seo_Organization
});
var sirius_seo_Person = function() {
	sirius_seo_Descriptor.call(this,"Person");
};
sirius_seo_Person.__name__ = ["sirius","seo","Person"];
sirius_seo_Person.__super__ = sirius_seo_Descriptor;
sirius_seo_Person.prototype = $extend(sirius_seo_Descriptor.prototype,{
	build: function(name,social) {
		this.name(name);
		this.social(social);
	}
	,__class__: sirius_seo_Person
});
var sirius_seo_Product = $hx_exports.sru.seo.Product = function() {
	sirius_seo_SEO.call(this,"Product");
};
sirius_seo_Product.__name__ = ["sirius","seo","Product"];
sirius_seo_Product.__super__ = sirius_seo_SEO;
sirius_seo_Product.prototype = $extend(sirius_seo_SEO.prototype,{
	name: function(q) {
		if(q != null) this.data.name = q;
		return Reflect.field(this.data,"name");
	}
	,image: function(q) {
		if(q != null) this.data.image = q;
		return Reflect.field(this.data,"image");
	}
	,description: function(q) {
		if(q != null) this.data.description = q;
		return Reflect.field(this.data,"description");
	}
	,mpn: function(q) {
		if(q != null) this.data.mpn = Std.string(q);
		return Reflect.field(this.data,"mpn");
	}
	,review: function(value,reviews) {
		if(this.reviewOf == null) {
			this.reviewOf = { '@type' : "AggregateRating", ratingValue : "0,0", reviewCount : 0};
			this.data.aggregateRating = this.reviewOf;
		}
		if(value != null) this.reviewOf.ratingValue = value.toFixed(1).split('.').join(',');
		if(reviews != null) if(reviews == null) this.reviewOf.reviewCount = "null"; else this.reviewOf.reviewCount = "" + reviews;
		return this.reviewOf;
	}
	,brand: function(name,image,url) {
		if(this.brandOf == null) {
			this.brandOf = { '@type' : "Thing", name : ""};
			this.data.brand = this.brandOf;
		}
		if(name != null) this.brandOf.name = name;
		if(image != null) this.brandOf.image = image;
		if(url != null) this.brandOf.url = url;
		return this.brandOf;
	}
	,offer: function(currency,availability,from,to) {
		if(this.offerOf == null) {
			this.offerOf = { '@type' : "AggregateOffer", name : ""};
			this.data.offers = this.offerOf;
		}
		if(currency != null) this.offerOf.priceCurrency = currency.toUpperCase();
		if(availability != null) this.offerOf.availability = "http://schema.org/" + availability;
		if(from != null) {
			if(to != null) {
				this.offerOf.lowPrice = from;
				this.offerOf.highPrice = to;
			} else this.offerOf.price = from;
		}
		return this.offerOf;
	}
	,build: function(name,image,description,mpn) {
		this.name(name);
		this.image(image);
		this.description(description);
		this.mpn(mpn);
		return this;
	}
	,__class__: sirius_seo_Product
});
var sirius_seo_Search = function() {
	sirius_seo_SEO.call(this,"WebSite");
	this._d = this.data;
};
sirius_seo_Search.__name__ = ["sirius","seo","Search"];
sirius_seo_Search.__super__ = sirius_seo_SEO;
sirius_seo_Search.prototype = $extend(sirius_seo_SEO.prototype,{
	url: function(q) {
		if(q != null) this._d.url = q;
		return this._d.url;
	}
	,action: function(target,prop) {
		if(this._d != null) this._d.potentialAction = { '@type' : "SearchAction", target : target, 'query-input' : "required name=" + prop};
		return this._d;
	}
	,build: function(q,target,prop) {
		this.url(q);
		this.action(target,prop);
		return this;
	}
	,__class__: sirius_seo_Search
});
var sirius_seo_WebSite = function() {
	sirius_seo_SEO.call(this,"WebSite");
	this._d = this.data;
};
sirius_seo_WebSite.__name__ = ["sirius","seo","WebSite"];
sirius_seo_WebSite.__super__ = sirius_seo_SEO;
sirius_seo_WebSite.prototype = $extend(sirius_seo_SEO.prototype,{
	name: function(q) {
		if(q != null) this._d.name = q;
		return this._d.name;
	}
	,alt: function(q) {
		if(q != null) this._d.alternateName = q;
		return this._d.alternateName;
	}
	,url: function(q) {
		if(q != null) this._d.url = q;
		return this._d.url;
	}
	,build: function(name,url,alt) {
		this.name(name);
		this.url(url);
		this.alt(alt);
		return this._d;
	}
	,__class__: sirius_seo_WebSite
});
var sirius_tools_BitIO = $hx_exports.sru.bit.BitIO = function(value) {
	this.value = value;
};
sirius_tools_BitIO.__name__ = ["sirius","tools","BitIO"];
sirius_tools_BitIO.Write = function(hash,bit) {
	return hash | bit;
};
sirius_tools_BitIO.Unwrite = function(hash,bit) {
	return hash & ~bit;
};
sirius_tools_BitIO.Toggle = function(hash,bit) {
	if(sirius_tools_BitIO.Test(hash,bit)) return sirius_tools_BitIO.Unwrite(hash,bit); else return sirius_tools_BitIO.Write(hash,bit);
};
sirius_tools_BitIO.Test = function(hash,value) {
	return (hash & value) == value;
};
sirius_tools_BitIO.Value = function(hash,size) {
	if(size == null) size = 32;
	var v = hash.toString(2);
	while(_$UInt_UInt_$Impl_$.gt(size,v.length)) v = "0" + v;
	return v;
};
sirius_tools_BitIO.prototype = {
	reverse: function(bit) {
		this.value = sirius_tools_BitIO.Toggle(this.value,bit);
	}
	,set: function(bit) {
		this.value = sirius_tools_BitIO.Write(this.value,bit);
	}
	,unset: function(bit) {
		this.value = sirius_tools_BitIO.Unwrite(this.value,bit);
	}
	,get: function(bit) {
		return sirius_tools_BitIO.Test(this.value,bit);
	}
	,valueOf: function(size) {
		if(size == null) size = 32;
		return sirius_tools_BitIO.Value(this.value,size);
	}
	,__class__: sirius_tools_BitIO
};
var sirius_tools_Delayer = $hx_exports.sru.tools.Delayer = function(handler,time,args,thisObj) {
	this._this = thisObj;
	this._handler = handler;
	this._time = time * 1000 | 0;
	this._args = args;
	this._cnt = 0;
	this._rpt = 1;
};
sirius_tools_Delayer.__name__ = ["sirius","tools","Delayer"];
sirius_tools_Delayer.create = function(handler,time,args,thisObj) {
	return new sirius_tools_Delayer(handler,time,args,thisObj);
};
sirius_tools_Delayer.prototype = {
	call: function(repeats) {
		if(repeats != null) this._rpt = repeats;
		if(this._id == null) {
			this._id = "t" + sirius_tools_Key.COUNTER();
			sirius_tools_Delayer._tks[Std.string(this._id)] = this;
		}
		this._tid = haxe_Timer.delay($bind(this,this._tick),this._time);
		this._tid.run();
		return this;
	}
	,cancel: function() {
		this._cnt = 0;
		if(this._tid != null) {
			this._tid.stop();
			this._tid = null;
		}
		return this;
	}
	,_tick: function() {
		if(this._handler != null) {
			this._tid = null;
			Reflect.callMethod(this._this,this._handler,this._args);
			if(this._rpt == 0 || ++this._cnt < this._rpt) this.call(); else this._cnt = 0;
		}
	}
	,__class__: sirius_tools_Delayer
};
var sirius_tools_Ticker = $hx_exports.Ticker = function() { };
sirius_tools_Ticker.__name__ = ["sirius","tools","Ticker"];
sirius_tools_Ticker._tickAll = function() {
	sirius_utils_Dice.All(sirius_tools_Ticker._pool,function(p,v) {
		if(v != null) v();
	});
};
sirius_tools_Ticker.init = function() {
	sirius_tools_Ticker.stop();
	var t = sirius_tools_Ticker._tickAll;
	sirius_tools_Ticker._uid = setInterval(t,33);
};
sirius_tools_Ticker.stop = function() {
	var uid = sirius_tools_Ticker._uid;
	clearInterval(uid);
};
sirius_tools_Ticker.add = function(handler) {
	if(handler == null) return;
	var iof;
	var x = handler;
	iof = HxOverrides.indexOf(sirius_tools_Ticker._pool,x,0);
	if(iof == -1) sirius_tools_Ticker._pool[sirius_tools_Ticker._pool.length] = handler;
};
sirius_tools_Ticker.remove = function(handler) {
	if(handler == null) return;
	var iof;
	var x = handler;
	iof = HxOverrides.indexOf(sirius_tools_Ticker._pool,x,0);
	if(iof != -1) sirius_tools_Ticker._pool.splice(iof,1);
};
sirius_tools_Ticker.delay = function(handler,time,args) {
	return sirius_tools_Delayer.create(handler,time,args);
};
var sirius_transitions_Animator = $hx_exports.Animator = function() { };
sirius_transitions_Animator.__name__ = ["sirius","transitions","Animator"];
sirius_transitions_Animator.available = function() {
	if(sirius_transitions_Animator.tweenObject == null && window.Tween != null || window.TweenMax != null || window.TweenLite != null) sirius_transitions_Animator.tweenObject = window.Tween || window.TweenMax || window.TweenLite;
	return sirius_transitions_Animator.tweenObject != null;
};
sirius_transitions_Animator.get = function(o) {
	if(o != null && js_Boot.__instanceof(o,sirius_dom_IDisplay)) return o.element; else return o;
};
sirius_transitions_Animator.call = function(time,handler,params,scope,frame) {
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.delayedCall(time,handler,params,scope,frame); else return null;
};
sirius_transitions_Animator.all = function(o,act) {
	if(act == null) act = false;
	if(o == null) o = true;
	o = sirius_transitions_Animator.get(o);
	if(sirius_transitions_Animator.available()) {
		if(o == true) return sirius_transitions_Animator.tweenObject.getAllTweens(act); else if(o != null) return sirius_transitions_Animator.tweenObject.getTweensOf(o,act); else return [];
	} else return [];
};
sirius_transitions_Animator.stop = function(o,child) {
	if(child == null) child = false;
	if(o == null) o = true;
	o = sirius_transitions_Animator.get(o);
	if(sirius_transitions_Animator.available()) {
		if(o == true) return sirius_transitions_Animator.tweenObject.killAll(); else if(o != null) {
			if(child) return sirius_transitions_Animator.tweenObject.killChildTweensOf(o); else return sirius_transitions_Animator.tweenObject.killTweensOf(o);
		} else return null;
	} else return null;
};
sirius_transitions_Animator.pause = function() {
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.pauseAll(); else return null;
};
sirius_transitions_Animator.resume = function() {
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.resumeAll(); else return null;
};
sirius_transitions_Animator.isActive = function(o) {
	o = sirius_transitions_Animator.get(o);
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.isTweening(o); else return false;
};
sirius_transitions_Animator.to = function(o,time,transform) {
	o = sirius_transitions_Animator.get(o);
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.to(o,time,transform); else return null;
};
sirius_transitions_Animator.from = function(o,time,transform) {
	o = sirius_transitions_Animator.get(o);
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.from(o,time,transform); else return null;
};
sirius_transitions_Animator.fromTo = function(o,time,transformFrom,transformTo) {
	o = sirius_transitions_Animator.get(o);
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.from(o,time,transformFrom,transformTo); else return null;
};
sirius_transitions_Animator.stagTo = function(o,time,transform,stagger,complete,args,scope) {
	sirius_utils_Dice.All(o,function(p,v) {
		o[p] = sirius_transitions_Animator.get(v);
	});
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.staggerTo(o,time,transform,stagger,complete,args,scope); else return null;
};
sirius_transitions_Animator.stagFrom = function(o,time,transform,stagger,complete,args,scope) {
	sirius_utils_Dice.All(o,function(p,v) {
		o[p] = sirius_transitions_Animator.get(v);
	});
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.staggerFrom(o,time,transform,stagger,complete,args,scope); else return null;
};
sirius_transitions_Animator.stagFromTo = function(o,time,transformFrom,transformTo,stagger,complete,args,scope) {
	sirius_utils_Dice.All(o,function(p,v) {
		o[p] = sirius_transitions_Animator.get(v);
	});
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.staggerFromTo(o,time,transformFrom,transformTo,stagger,complete,args,scope); else return null;
};
sirius_transitions_Animator.timeScale = function(o) {
	if(sirius_transitions_Animator.available()) return sirius_transitions_Animator.tweenObject.globalTimeScale(o); else return 0;
};
sirius_transitions_Animator.set = function(o,transform) {
	o = sirius_transitions_Animator.get(o);
	if(sirius_transitions_Animator.available() && o != null) return sirius_transitions_Animator.tweenObject.set(o,transform); else return null;
};
var sirius_transitions_Ease = $hx_exports.Ease = function() { };
sirius_transitions_Ease.__name__ = ["sirius","transitions","Ease"];
sirius_transitions_Ease._F = function(n) {
	n = window[n];;
	return n != null?{ x : n.easeNone, I : n.easeIn, O : n.easeOut, IO : n.easeInOut, OI : n.easeOutIn}:{ };
};
sirius_transitions_Ease.update = function() {
	sirius_transitions_Ease.LINEAR = sirius_transitions_Ease._F("Linear");
	sirius_transitions_Ease.CIRC = sirius_transitions_Ease._F("Circ");
	sirius_transitions_Ease.CUBIC = sirius_transitions_Ease._F("Cubic");
	sirius_transitions_Ease.QUAD = sirius_transitions_Ease._F("Quad");
	sirius_transitions_Ease.EXPO = sirius_transitions_Ease._F("Expo");
	sirius_transitions_Ease.BACK = sirius_transitions_Ease._F("Back");
	sirius_transitions_Ease.ELASTIC = sirius_transitions_Ease._F("Elastic");
	sirius_transitions_Ease.QUART = sirius_transitions_Ease._F("Quart");
	sirius_transitions_Ease.QUINT = sirius_transitions_Ease._F("Quint");
};
sirius_transitions_Ease.fromString = function(q) {
	var q1 = [];
	var C = Reflect.field(sirius_transitions_Ease,q1[0]);
	var e = null;
	if(C != null) {
		if(q1.length > 1) e = Reflect.field(C,q1[1]);
		if(e == null) e = C.X;
		return e;
	}
	return sirius_transitions_Ease.LINEAR.X;
};
var sirius_transitions_IEasing = function() { };
sirius_transitions_IEasing.__name__ = ["sirius","transitions","IEasing"];
sirius_transitions_IEasing.prototype = {
	__class__: sirius_transitions_IEasing
};
var sirius_transitions_ITween = function() { };
sirius_transitions_ITween.__name__ = ["sirius","transitions","ITween"];
sirius_transitions_ITween.prototype = {
	__class__: sirius_transitions_ITween
};
var sirius_utils_Criptog = function() { };
sirius_utils_Criptog.__name__ = ["sirius","utils","Criptog"];
sirius_utils_Criptog.encodeBase64 = function(q) {
	if(!(typeof(q) == "string")) q = JSON.stringify(q);
	return haxe_crypto_Base64.encode(haxe_io_Bytes.ofString(q));
};
sirius_utils_Criptog.decodeBase64 = function(q,json) {
	var r = haxe_crypto_Base64.decode(q).toString();
	if(json && r.length > 1) return JSON.parse(r); else return r;
};
var sirius_utils_Filler = $hx_exports.sru.utils.Filler = function() { };
sirius_utils_Filler.__name__ = ["sirius","utils","Filler"];
sirius_utils_Filler._apply = function(path,content,data) {
	if(data == null) content = content.split("{{" + path + "}}").join(""); else if(typeof(data) == "number" || typeof(data) == "string" || typeof(data) == "boolean" || ((data | 0) === data)) content = content.split("{{" + path + "}}").join(data); else {
		if(path != null && path != "") path = path + "."; else path = "";
		sirius_utils_Dice.All(data,function(p,v) {
			content = sirius_utils_Filler._apply(path + p,content,v);
		});
	}
	return content;
};
sirius_utils_Filler.to = function(value,data,sufix) {
	var r = "";
	if((data instanceof Array) && data.__enum__ == null) sirius_utils_Dice.All(data,function(p,v) {
		v["%i"] = p;
		r += sirius_utils_Filler._apply(sufix,value,v);
		Reflect.deleteField(v,"%i");
	}); else r = sirius_utils_Filler._apply(sufix,value,data);
	return r;
};
var sirius_utils_IDiceRoll = function() { };
sirius_utils_IDiceRoll.__name__ = ["sirius","utils","IDiceRoll"];
sirius_utils_IDiceRoll.prototype = {
	__class__: sirius_utils_IDiceRoll
};
var sirius_utils_ITable = function() { };
sirius_utils_ITable.__name__ = ["sirius","utils","ITable"];
sirius_utils_ITable.prototype = {
	__class__: sirius_utils_ITable
};
var sirius_utils_Pixel = $hx_exports.utils.Pixel = function() { };
sirius_utils_Pixel.__name__ = ["sirius","utils","Pixel"];
sirius_utils_Pixel.isAvailable = function() {
	return window.extended != null ? window.extended.CreatePixel != null : false;
};
sirius_utils_Pixel.Create = function(color,opacity) {
	var img = new sirius_dom_Img();
	if(sirius_utils_Pixel.isAvailable()) {
		var f = window.extended.CreatePixel;
		img.fit(1,1);
		img.src(f(color,opacity));
	}
	return img;
};
var sirius_utils_SearchTag = $hx_exports.SearchTag = function(tags) {
	tags = [];
	this.add(tags);
};
sirius_utils_SearchTag.__name__ = ["sirius","utils","SearchTag"];
sirius_utils_SearchTag.from = function(value) {
	if(!js_Boot.__instanceof(value,sirius_utils_SearchTag)) value = new sirius_utils_SearchTag(value);
	return value;
};
sirius_utils_SearchTag.convert = function(f,condense,cCase) {
	if(cCase == null) cCase = false;
	if(condense == null) condense = true;
	f = Std.string(f);
	if(condense) f = f.split(" ").join("");
	if(!cCase) f = f.toLowerCase();
	if(!sirius_utils_SearchTag._R) {
		sirius_utils_Dice.Values(sirius_utils_SearchTag._M,function(v) {
			sirius_utils_SearchTag._M.push([v[0].toUpperCase(),v[1].toUpperCase()]);
		});
		sirius_utils_SearchTag._R = true;
	}
	var i = 0;
	var l = sirius_utils_SearchTag._M.length;
	while(i < l) {
		f = f.split(sirius_utils_SearchTag._M[i][0]).join(sirius_utils_SearchTag._M[i][1]);
		++i;
	}
	return f;
};
sirius_utils_SearchTag.prototype = {
	_tag: function() {
		return "|" + this.tags.join("|") + "|";
	}
	,add: function(values) {
		var _g = this;
		if((values instanceof Array) && values.__enum__ == null) values = values; else values = [values];
		sirius_utils_Dice.Values(values,function(v) {
			v = sirius_utils_SearchTag.convert(v,true,false);
			var iof = Lambda.indexOf(_g.tags,v);
			if(iof == -1) _g.tags[_g.tags.length] = v;
		});
	}
	,remove: function(values) {
		var _g = this;
		values = sirius_utils_SearchTag.from(values).tags;
		sirius_utils_Dice.Values(values,function(v) {
			var iof = Lambda.indexOf(_g.tags,v);
			if(iof != -1) _g.tags.splice(iof,1);
		});
	}
	,compare: function(values,equality) {
		if(equality == null) equality = false;
		var tag = this._tag();
		values = sirius_utils_SearchTag.from(values).tags;
		var total = values.length;
		var count = sirius_utils_Dice.Values(values,function(v) {
			if(equality) return tag.indexOf("|" + v + "|") == -1; else return tag.indexOf(v) != -1;
		}).keys;
		return _$UInt_UInt_$Impl_$.toFloat(count) / _$UInt_UInt_$Impl_$.toFloat(total) * 100;
	}
	,equal: function(values) {
		var tag = this._tag();
		values = sirius_utils_SearchTag.from(values).tags;
		return sirius_utils_Dice.Values(values,function(v) {
			return tag.indexOf("|" + v + "|") == -1;
		}).completed;
	}
	,contains: function(values) {
		var tag = this._tag();
		values = sirius_utils_SearchTag.from(values).tags;
		return !sirius_utils_Dice.Values(values,function(v) {
			return tag.indexOf(v) != -1;
		}).completed;
	}
	,__class__: sirius_utils_SearchTag
};
var sirius_utils_Table = $hx_exports.sru.utils.Table = function(q,t) {
	if(q == null) q = "*";
	var _g = this;
	this.content = [];
	this.elements = [];
	if(q != "NULL_TABLE") {
		if(q != null) {
			if(t == null) t = window.document;
			var result = t.querySelectorAll(q);
			var element = null;
			if(result.length > 0) sirius_utils_Dice.Count(0,result.length,function(i,j,k) {
				element = result.item(i);
				_g.content[_g.content.length] = sirius_tools_Utils.displayFrom(element);
				_g.elements[_g.elements.length] = element;
				return null;
			}); else sirius_Sirius.log("TABLE(" + q + ") : NO RESULT",12,2);
		} else sirius_Sirius.log("TABLE(QUERY,TARGET) : NULL QUERY_SELECTOR",10,3);
	}
};
sirius_utils_Table.__name__ = ["sirius","utils","Table"];
sirius_utils_Table.__interfaces__ = [sirius_utils_ITable];
sirius_utils_Table.empty = function() {
	return new sirius_utils_Table("NULL_TABLE");
};
sirius_utils_Table.prototype = {
	contains: function(q) {
		var t = sirius_utils_Table.empty();
		var i = 0;
		this.each(function(v) {
			if(v.element.innerHTML.indexOf(q) != -1) {
				t.content[i] = v;
				t.elements[i] = v.element;
				++i;
			}
		});
		return t;
	}
	,flush: function(handler,complete) {
		sirius_utils_Dice.Values(this.content,handler,complete);
		return this;
	}
	,first: function() {
		return this.content[0];
	}
	,last: function() {
		return this.content[this.content.length - 1];
	}
	,obj: function(i) {
		return this.content[i];
	}
	,css: function(styles) {
		sirius_utils_Dice.Call(this.content,"css",[styles]);
		return this;
	}
	,attribute: function(name,value) {
		this.each(function(v) {
			v.attribute(name,value);
		});
		return this;
	}
	,attributes: function(values) {
		this.each(function(v) {
			v.attributes(values);
		});
		return this;
	}
	,show: function() {
		return this.each(function(v) {
			v.show();
		});
	}
	,hide: function() {
		return this.each(function(v) {
			v.hide();
		});
	}
	,remove: function() {
		return this.each(function(v) {
			v.remove();
		});
	}
	,cursor: function(value) {
		return this.each(function(v) {
			v.cursor(value);
		});
	}
	,detach: function() {
		return this.each(function(v) {
			v.detach();
		});
	}
	,attach: function() {
		return this.each(function(v) {
			v.attach();
		});
	}
	,pin: function() {
		return this.each(function(v) {
			v.pin();
		});
	}
	,clear: function(fast) {
		return this.each(function(v) {
			v.clear(fast);
		});
	}
	,addTo: function(target) {
		return this.each(function(v) {
			v.addTo(target);
		});
	}
	,addToBody: function() {
		return this.each(function(v) {
			v.addToBody();
		});
	}
	,length: function() {
		return this.content.length;
	}
	,each: function(handler) {
		sirius_utils_Dice.Values(this.content,handler);
		return this;
	}
	,call: function(method,args) {
		sirius_utils_Dice.Call(this.content,method,args);
		return this;
	}
	,on: function(name,handler,mode) {
		this.each(function(v) {
			v.events.auto(name,handler,mode);
		});
		return this;
	}
	,merge: function(tables) {
		var t = sirius_utils_Table.empty();
		if(tables == null) tables = [];
		tables[tables.length] = this;
		sirius_utils_Dice.Values(tables,function(v) {
			t.content = t.content.concat(v.content);
			t.elements = t.elements.concat(v.elements);
		});
		return t;
	}
	,onWheel: function(handler,mode) {
		return this.on("wheel",handler,mode);
	}
	,onCopy: function(handler,mode) {
		return this.on("copy",handler,mode);
	}
	,onCut: function(handler,mode) {
		return this.on("cut",handler,mode);
	}
	,onPaste: function(handler,mode) {
		return this.on("paste",handler,mode);
	}
	,onAbort: function(handler,mode) {
		return this.on("abort",handler,mode);
	}
	,onBlur: function(handler,mode) {
		return this.on("blur",handler,mode);
	}
	,onFocusIn: function(handler,mode) {
		return this.on("focusin",handler,mode);
	}
	,onFocusOut: function(handler,mode) {
		return this.on("focusout",handler,mode);
	}
	,onCanPlay: function(handler,mode) {
		return this.on("canplay",handler,mode);
	}
	,onCanPlayThrough: function(handler,mode) {
		return this.on("canplaythrough",handler,mode);
	}
	,onChange: function(handler,mode) {
		return this.on("change",handler,mode);
	}
	,onClick: function(handler,mode) {
		return this.on("click",handler,mode);
	}
	,onContextMenu: function(handler,mode) {
		return this.on("contextmenu",handler,mode);
	}
	,onDblClick: function(handler,mode) {
		return this.on("dblclick",handler,mode);
	}
	,onDrag: function(handler,mode) {
		return this.on("drag",handler,mode);
	}
	,onDragEnd: function(handler,mode) {
		return this.on("dragend",handler,mode);
	}
	,onDragEnter: function(handler,mode) {
		return this.on("dragenter",handler,mode);
	}
	,onDragLeave: function(handler,mode) {
		return this.on("dragleave",handler,mode);
	}
	,onDragOver: function(handler,mode) {
		return this.on("dragover",handler,mode);
	}
	,onDragStart: function(handler,mode) {
		return this.on("dragstart",handler,mode);
	}
	,onDrop: function(handler,mode) {
		return this.on("drop",handler,mode);
	}
	,onDurationChange: function(handler,mode) {
		return this.on("durationchange",handler,mode);
	}
	,onEmptied: function(handler,mode) {
		return this.on("emptied",handler,mode);
	}
	,onEnded: function(handler,mode) {
		return this.on("ended",handler,mode);
	}
	,onInput: function(handler,mode) {
		return this.on("input",handler,mode);
	}
	,onInvalid: function(handler,mode) {
		return this.on("invalid",handler,mode);
	}
	,onKeyDown: function(handler,mode) {
		return this.on("keydown",handler,mode);
	}
	,onKeyPress: function(handler,mode) {
		return this.on("keypress",handler,mode);
	}
	,onKeyUp: function(handler,mode) {
		return this.on("keyup",handler,mode);
	}
	,onLoad: function(handler,mode) {
		return this.on("load",handler,mode);
	}
	,onLoadedData: function(handler,mode) {
		return this.on("loadeddata",handler,mode);
	}
	,onLoadedMetadata: function(handler,mode) {
		return this.on("loadedmetadata",handler,mode);
	}
	,onLoadStart: function(handler,mode) {
		return this.on("loadstart",handler,mode);
	}
	,onMouseDown: function(handler,mode) {
		return this.on("mousedown",handler,mode);
	}
	,onMouseEnter: function(handler,mode) {
		return this.on("mouseenter",handler,mode);
	}
	,onMouseLeave: function(handler,mode) {
		return this.on("mouseleave",handler,mode);
	}
	,onMouseMove: function(handler,mode) {
		return this.on("mousemove",handler,mode);
	}
	,onMouseOut: function(handler,mode) {
		return this.on("mouseout",handler,mode);
	}
	,onMouseOver: function(handler,mode) {
		return this.on("mouseover",handler,mode);
	}
	,onMouseUp: function(handler,mode) {
		return this.on("mouseup",handler,mode);
	}
	,onPause: function(handler,mode) {
		return this.on("pause",handler,mode);
	}
	,onPlay: function(handler,mode) {
		return this.on("play",handler,mode);
	}
	,onPlaying: function(handler,mode) {
		return this.on("playing",handler,mode);
	}
	,onProgress: function(handler,mode) {
		return this.on("progress",handler,mode);
	}
	,onRateChange: function(handler,mode) {
		return this.on("ratechange",handler,mode);
	}
	,onReset: function(handler,mode) {
		return this.on("reset",handler,mode);
	}
	,onScroll: function(handler,mode) {
		return this.on("scroll",handler,mode);
	}
	,onSeeked: function(handler,mode) {
		return this.on("seeked",handler,mode);
	}
	,onSeeking: function(handler,mode) {
		return this.on("seeking",handler,mode);
	}
	,onSelect: function(handler,mode) {
		return this.on("select",handler,mode);
	}
	,onShow: function(handler,mode) {
		return this.on("show",handler,mode);
	}
	,onStalled: function(handler,mode) {
		return this.on("stalled",handler,mode);
	}
	,onSubmit: function(handler,mode) {
		return this.on("submit",handler,mode);
	}
	,onSuspend: function(handler,mode) {
		return this.on("suspend",handler,mode);
	}
	,onTimeUpdate: function(handler,mode) {
		return this.on("timeupdate",handler,mode);
	}
	,onVolumeChange: function(handler,mode) {
		return this.on("volumechange",handler,mode);
	}
	,onWaiting: function(handler,mode) {
		return this.on("waiting",handler,mode);
	}
	,onPointerCancel: function(handler,mode) {
		return this.on("pointercancel",handler,mode);
	}
	,onPointerDown: function(handler,mode) {
		return this.on("pointerdown",handler,mode);
	}
	,onPointerUp: function(handler,mode) {
		return this.on("pointerup",handler,mode);
	}
	,onPointerMove: function(handler,mode) {
		return this.on("pointermove",handler,mode);
	}
	,onPointerOut: function(handler,mode) {
		return this.on("pointerout",handler,mode);
	}
	,onPointerOver: function(handler,mode) {
		return this.on("pointerover",handler,mode);
	}
	,onPointerEnter: function(handler,mode) {
		return this.on("pointerenter",handler,mode);
	}
	,onPointerLeave: function(handler,mode) {
		return this.on("pointerleave",handler,mode);
	}
	,onGotPointerCapture: function(handler,mode) {
		return this.on("gotpointercapture",handler,mode);
	}
	,onLostPointerCapture: function(handler,mode) {
		return this.on("lostpointercapture",handler,mode);
	}
	,onPointerLockChange: function(handler,mode) {
		return this.on("pointerlockchange",handler,mode);
	}
	,onPointerLockError: function(handler,mode) {
		return this.on("pointerlockerror",handler,mode);
	}
	,onError: function(handler,mode) {
		return this.on("error",handler,mode);
	}
	,onTouchStart: function(handler,mode) {
		return this.on("touchstart",handler,mode);
	}
	,onTouchEnd: function(handler,mode) {
		return this.on("touchend",handler,mode);
	}
	,onTouchMove: function(handler,mode) {
		return this.on("touchmove",handler,mode);
	}
	,onTouchCancel: function(handler,mode) {
		return this.on("touchcancel",handler,mode);
	}
	,onVisibility: function(handler,mode) {
		return this.on("visibility",handler,mode);
	}
	,__class__: sirius_utils_Table
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
function $arrayPushClosure(a) { return function(x) { a.push(x); }; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.__name__ = ["Array"];
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {}
var q = window.jQuery;
var js = js || {}
js.JQuery = q;
var ArrayBuffer = (Function("return typeof ArrayBuffer != 'undefined' ? ArrayBuffer : null"))() || js_html_compat_ArrayBuffer;
if(ArrayBuffer.prototype.slice == null) ArrayBuffer.prototype.slice = js_html_compat_ArrayBuffer.sliceImpl;
var DataView = (Function("return typeof DataView != 'undefined' ? DataView : null"))() || js_html_compat_DataView;
var Uint8Array = (Function("return typeof Uint8Array != 'undefined' ? Uint8Array : null"))() || js_html_compat_Uint8Array._new;
haxe_crypto_Base64.CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
haxe_crypto_Base64.BYTES = haxe_io_Bytes.ofString(haxe_crypto_Base64.CHARS);
haxe_io_FPHelper.i64tmp = (function($this) {
	var $r;
	var x = new haxe__$Int64__$_$_$Int64(0,0);
	$r = x;
	return $r;
}(this));
js_Boot.__toStr = {}.toString;
js_html_compat_Uint8Array.BYTES_PER_ELEMENT = 1;
sirius_modules_Loader.FILES = { };
sirius_modules_ModLib.CACHE = { };
sirius_seo_SEOTool.WEBSITE = 1;
sirius_seo_SEOTool.BREADCRUMBS = 2;
sirius_seo_SEOTool.PRODUCT = 4;
sirius_seo_SEOTool.ORGANIZATION = 8;
sirius_seo_SEOTool.PERSON = 16;
sirius_seo_SEOTool.SEARCH = 32;
sirius_Sirius._loglevel = 12;
sirius_Sirius._initialized = false;
sirius_Sirius._loaded = false;
sirius_Sirius.resources = new sirius_modules_ModLib();
sirius_Sirius.domain = new sirius_net_Domain();
sirius_Sirius.loader = new sirius_modules_Loader();
sirius_Sirius.agent = new sirius_tools_Agent();
sirius_Sirius.seo = new sirius_seo_SEOTool();
sirius_Sirius.plugins = { };
sirius_css_CSSGroup.SOF = "/*SOF*/@media";
sirius_css_CSSGroup.EOF = "}/*EOF*/";
sirius_css_CSSGroup.MEDIA_PR = "print";
sirius_css_CSSGroup.MEDIA_XS = "(min-width:1px) and (max-width:767px)";
sirius_css_CSSGroup.MEDIA_SM = "(min-width:768px) and (max-width:1000px)";
sirius_css_CSSGroup.MEDIA_MD = "(min-width:1001px) and (max-width:1169px)";
sirius_css_CSSGroup.MEDIA_LG = "(min-width:1170px)";
sirius_dom_Display._DATA = new sirius_data_DataSet();
sirius_dom_Document.__scroll__ = { x : 0, y : 0};
sirius_dom_Document.__cursor__ = { x : 0, y : 0};
sirius_tools_Utils._typeOf = { a : sirius_dom_A, applet : sirius_dom_Applet, area : sirius_dom_Area, audio : sirius_dom_Audio, b : sirius_dom_B, base : sirius_dom_Base, body : sirius_dom_Body, br : sirius_dom_BR, button : sirius_dom_Button, canvas : sirius_dom_Canvas, caption : sirius_dom_Caption, col : sirius_dom_Col, content : sirius_dom_Content, datalist : sirius_dom_DataList, dir : sirius_dom_Dir, div : sirius_dom_Div, display : sirius_dom_Display, display3d : sirius_dom_Display3D, dl : sirius_dom_DL, document : sirius_dom_Document, embed : sirius_dom_Embed, fieldset : sirius_dom_FieldSet, font : sirius_dom_Font, form : sirius_dom_Form, frame : sirius_dom_Frame, frameset : sirius_dom_FrameSet, h1 : sirius_dom_H1, h2 : sirius_dom_H2, h3 : sirius_dom_H3, h4 : sirius_dom_H4, h5 : sirius_dom_H5, h6 : sirius_dom_H6, head : sirius_dom_Head, hr : sirius_dom_HR, html : sirius_dom_Html, i : sirius_dom_I, iframe : sirius_dom_IFrame, img : sirius_dom_Img, input : sirius_dom_Input, label : sirius_dom_Label, legend : sirius_dom_Legend, li : sirius_dom_LI, link : sirius_dom_Link, map : sirius_dom_Map, media : sirius_dom_Media, menu : sirius_dom_Menu, meta : sirius_dom_Meta, meter : sirius_dom_Meter, mod : sirius_dom_Mod, object : sirius_dom_Object, ol : sirius_dom_OL, optgroup : sirius_dom_OptGroup, option : sirius_dom_Option, output : sirius_dom_Output, p : sirius_dom_P, param : sirius_dom_Param, picture : sirius_dom_Picture, pre : sirius_dom_Pre, progress : sirius_dom_Progress, quote : sirius_dom_Quote, script : sirius_dom_Script, select : sirius_dom_Select, shadow : sirius_dom_Shadow, source : sirius_dom_Source, span : sirius_dom_Span, sprite : sirius_dom_Sprite, sprite3d : sirius_dom_Sprite3D, style : sirius_dom_Style, table : sirius_dom_Table, td : sirius_dom_TD, text : sirius_dom_Text, textarea : sirius_dom_TextArea, thead : sirius_dom_Thead, title : sirius_dom_Title, tr : sirius_dom_TR, track : sirius_dom_Track, ul : sirius_dom_UL, video : sirius_dom_Video};
sirius_tools_Key._counter = 0;
sirius_tools_Key.TABLE = "abcdefghijklmnopqrstuvwxyz0123456789";
sirius_css_Automator._scx = "#xs#sm#md#lg#pr#";
sirius_css_Automator.css = new sirius_css_CSSGroup();
sirius_css_AutomatorRules._KEYS = { 'void' : { value : "\"\"", verifier : sirius_css_AutomatorRules.commonKey}, aliceblue : { value : "#f0f8ff", verifier : sirius_css_AutomatorRules.commonKey}, antiquewhite : { value : "#faebd7", verifier : sirius_css_AutomatorRules.commonKey}, aqua : { value : "#00ffff", verifier : sirius_css_AutomatorRules.commonKey}, aquamarine : { value : "#7fffd4", verifier : sirius_css_AutomatorRules.commonKey}, azure : { value : "#f0ffff", verifier : sirius_css_AutomatorRules.commonKey}, beige : { value : "#f5f5dc", verifier : sirius_css_AutomatorRules.commonKey}, bisque : { value : "#ffe4c4", verifier : sirius_css_AutomatorRules.commonKey}, black : { value : "#000000", verifier : sirius_css_AutomatorRules.commonKey}, blanchedalmond : { value : "#ffebcd", verifier : sirius_css_AutomatorRules.commonKey}, blue : { value : "#0000ff", verifier : sirius_css_AutomatorRules.commonKey}, blueviolet : { value : "#8a2be2", verifier : sirius_css_AutomatorRules.commonKey}, brown : { value : "#a52a2a", verifier : sirius_css_AutomatorRules.commonKey}, burlywood : { value : "#deb887", verifier : sirius_css_AutomatorRules.commonKey}, cadetblue : { value : "#5f9ea0", verifier : sirius_css_AutomatorRules.commonKey}, chartreuse : { value : "#7fff00", verifier : sirius_css_AutomatorRules.commonKey}, chocolate : { value : "#d2691e", verifier : sirius_css_AutomatorRules.commonKey}, coral : { value : "#ff7f50", verifier : sirius_css_AutomatorRules.commonKey}, cornflowerblue : { value : "#6495ed", verifier : sirius_css_AutomatorRules.commonKey}, cornsilk : { value : "#fff8dc", verifier : sirius_css_AutomatorRules.commonKey}, crimson : { value : "#dc143c", verifier : sirius_css_AutomatorRules.commonKey}, cyan : { value : "#00ffff", verifier : sirius_css_AutomatorRules.commonKey}, darkblue : { value : "#00008b", verifier : sirius_css_AutomatorRules.commonKey}, darkcyan : { value : "#008b8b", verifier : sirius_css_AutomatorRules.commonKey}, darkgoldenrod : { value : "#b8860b", verifier : sirius_css_AutomatorRules.commonKey}, darkgray : { value : "#a9a9a9", verifier : sirius_css_AutomatorRules.commonKey}, darkgreen : { value : "#006400", verifier : sirius_css_AutomatorRules.commonKey}, darkkhaki : { value : "#bdb76b", verifier : sirius_css_AutomatorRules.commonKey}, darkmagenta : { value : "#8b008b", verifier : sirius_css_AutomatorRules.commonKey}, darkolivegreen : { value : "#556b2f", verifier : sirius_css_AutomatorRules.commonKey}, darkorange : { value : "#ff8c00", verifier : sirius_css_AutomatorRules.commonKey}, darkorchid : { value : "#9932cc", verifier : sirius_css_AutomatorRules.commonKey}, darkred : { value : "#8b0000", verifier : sirius_css_AutomatorRules.commonKey}, darksalmon : { value : "#e9967a", verifier : sirius_css_AutomatorRules.commonKey}, darkseagreen : { value : "#8fbc8f", verifier : sirius_css_AutomatorRules.commonKey}, darkslateblue : { value : "#483d8b", verifier : sirius_css_AutomatorRules.commonKey}, darkslategray : { value : "#2f4f4f", verifier : sirius_css_AutomatorRules.commonKey}, darkturquoise : { value : "#00ced1", verifier : sirius_css_AutomatorRules.commonKey}, darkviolet : { value : "#9400d3", verifier : sirius_css_AutomatorRules.commonKey}, deeppink : { value : "#ff1493", verifier : sirius_css_AutomatorRules.commonKey}, deepskyblue : { value : "#00bfff", verifier : sirius_css_AutomatorRules.commonKey}, dimgray : { value : "#696969", verifier : sirius_css_AutomatorRules.commonKey}, dodgerblue : { value : "#1e90ff", verifier : sirius_css_AutomatorRules.commonKey}, firebrick : { value : "#b22222", verifier : sirius_css_AutomatorRules.commonKey}, floralwhite : { value : "#fffaf0", verifier : sirius_css_AutomatorRules.commonKey}, forestgreen : { value : "#228b22", verifier : sirius_css_AutomatorRules.commonKey}, fuchsia : { value : "#ff00ff", verifier : sirius_css_AutomatorRules.commonKey}, gainsboro : { value : "#dcdcdc", verifier : sirius_css_AutomatorRules.commonKey}, ghostwhite : { value : "#f8f8ff", verifier : sirius_css_AutomatorRules.commonKey}, gold : { value : "#ffd700", verifier : sirius_css_AutomatorRules.commonKey}, goldenrod : { value : "#daa520", verifier : sirius_css_AutomatorRules.commonKey}, gray : { value : "#808080", verifier : sirius_css_AutomatorRules.commonKey}, green : { value : "#008000", verifier : sirius_css_AutomatorRules.commonKey}, greenyellow : { value : "#adff2f", verifier : sirius_css_AutomatorRules.commonKey}, honeydew : { value : "#f0fff0", verifier : sirius_css_AutomatorRules.commonKey}, hotpink : { value : "#ff69b4", verifier : sirius_css_AutomatorRules.commonKey}, indianred : { value : "#cd5c5c", verifier : sirius_css_AutomatorRules.commonKey}, indigo : { value : "#4b0082", verifier : sirius_css_AutomatorRules.commonKey}, ivory : { value : "#fffff0", verifier : sirius_css_AutomatorRules.commonKey}, khaki : { value : "#f0e68c", verifier : sirius_css_AutomatorRules.commonKey}, lavender : { value : "#e6e6fa", verifier : sirius_css_AutomatorRules.commonKey}, lavenderblush : { value : "#fff0f5", verifier : sirius_css_AutomatorRules.commonKey}, lawngreen : { value : "#7cfc00", verifier : sirius_css_AutomatorRules.commonKey}, lemonchiffon : { value : "#fffacd", verifier : sirius_css_AutomatorRules.commonKey}, lightblue : { value : "#add8e6", verifier : sirius_css_AutomatorRules.commonKey}, lightcoral : { value : "#f08080", verifier : sirius_css_AutomatorRules.commonKey}, lightcyan : { value : "#e0ffff", verifier : sirius_css_AutomatorRules.commonKey}, lightgoldenrodyellow : { value : "#fafad2", verifier : sirius_css_AutomatorRules.commonKey}, lightgray : { value : "#d3d3d3", verifier : sirius_css_AutomatorRules.commonKey}, lightgreen : { value : "#90ee90", verifier : sirius_css_AutomatorRules.commonKey}, lightpink : { value : "#ffb6c1", verifier : sirius_css_AutomatorRules.commonKey}, lightsalmon : { value : "#ffa07a", verifier : sirius_css_AutomatorRules.commonKey}, lightseagreen : { value : "#20b2aa", verifier : sirius_css_AutomatorRules.commonKey}, lightskyblue : { value : "#87cefa", verifier : sirius_css_AutomatorRules.commonKey}, lightslategray : { value : "#778899", verifier : sirius_css_AutomatorRules.commonKey}, lightsteelblue : { value : "#b0c4de", verifier : sirius_css_AutomatorRules.commonKey}, lightyellow : { value : "#ffffe0", verifier : sirius_css_AutomatorRules.commonKey}, lime : { value : "#00ff00", verifier : sirius_css_AutomatorRules.commonKey}, limegreen : { value : "#32cd32", verifier : sirius_css_AutomatorRules.commonKey}, linen : { value : "#faf0e6", verifier : sirius_css_AutomatorRules.commonKey}, magenta : { value : "#ff00ff", verifier : sirius_css_AutomatorRules.commonKey}, maroon : { value : "#800000", verifier : sirius_css_AutomatorRules.commonKey}, mediumaquamarine : { value : "#66cdaa", verifier : sirius_css_AutomatorRules.commonKey}, mediumblue : { value : "#0000cd", verifier : sirius_css_AutomatorRules.commonKey}, mediumorchid : { value : "#ba55d3", verifier : sirius_css_AutomatorRules.commonKey}, mediumpurple : { value : "#9370db", verifier : sirius_css_AutomatorRules.commonKey}, mediumseagreen : { value : "#3cb371", verifier : sirius_css_AutomatorRules.commonKey}, mediumslateblue : { value : "#7b68ee", verifier : sirius_css_AutomatorRules.commonKey}, mediumspringgreen : { value : "#00fa9a", verifier : sirius_css_AutomatorRules.commonKey}, mediumturquoise : { value : "#48d1cc", verifier : sirius_css_AutomatorRules.commonKey}, mediumvioletred : { value : "#c71585", verifier : sirius_css_AutomatorRules.commonKey}, midnightblue : { value : "#191970", verifier : sirius_css_AutomatorRules.commonKey}, mintcream : { value : "#f5fffa", verifier : sirius_css_AutomatorRules.commonKey}, mistyrose : { value : "#ffe4e1", verifier : sirius_css_AutomatorRules.commonKey}, moccasin : { value : "#ffe4b5", verifier : sirius_css_AutomatorRules.commonKey}, navajowhite : { value : "#ffdead", verifier : sirius_css_AutomatorRules.commonKey}, navy : { value : "#000080", verifier : sirius_css_AutomatorRules.commonKey}, oldlace : { value : "#fdf5e6", verifier : sirius_css_AutomatorRules.commonKey}, olive : { value : "#808000", verifier : sirius_css_AutomatorRules.commonKey}, olivedrab : { value : "#6b8e23", verifier : sirius_css_AutomatorRules.commonKey}, orange : { value : "#ffa500", verifier : sirius_css_AutomatorRules.commonKey}, orangered : { value : "#ff4500", verifier : sirius_css_AutomatorRules.commonKey}, orchid : { value : "#da70d6", verifier : sirius_css_AutomatorRules.commonKey}, palegoldenrod : { value : "#eee8aa", verifier : sirius_css_AutomatorRules.commonKey}, palegreen : { value : "#98fb98", verifier : sirius_css_AutomatorRules.commonKey}, paleturquoise : { value : "#afeeee", verifier : sirius_css_AutomatorRules.commonKey}, palevioletred : { value : "#db7093", verifier : sirius_css_AutomatorRules.commonKey}, papayawhip : { value : "#ffefd5", verifier : sirius_css_AutomatorRules.commonKey}, peachpuff : { value : "#ffdab9", verifier : sirius_css_AutomatorRules.commonKey}, peru : { value : "#cd853f", verifier : sirius_css_AutomatorRules.commonKey}, pink : { value : "#ffc0cb", verifier : sirius_css_AutomatorRules.commonKey}, plum : { value : "#dda0dd", verifier : sirius_css_AutomatorRules.commonKey}, powderblue : { value : "#b0e0e6", verifier : sirius_css_AutomatorRules.commonKey}, purple : { value : "#800080", verifier : sirius_css_AutomatorRules.commonKey}, rebeccapurple : { value : "#663399", verifier : sirius_css_AutomatorRules.commonKey}, red : { value : "#ff0000", verifier : sirius_css_AutomatorRules.commonKey}, rosybrown : { value : "#bc8f8f", verifier : sirius_css_AutomatorRules.commonKey}, royalblue : { value : "#4169e1", verifier : sirius_css_AutomatorRules.commonKey}, saddlebrown : { value : "#8b4513", verifier : sirius_css_AutomatorRules.commonKey}, salmon : { value : "#fa8072", verifier : sirius_css_AutomatorRules.commonKey}, sandybrown : { value : "#f4a460", verifier : sirius_css_AutomatorRules.commonKey}, seagreen : { value : "#2e8b57", verifier : sirius_css_AutomatorRules.commonKey}, seashell : { value : "#fff5ee", verifier : sirius_css_AutomatorRules.commonKey}, sienna : { value : "#a0522d", verifier : sirius_css_AutomatorRules.commonKey}, silver : { value : "#c0c0c0", verifier : sirius_css_AutomatorRules.commonKey}, skyblue : { value : "#87ceeb", verifier : sirius_css_AutomatorRules.commonKey}, slateblue : { value : "#6a5acd", verifier : sirius_css_AutomatorRules.commonKey}, slategray : { value : "#708090", verifier : sirius_css_AutomatorRules.commonKey}, snow : { value : "#fffafa", verifier : sirius_css_AutomatorRules.commonKey}, springgreen : { value : "#00ff7f", verifier : sirius_css_AutomatorRules.commonKey}, steelblue : { value : "#4682b4", verifier : sirius_css_AutomatorRules.commonKey}, tan : { value : "#d2b48c", verifier : sirius_css_AutomatorRules.commonKey}, teal : { value : "#008080", verifier : sirius_css_AutomatorRules.commonKey}, thistle : { value : "#d8bfd8", verifier : sirius_css_AutomatorRules.commonKey}, tomato : { value : "#ff6347", verifier : sirius_css_AutomatorRules.commonKey}, turquoise : { value : "#40e0d0", verifier : sirius_css_AutomatorRules.commonKey}, violet : { value : "#ee82ee", verifier : sirius_css_AutomatorRules.commonKey}, wheat : { value : "#f5deb3", verifier : sirius_css_AutomatorRules.commonKey}, white : { value : "#ffffff", verifier : sirius_css_AutomatorRules.commonKey}, whitesmoke : { value : "#f5f5f5", verifier : sirius_css_AutomatorRules.commonKey}, yellow : { value : "#ffff00", verifier : sirius_css_AutomatorRules.commonKey}, yellowgreen : { value : "#9acd32", verifier : sirius_css_AutomatorRules.commonKey}, transparent : { value : "background-color:transparent", verifier : sirius_css_AutomatorRules.commonKey}, t : { value : "top", verifier : sirius_css_AutomatorRules.numericKey}, b : { value : "bottom", verifier : sirius_css_AutomatorRules.numericKey}, l : { value : "left", verifier : sirius_css_AutomatorRules.numericKey}, r : { value : "right", verifier : sirius_css_AutomatorRules.numericKey}, m : { value : "middle", verifier : sirius_css_AutomatorRules.commonKey}, j : { value : "justify", verifier : sirius_css_AutomatorRules.commonKey}, c : { value : "center", verifier : sirius_css_AutomatorRules.commonKey}, n : { value : "none", verifier : sirius_css_AutomatorRules.commonKey}, pc : { value : "%", verifier : sirius_css_AutomatorRules.commonKey}, line : { value : "line", verifier : sirius_css_AutomatorRules.pushKey}, i : { value : " !important", verifier : sirius_css_AutomatorRules.commonKey}, marg : { value : "margin", verifier : sirius_css_AutomatorRules.numericKey}, padd : { value : "padding", verifier : sirius_css_AutomatorRules.numericKey}, bord : { value : "border", verifier : sirius_css_AutomatorRules.numericKey}, w : { value : "width", verifier : sirius_css_AutomatorRules.valueKey}, h : { value : "height", verifier : sirius_css_AutomatorRules.valueKey}, o : { value : "outline", verifier : sirius_css_AutomatorRules.valueKey}, disp : { value : "display", verifier : sirius_css_AutomatorRules.valueKey}, vert : { value : "vertical-align", verifier : sirius_css_AutomatorRules.valueKey}, block : { value : "block", verifier : sirius_css_AutomatorRules.commonKey}, 'inline' : { value : "inline", verifier : sirius_css_AutomatorRules.appendKey}, bg : { value : "background", verifier : sirius_css_AutomatorRules.numericKey}, txt : { value : "", verifier : sirius_css_AutomatorRules.textKey}, decor : { value : "", verifier : sirius_css_AutomatorRules.valueKey}, sub : { value : "sub", verifier : sirius_css_AutomatorRules.commonKey}, sup : { value : "super", verifier : sirius_css_AutomatorRules.commonKey}, pos : { value : "position", verifier : sirius_css_AutomatorRules.valueKey}, abs : { value : "absolute", verifier : sirius_css_AutomatorRules.commonKey}, rel : { value : "relative", verifier : sirius_css_AutomatorRules.commonKey}, fix : { value : "fixed", verifier : sirius_css_AutomatorRules.commonKey}, pull : { value : "float", verifier : sirius_css_AutomatorRules.valueKey}, 'float' : { value : "float", verifier : sirius_css_AutomatorRules.valueKey}, over : { value : "overflow", verifier : sirius_css_AutomatorRules.valueKey}, hid : { value : "", verifier : sirius_css_AutomatorRules.commonKey}, scroll : { value : "scroll", verifier : sirius_css_AutomatorRules.scrollKey}, x : { value : "x", verifier : sirius_css_AutomatorRules.scrollKey}, y : { value : "y", verifier : sirius_css_AutomatorRules.scrollKey}, z : { value : "z-index", verifier : sirius_css_AutomatorRules.valueKey}, bold : { value : "font-weight:bold", verifier : sirius_css_AutomatorRules.commonKey}, regular : { value : "font-weight:regular", verifier : sirius_css_AutomatorRules.commonKey}, underline : { value : "font-weight:underline", verifier : sirius_css_AutomatorRules.commonKey}, italic : { value : "font-weight:italic", verifier : sirius_css_AutomatorRules.commonKey}, thin : { value : "font-weight:100", verifier : sirius_css_AutomatorRules.commonKey}, upcase : { value : "font-transform:uppercase", verifier : sirius_css_AutomatorRules.commonKey}, locase : { value : "font-transform:lowercase", verifier : sirius_css_AutomatorRules.commonKey}, curs : { value : "cursor", verifier : sirius_css_AutomatorRules.valueKey}, pointer : { value : "pointer", verifier : sirius_css_AutomatorRules.valueKey}, loading : { value : "loading", verifier : sirius_css_AutomatorRules.valueKey}, arial : { value : "font-family:arial", verifier : sirius_css_AutomatorRules.commonKey}, verdana : { value : "font-family:verdana", verifier : sirius_css_AutomatorRules.commonKey}, tahoma : { value : "font-family:tahoma", verifier : sirius_css_AutomatorRules.commonKey}, lucida : { value : "font-family:lucida", verifier : sirius_css_AutomatorRules.commonKey}, georgia : { value : "font-family:georgia", verifier : sirius_css_AutomatorRules.commonKey}, trebuchet : { value : "font-family:trebuchet", verifier : sirius_css_AutomatorRules.commonKey}, table : { value : "table", verifier : sirius_css_AutomatorRules.appendKey}, tab : { value : "table", verifier : sirius_css_AutomatorRules.appendKey}, cell : { value : "cell", verifier : sirius_css_AutomatorRules.commonKey}, rad : { value : "radius", verifier : sirius_css_AutomatorRules.valueKey}, solid : { value : "solid", verifier : sirius_css_AutomatorRules.commonKey}, dashed : { value : "dashed", verifier : sirius_css_AutomatorRules.commonKey}, 'double' : { value : "double", verifier : sirius_css_AutomatorRules.commonKey}, dotted : { value : "dotted", verifier : sirius_css_AutomatorRules.commonKey}, alpha : { value : "opacity", verifier : sirius_css_AutomatorRules.alphaKey}, hidden : { value : "", verifier : sirius_css_AutomatorRules.displayKey}, visible : { value : "", verifier : sirius_css_AutomatorRules.displayKey}, shadow : { value : "", verifier : sirius_css_AutomatorRules.shadowKey}, mosaic : { value : "", verifier : sirius_css_AutomatorRules.mosaicKey}};
sirius_css_XCSS.enabled = false;
sirius_tools_BitIO.P01 = 1;
sirius_tools_BitIO.P02 = 2;
sirius_tools_BitIO.P03 = 4;
sirius_tools_BitIO.P04 = 8;
sirius_tools_BitIO.P05 = 16;
sirius_tools_BitIO.P06 = 32;
sirius_tools_BitIO.P07 = 64;
sirius_tools_BitIO.P08 = 128;
sirius_tools_BitIO.P09 = 256;
sirius_tools_BitIO.P10 = 512;
sirius_tools_BitIO.P11 = 1024;
sirius_tools_BitIO.P12 = 2048;
sirius_tools_BitIO.P13 = 4096;
sirius_tools_BitIO.P14 = 8192;
sirius_tools_BitIO.P15 = 16384;
sirius_tools_BitIO.P16 = 32768;
sirius_tools_BitIO.P17 = 65536;
sirius_tools_BitIO.P18 = 131072;
sirius_tools_BitIO.P19 = 262144;
sirius_tools_BitIO.P20 = 524288;
sirius_tools_BitIO.P21 = 1048576;
sirius_tools_BitIO.P22 = 2097152;
sirius_tools_BitIO.P23 = 4194304;
sirius_tools_BitIO.P24 = 8388608;
sirius_tools_BitIO.P25 = 16777216;
sirius_tools_BitIO.P26 = 33554432;
sirius_tools_BitIO.P27 = 67108864;
sirius_tools_BitIO.P28 = 134217728;
sirius_tools_BitIO.P29 = 268435456;
sirius_tools_BitIO.P30 = 536870912;
sirius_tools_BitIO.P31 = 1073741824;
sirius_tools_BitIO.P32 = -2147483648;
sirius_tools_BitIO.X = [sirius_tools_BitIO.Unwrite,sirius_tools_BitIO.Write,sirius_tools_BitIO.Toggle];
sirius_tools_Delayer.CALL = setTimeout;
sirius_tools_Delayer.CLEAR = clearTimeout;
sirius_tools_Delayer._tks = { };
sirius_tools_Ticker._pool = [];
sirius_utils_SearchTag._M = [["á","a"],["ã","a"],["â","a"],["à","a"],["ê","e"],["é","e"],["è","e"],["î","i"],["í","i"],["ì","i"],["õ","o"],["ô","o"],["ó","o"],["ò","o"],["ú","u"],["ù","u"],["û","u"],["ç","c"]];
sirius_utils_SearchTag._R = false;
sirius_Sirius.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : exports);

package jotun.tools;
import haxe.Json;
import haxe.Log;
import jotun.math.Point;
import jotun.math.RNG;
import jotun.utils.IColor;
import jotun.utils.IDiceRoll;

#if js

	import js.html.DOMRect;
	import js.Browser;
	import js.Syntax;
	import js.lib.Error;
	import js.html.Attr;
	import js.html.Blob;
	import js.html.Element;
	import js.html.File;
	import js.html.NamedNodeMap;
	import jotun.css.XCode;
	import jotun.css.CSSGroup;
	import jotun.dom.A;
	import jotun.dom.Area;
	import jotun.dom.Audio;
	import jotun.dom.B;
	import jotun.dom.Base;
	import jotun.dom.Body;
	import jotun.dom.BR;
	import jotun.dom.Button;
	import jotun.dom.Canvas;
	import jotun.dom.Caption;
	import jotun.dom.Col;
	import jotun.dom.DataList;
	import jotun.dom.Dialog;
	import jotun.dom.Display;
	import jotun.dom.Div;
	import jotun.dom.Document;
	import jotun.dom.Embed;
	import jotun.dom.FieldSet;
	import jotun.dom.Form;
	import jotun.dom.H1;
	import jotun.dom.H2;
	import jotun.dom.H3;
	import jotun.dom.H4;
	import jotun.dom.H5;
	import jotun.dom.H6;
	import jotun.dom.Head;
	import jotun.dom.HR;
	import jotun.dom.Html;
	import jotun.dom.I;
	import jotun.dom.IDisplay;
	import jotun.dom.IFrame;
	import jotun.dom.Img;
	import jotun.dom.Input;
	import jotun.dom.Label;
	import jotun.dom.Legend;
	import jotun.dom.LI;
	import jotun.dom.Link;
	import jotun.dom.Map;
	import jotun.dom.Media;
	import jotun.dom.Meta;
	import jotun.dom.Meter;
	import jotun.dom.Mod;
	import jotun.dom.Object;
	import jotun.dom.OL;
	import jotun.dom.OptGroup;
	import jotun.dom.Option;
	import jotun.dom.Output;
	import jotun.dom.P;
	import jotun.dom.Param;
	import jotun.dom.Picture;
	import jotun.dom.Pre;
	import jotun.dom.Progress;
	import jotun.dom.Quote;
	import jotun.dom.Script;
	import jotun.dom.Select;
	import jotun.dom.Source;
	import jotun.dom.Span;
	import jotun.dom.Style;
	import jotun.dom.Svg;
	import jotun.dom.Text;
	import jotun.dom.TextArea;
	import jotun.dom.Title;
	import jotun.dom.Track;
	import jotun.dom.UL;
	import jotun.dom.Video;
	import jotun.idb.WebDB;
	import jotun.idb.WebDBAssist;
	import jotun.idb.WebDBTable;
	import jotun.math.JMath;
	import jotun.utils.SearchTag;
	import jotun.utils.Singularity;
	import jotun.signals.Observer;
#end

import jotun.gaming.actions.Events;
import jotun.gaming.dataform.Pulsar;
import jotun.gaming.dataform.SparkWriter;
import jotun.gaming.dataform.Spark;
import jotun.serial.Packager;
import jotun.logical.Flag;
import jotun.tools.LoFlag;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Utils")
class Utils{

	#if js
		public static function matchMedia(value:String):Bool {
			return Browser.window.matchMedia(value).matches;
		}
		
		public static function screenOrientation():String {
			return matchMedia("(orientation: portrait)") ? "portrait" : "landscape";
		}
		
		public static function viewportWidth():Int {
			return js.Syntax.code("window.innerWidth || document.documentElement.clientWidth");
		}
		
		public static function viewportHeight():Int {
			return js.Syntax.code("window.innerHeight || document.documentElement.clientHeight");
		}
		
		static public function screenInfo():String {
			return screenOrientation() + "(" + viewportWidth() + "x" + viewportHeight() + ")";
		}
		
		/** @private */
		static private var _typeOf:Dynamic = { 
			A:A, AREA:Area, AUDIO:Audio,
			B:B, BASE:Base, BODY:Body, BR:BR, BUTTON:Button,
			CANVAS:Canvas, CAPTION:Caption, COL:Col,
			DATALIST:DataList, DIV:Div, DISPLAY:Display, DOCUMENT:Document,
			EMBED:Embed,
			FIELDSET:FieldSet, FORM:Form,
			H1:H1, H2:H2, H3:H3, H4:H4, H5:H5, H6:H6, HEAD:Head, HR:HR, HTML:Html,
			I:I, IFRAME:IFrame, IMG:Img, INPUT:Input,
			LABEL:Label, LEGEND:Legend, LI:LI, LINK:Link,
			MAP:Map, MEDIA:Media, META:Meta, METER:Meter, MOD:Mod,
			OBJECT:Object, OL:OL, OPTGROUP:OptGroup, OPTION:Option, OUTPUT:Output,
			P:P, PARAM:Param, PICTURE:Picture, PRE:Pre, PROGRESS:Progress,
			QUOTE:Quote,
			SCRIPT:Script, SELECT:Select, SOURCE:Source, SPAN:Span, STYLE:Style, SVG:Svg,
			TEXT:Text, TEXTAREA:TextArea, TITLE:Title, TRACK:Track,
			UL:UL,
			VIDEO:Video,
		};
		
		/**
		 * Convert an element to Jotun DOM object
		 * Note that converted objects need to be disposed if unused.
		 * @param	t
		 * @return
		 */
		static public function displayFrom(t:Element):IDisplay {
			var id:UInt = null;
			var type:String = null;
			if (t.hasAttribute != null) {
				id = (cast t.getAttribute('jtn-id')) * 1;
				if (id == null) {
					type = cast t.getAttribute('jtn-dom');
					if (type == null){
						type = t.tagName.toUpperCase();
						t.setAttribute('jtn-dom', type);
					}else{
						type = type.toUpperCase();
					}
				} else {
					return Display.fromGC(id);
				}
				
			}
			
			var OC:Dynamic = Reflect.field(_typeOf, type);
			if (OC == null){
				return new Display(t);
			}else{
				return js.Syntax.construct(OC, t);
			}
		}
		
		/**
		 * Fast version of displayFrom, always return a IDisplay from that object
		 * Note: The display can't be converted to any other Jotun DOM object, only if disposed before the new selection.
		 * @param	t
		 * @return
		 */
		static public function getDisplay(t:Element):IDisplay {
			var id:UInt = t.hasAttribute != null && t.hasAttribute('jtn-id') ? Std.parseInt(t.getAttribute('jtn-id')) : null;
			if (id != null){
				return Display.fromGC(id);
			}
			return new Display(t);
		}
		
		/**
		 * Convert any number format to String, same as value.toString(rad)
		 * @param	value
		 * @param	rad
		 * @return
		 */
		static public function intToString(value:Dynamic, ?rad:Int):String {
			if (Std.isOfType(value, String)) {
				value = Std.parseInt(value);
			}
			value = value >> 0;
			return Reflect.callMethod(value, value.toString, rad != null ? [rad] : []);
		}
		
		/**
		 * 
		 * @param	display
		 * @return
		 */
		static public function getAttributes(display:Display):Dynamic {
			var attr:NamedNodeMap = display.element.attributes;
			var data:Dynamic = {};
			if(attr != null){
				var i:UInt = 0;
				var len:UInt = attr.length;
				while (i < len){
					var a:Attr = attr.item(i);
					Reflect.setField(data, a.name, a.value);
					++i;
				}
			}
			return data;
		}
		
		static public function fileToURL(file:Blob):String {
			return (cast Browser.window).URL.createObjectURL(file);
		}
		
		static public function freeze(data:Dynamic):Void {
			Syntax.code('Object.freeze({0})', data);
		}
		
		/**
		 * Get a real position of a element
		 * @param	target
		 */
		static public function getPosition(target:Element):Point {
			var a:DOMRect = Jotun.document.body.getBounds();
			var b:DOMRect = target.getBoundingClientRect();
			return new Point(b.left - a.left, b.top - a.top);
		}
		
	#elseif php
		
	#end
	
	
	static public function getMin(values:Array<Float>, ?filter:Float->Bool):Float {
		var r:Float = null;
		Dice.Values(values, function(i:Float){
			if (filter == null || filter(i))
				if (i < r || r == null) r = i;
		});
		return r;
	}
	
	static public function getMax(values:Array<Float>, ?filter:Float->Bool):Float {
		var r:Float = null;
		Dice.Values(values, function(i:Float){
			if (filter == null || filter(i))
				if (i > r || r == null) r = i;
		});
		return r;
	}
	
	static public function getQueryParams(value:String):Dynamic {
		var params:Dynamic = {};
		if (value != null){
			value = value.split('+').join(' ').split('?').pop();
		} else{
			return params;
		}
		Dice.Values(value.split('&'), function(v:String){
			var data:Array<Dynamic> = v.split('=');
			if (data.length > 1){
				Reflect.setField(params, StringTools.urlDecode(data[0]), StringTools.urlDecode(data[1]));
			}
		});
		return params;
	}

	static public function createQueryParams(url:String, value:Dynamic, ?encode:Bool = true):String {
		var q:Array<String> = [];
		Dice.All(value, function(p:String, v:Dynamic):Void {
			if (Std.isOfType(v, String) || Std.isOfType(v, Float) || Std.isOfType(v, Bool)){
				q[q.length] = p + '=' + (encode ?StringTools.urlEncode(v) : v);
			}else if (Std.isOfType(v, Array)){
				q[q.length] = p + '=' + (encode ? StringTools.urlEncode(v.join(';')) : v.join(';'));
			}
		});
		if (url == null){
			url = "";
		}
		return url + (url.indexOf('?') == -1 ? '?' : '&') + q.join("&");
	}
	
	static public function replaceQuery(url:String, params:Dynamic){
		var current:Dynamic = getQueryParams(url);
		Dice.All(params, function(p:String, v:Dynamic){
			Reflect.setField(current, p, v);
		});
		return createQueryParams(url.split('?')[0], current);
	}
	
	/**
	 * Remove white and null values from array
	 * @param	path
	 */
	static public function clearArray(path:Array<String>, ?filter:Dynamic):Array<Dynamic> {
		var copy:Array<String> = [];
		Dice.Values(path, function(v:Dynamic) {
			if (v != null && v != "" && (filter == null || filter(v))) {
				copy[copy.length] = v;
			}
		});
		return copy;
	}
	
	static public function trimm(value:String):String {
		return value.split('\r').join('').split('\n').join('').split('\t').join('').split(' ').join('');
	}
	
	
	/**
	 * Convert a value to String or Json string
	 * @param	o
	 * @param	json
	 * @return
	 */
	static public function toString(o:Dynamic, ?json:Bool):String {
		return json == true ? Json.stringify(o) : Std.string(o);
	}
	
	/**
	 * data.split('{').join('').split('}').join('<br/>')
	 * @param	o
	 * @return
	 */
	static public function toJtnString(o:Dynamic, type:Bool = true, ?html:Bool):String {
		return _jstring(o, '', '', type, html);
	}
	
	static private function _codex(i:String, n:String, c:String, p:String, v:Dynamic, t:Bool, h:Bool, r:Bool):String {
		return (h ? '<div class="prop"><span>' : '') + i + p + (t ? (h ? '<span class="' + c + '">' : '') + ":" + n + (h ? '</span>' : '') : '') + "=" + (h && r ? '</span><span class="' + c + ' value">' : '') + v + (h && r ? '</span>' : '') + (h ? '</div>' : "\n");
	}
	
	static private function _codexWrap(i:String, ls:String, rs:String, v:Dynamic, t:Bool, h:Bool):String {
		return ls + (h ? '<br/>' : "\n") + _jstring(v, i, '', t, h) + i +rs;
	}
	
	/** @private */
	static public function _jstring(o:Dynamic, i:String, b:String, t:Bool, h:Bool):String {
		if (h){
			b += '<div class="block">';
		}
		i = i + (h ? '&nbsp;&nbsp;&nbsp;&nbsp;' : '\t');
		Dice.All(o, function(p:String, v:Dynamic) {
			if (v == null){
				b += i + p + ":* = null\n";
			}
			else if (Std.isOfType(v, String)){
				b += _codex(i, 'String', 'string', p, v, t, h, true);
			}
			else if (Std.isOfType(v, Bool)){
				b += _codex(i, 'Bool', 'bool', p, v, t, h, true);
			}
			else if (Std.isOfType(v, Int)){
				b += _codex(i, 'Int', 'int', p, v, t, h, true);
			}
			else if (Std.isOfType(v, Float)){
				b += _codex(i, 'Float', 'float', p, v, t, h, true);
			}
			else if (Std.isOfType(v, Array)){
				b += _codex(i,  'Array(' + v.length + ')', 'array', p,  _codexWrap(i, '[', ']',v, t, h) , t, h, false);
			} else{
				b += _codex(i,  'Object', 'object', p,  _codexWrap(i, '{', '}',v, t, h) , t, h, false);
			}
		});
		if (h){
			b += '</div>';
		}
		return b;
	}
	
	/**
	 * Check if a value is !null or/and length>0 if a string
	 * @param	o
	 * @return
	 */
	static public function isValid(o:Dynamic, ?len:UInt = 0):Bool {
		if (o != null && o != '') {
			if (o != 'null' && Reflect.hasField(o, 'length'))
				return o.length > len;
			else
				return o != 0 && o != false;
		}
		return false;
	}
	
	/**
	 * Check if a value is !null or/and length>0 if a string
	 * @param	o
	 * @return
	 */
	static public function isValidAll(o:Array<Dynamic>):Bool {
		var q:IDiceRoll = Dice.Values(o, function(v:Dynamic){
			return !isValid(v);
		});
		return q.completed;
	}
	
	/**
	 * 
	 * @param	o
	 * @param	alt
	 * @return
	 */
	static public function getValidOne(o:Dynamic, alt:Dynamic):Dynamic {
		return isValid(o) ? o : alt;
	}
	
	/**
	 * Class name of the object
	 * @param	o
	 * @return
	 */
	static public function typeof(o:Dynamic):String {
		var name:String;
		if(o != null){
			try {
				return o.__proto__.__class__.__name__.join('.');
			}catch (e:Dynamic) {}
			try {
				return Type.getClassName(Type.getClass(o));
			}catch (e:Dynamic) {}
		}
		return null;
		
	}
	
	static public function boolean(q:Dynamic):Bool {
		if (Std.isOfType(q, String)){
			return q == "1" || q == "true" || q == "yes" || q == "accept" || q == "ok" || q == "selected" || q == "y";
		}else{
			return q == true || q > 0;
		}
	}
	
	static public function money(val:Dynamic, s:String = '$', a:String = ',', b:String = '.'):String {
		var r = '';
		val *= 100;
		if(val > 99){
			val = '' + Std.int(val);
			var i:Int = val.length;
			var c:Int = 0;
			while (i-- > 0){
				r = val.substr(i, 1) + r;
				if(i > 0){
					if (c == 1){
						r = b + r;
					}else if (c > 1 && (c+2) % 3 == 0){
						r = a + r;
					}
				}else if ( c < 3){
					r = '0' + (c == 1 ? '.' : '') + r;
				}
				++c;
			}
		}else{
			r = '0' + b + (val < 10 ? '0' : '') + val;
		}
		return s + r;
	}
	
	static public function paramsOf(o:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(o, function(p:String, v:Dynamic){
			if(isValid(v) && !isFunction(v)){
				if (Std.isOfType(v, Float)){
					v = Std.string(v);
				}else if (!Std.isOfType(v, String)){
					v = Json.stringify(v);
				}
				r[r.length] = p + '=' + StringTools.urlEncode(v);
			}
		});
		return r.join('&');
	}
	
	public static function And(data:Array<Dynamic>, separator:String=', ', and:String=' & '):String {
		if (data.length > 1){
			var q:Array<Dynamic> = data.splice(0, data.length - 1);
			return q.join(separator) + and + data.join('');
		}else{
			return data.join('');
		}
	}
	
	public static function prefix(value:String, length:Int, q :String):String {
		while (value.length < length){
			value = q + value;
		}
		return value;
	}
	
	public static function sufix(value:String, length:Int, q :String):String {
		while (value.length < length){
			value = value + q;
		}
		return value;
	}
	
	public static function rnToBr(value:String):String {
		return value.split('\r\n').join('<br/>').split('\r').join('<br/>').split('\n').join('<br/>');
	}
	
	/**
	 * #AARRGGBB OR #RRGGBB
	 * @param	hex
	 * @return
	 */
	public static function color(hex:String):IColor {
		var cI:Int = hex.length == 10 ? 3 : (hex.length == 9 ? 2 : 0);
		return cast {
			a: hex.length == 9 ? Std.parseInt("0x" + hex.substr(1, 2)) : 255,
			r: Std.parseInt("0x" + hex.substr(1 + cI, 2)),
			g: Std.parseInt("0x" + hex.substr(3 + cI, 2)),
			b: Std.parseInt("0x" + hex.substr(5 + cI, 2)),
		};
	}
	
	public static function colorToCss(color:IColor, ?multiply:Float):String {
		return 'rgb(' + Std.int(color.r * multiply) + ' ' + Std.int(color.g * multiply) + ' ' + Std.int(color.b * multiply) + '/' + Utils.toFixed((color.a * multiply) / 255, 2) + ')';
	}
	
	#if php 
	
		static public function toFixed(n:Float, i:Int, s:String = '.', t:String = ''):String {
			return php.Syntax.codeDeref('number_format({0},{1},{2},{3})', n, i, s, t);
		}
		
		static public function isFunction(o:Dynamic):Bool {
			return php.Syntax.codeDeref("is_callable({0})", o);
		}
		
	#elseif js
	
		static public function toFixed(n:Float, i:Int, s:String = '.'):String {
			var a:String = (cast n).toFixed(i);
			if (s != '.'){
				a = a.split('.').join('s');
			}
			return a;
		}
		
		static public function isFunction(o:Dynamic):Bool {
			return Reflect.isFunction(o);
		}
		
		static public function stackTrace():String {
			try {
				throw new Error();
			}catch (e:Dynamic){
				e = e.stack.split('\r\n').join('\r').split('\n').join('\r').split('\r');
				Dice.All(e, function(p:Int, v:String){
					if (v.indexOf('Function.jotun_tools_Utils.stackTrace') != -1){
						e.splice(p, 1);
						return true;
					}else{
						return false;
					}
				});
				e[0] = 'STACK TRACE';
				return e.join("\n	↑ ");
			}
		}
		
		static public function throwError():Void {
			throw new Error();
		}
		
		static public function extendClass(a:Dynamic, b:Dynamic):Dynamic {
			if (b.prototype.isPrototypeOf(a)){
				a.prototype = Syntax.code("Object").create(b.prototype);
			}
			return a;
		}
		
	#end
	
}
package jotun.tools;
import haxe.Json;
import haxe.Log;
import jotun.data.DataSet;
import jotun.utils.IDiceRoll;

#if js

	import js.Lib;
	import js.Browser;
	import js.html.Attr;
	import js.html.Blob;
	import js.html.Element;
	import js.html.File;
	import js.html.NamedNodeMap;
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
	import jotun.draw.Book;
	import jotun.draw.Paper;
	
#end

import jotun.serial.IOTools;
import jotun.tools.Flag;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Utils")
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
		
		public static function mathLocation(uri:String):Bool {
			return Browser.window.location.href.indexOf(uri) != -1;
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
				id = (cast t.getAttribute('jotun-id')) * 1;
				if (id == null) {
					type = cast t.getAttribute('jotun-dom');
					if (type == null){
						type = t.tagName.toUpperCase();
						t.setAttribute('jotun-dom', type);
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
			var id:UInt = t.hasAttribute != null && t.hasAttribute('jotun-id') ? Std.parseInt(t.getAttribute('jotun-id')) : null;
			if (id != null)
				return Display.fromGC(id);
			return new Display(t);
		}
		
		/**
		 * Convert any number format to String, same as value.toString(rad)
		 * @param	value
		 * @param	rad
		 * @return
		 */
		static public function intToString(value:Dynamic, ?rad:Int):String {
			if (Std.is(value, String)) value = Std.parseInt(value);
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
		
		static public function fileToURL(file:File):String {
			return (cast Browser.window).URL.createObjectURL(file);
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
		if(value.indexOf('?') > 0)
			value = value.split('+').join(' ').split('?')[1];
		else
			return params;
		Dice.Values(value.split('&'), function(v:String){
			var data:Array<Dynamic> = v.split('=');
			if (data.length > 1){
				Reflect.setField(params, StringTools.urlDecode(data[0]), StringTools.urlDecode(data[1]));
			}
		});
		return params;
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
	static public function sruString(o:Dynamic):String {
		return _sruFly(o, '', '');
	}
	
	/** @private */
	static public function _sruFly(o:Dynamic, i:String, b:String):String {
		i = i + '  ';
		Dice.All(o, function(p:String, v:Dynamic) {
			if (v == null){
				b += i + p + ":* = NULL\r";
			}
			else if (Std.is(v, String)){
				b += i + p + ":String = " + v + "\r";
			}
			else if (Std.is(v, Bool) || v == "true" || v == "false" || v == true || v == false){
				b += i + p + ":Bool = " + v + "\r";
			}
			else if (Std.is(v, Int) || Std.is(v, Float)){
				b += i + p + ":Number = " + v + "\r";
			}
			else if (Std.is(v, Array)){
				b += i + p + ":Array[" + v.length + "]:[\r" + _sruFly(v, i, '') + i + "]\r";
			} else{
				b += i + p + ":Object {\r" + _sruFly(v, i, '') + i + "}\r";
			}
		});
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
	
	static public function isRange(o:Dynamic, min:Int, max:Int):Bool {
		if(o != null){
			if (!Std.is(o, Float)){
				if (Std.is(o, Array) || Std.is(o, String)){
					o = o.length;
				}else{
					return false;
				}
			}
		}else{
			return false;
		}
		if (max == null){
			return o >= min;
		}else if (min == null){
			return o <= max;
		}else{
			return o >= min && o <= max;
		}
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
		return q == true || q == 1 || q == "1" || q == "true" || q == "yes" || q == "accept" || q == "ok" || q == "selected";
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
	
	static public function stdClone(q:Dynamic):Dynamic {
		return Json.parse(Json.stringify(q));
	}
	
	static public function paramsOf(o:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(o, function(p:String, v:Dynamic){
			v = Json.stringify(v);
			r[r.length] = p + '=' + StringTools.urlEncode(v.substr(1, v.length-2));
		});
		return r.join('&');
	}
	
	#if php 
		static public function toFixed(n:Float, i:Int, s:String = '.', t:String = ''):String {
			return untyped __call__('number_format', n, i, s, t);
		}
	#elseif js
		static public function toFixed(n:Float, i:Int, s:String = '.'):String {
			var a:String = (cast n).toFixed(i);
			if (s != '.'){
				a = a.split('.').join('s');
			}
			return a;
		}
	#end
	
}
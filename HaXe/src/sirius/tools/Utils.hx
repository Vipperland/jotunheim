package sirius.tools;
import haxe.Json;
import haxe.Log;

#if js

	import js.Lib;
	import js.Browser;
	import js.html.Attr;
	import js.html.Element;
	import js.html.NamedNodeMap;
	import sirius.flow.Push;
	import sirius.dom.A;
	import sirius.dom.Area;
	import sirius.dom.Audio;
	import sirius.dom.B;
	import sirius.dom.Base;
	import sirius.dom.Body;
	import sirius.dom.BR;
	import sirius.dom.Button;
	import sirius.dom.Canvas;
	import sirius.dom.Caption;
	import sirius.dom.Col;
	import sirius.dom.Content;
	import sirius.dom.DataList;
	import sirius.dom.Display;
	import sirius.dom.Display3D;
	import sirius.dom.Div;
	import sirius.dom.DL;
	import sirius.dom.Document;
	import sirius.dom.Embed;
	import sirius.dom.FieldSet;
	import sirius.dom.Form;
	import sirius.dom.H1;
	import sirius.dom.H2;
	import sirius.dom.H3;
	import sirius.dom.H4;
	import sirius.dom.H5;
	import sirius.dom.H6;
	import sirius.dom.Head;
	import sirius.dom.HR;
	import sirius.dom.Html;
	import sirius.dom.I;
	import sirius.dom.IDisplay;
	import sirius.dom.IFrame;
	import sirius.dom.Img;
	import sirius.dom.Input;
	import sirius.dom.Label;
	import sirius.dom.Legend;
	import sirius.dom.LI;
	import sirius.dom.Link;
	import sirius.dom.Map;
	import sirius.dom.Media;
	import sirius.dom.Meta;
	import sirius.dom.Meter;
	import sirius.dom.Mod;
	import sirius.dom.Object;
	import sirius.dom.OL;
	import sirius.dom.OptGroup;
	import sirius.dom.Option;
	import sirius.dom.Output;
	import sirius.dom.P;
	import sirius.dom.Param;
	import sirius.dom.Picture;
	import sirius.dom.Pre;
	import sirius.dom.Progress;
	import sirius.dom.Quote;
	import sirius.dom.Script;
	import sirius.dom.Select;
	import sirius.dom.Shadow;
	import sirius.dom.Source;
	import sirius.dom.Span;
	import sirius.dom.Style;
	import sirius.dom.Text;
	import sirius.dom.TextArea;
	import sirius.dom.Thead;
	import sirius.dom.Title;
	import sirius.dom.Track;
	import sirius.dom.UL;
	import sirius.dom.Video;
	
#end

import sirius.serial.IOTools;
import sirius.tools.Flag;
import sirius.utils.Dice;

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
			return untyped __js__("window.innerWidth || document.documentElement.clientWidth");
		}
		
		public static function viewportHeight():Int {
			return untyped __js__("window.innerHeight || document.documentElement.clientHeight");
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
			CANVAS:Canvas, CAPTION:Caption, COL:Col, CONTENT:Content,
			DATALIST:DataList, DIV:Div, DISPLAY:Display, DISPLAY3D:Display3D, DL:DL, DOCUMENT:Document,
			EMBED:Embed,
			FIELDSET:FieldSet, FORM:Form,
			H1:H1, H2:H2, H3:H3, H4:H4, H5:H5, H6:H6, HEAD:Head, HR:HR, HTML:Html,
			I:I, IFRAME:IFrame, IMG:Img, INPUT:Input,
			LABEL:Label, LEGEND:Legend, LI:LI, LINK:Link,
			MAP:Map, MEDIA:Media, META:Meta, METER:Meter, MOD:Mod,
			OBJECT:Object, OL:OL, OPTGROUP:OptGroup, OPTION:Option, OUTPUT:Output,
			P:P, PARAM:Param, PICTURE:Picture, PRE:Pre, PROGRESS:Progress,
			QUOTE:Quote,
			SCRIPT:Script, SELECT:Select, SHADOW:Shadow, SOURCE:Source, SPAN:Span, STYLE:Style,
			TEXT:Text,TEXTAREA:TextArea,THEAD:Thead,TITLE:Title,TRACK:Track,
			UL:UL,
			VIDEO:Video,
		};
		
		/**
		 * Convert an element to Sirius DOM object
		 * Note that converted objects need to be disposed if unused.
		 * @param	t
		 * @return
		 */
		static public function displayFrom(t:Element):IDisplay {
			var id:UInt = null;
			var type:String = null;
			if (t.hasAttribute != null) {
				id = (cast t.getAttribute('sru-id')) * 1;
				if (id == null) {
					type = cast t.getAttribute('sru-dom');
					if (type == null){
						type = t.tagName.toUpperCase();
						t.setAttribute('sru-dom', type);
					}
				} else {
					return Display.fromGC(id);
				}
				
			}
			
			var OC:Dynamic = Reflect.field(_typeOf, type);
			if (OC == null)
				return new Display(t);
			else
				return untyped __js__('new OC(t)');
		}
		
		/**
		 * Fast version of displayFrom, always return a IDisplay from that object
		 * Note: The display can't be converted to any other Sirius DOM object, only if disposed before the new selection.
		 * @param	t
		 * @return
		 */
		static public function getDisplay(t:Element):IDisplay {
			var id:UInt = t.hasAttribute != null && t.hasAttribute('sru-id') ? Std.parseInt(t.getAttribute('sru-id')) : null;
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
			Reflect.setField(params, StringTools.urlDecode(data[0]), StringTools.urlDecode(data[1]));
		});
		return params;
	}

	
	/**
	 * Remove white and null values from array
	 * @param	path
	 */
	static public function clearArray(path:Array<String>, ?filter:Dynamic) {
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
		return _sruFy(o, '', '');
	}
	
	/** @private */
	static public function _sruFy(o:Dynamic, i:String, b:String):String {
		i = i + '  ';
		Dice.All(o, function(p:String, v:Dynamic) {
			if (v == null) 									b += i + p + ":* = NULL\r";
			else if (Std.is(v, String)) 					b += i + p + ":String = " + v + "\r";
			else if(Std.is(v, Bool)) 						b += i + p + ":Bool = " + v + "\r";
			else if(Std.is(v, Int) || Std.is(v, Float)) 	b += i + p + ":Number = " + v + "\r";
			else if (Std.is(v, Array))						b += i + p + ":Array[" + v.length + "]):[\r" + _sruFy(v, i, '') + i + "]\r";
			else											b += i + p + ":Object {\r" + _sruFy(v, i, '') + i + "}\r";
		});
		return b;
	}
	
	/**
	 * Check if a value is !null or/and length>0 if a string
	 * @param	o
	 * @return
	 */
	static public function isValid(o:Dynamic):Bool {
		if (o != null && o != '') {
			if (o != 'null' && Reflect.hasField(o, 'length'))
				return o.length > 0;
			else
				return o != 0 && o != false;
		}
		return false;
	}
	
	/**
	 * 
	 * @param	o
	 * @param	alt
	 * @return
	 */
	static public function isValidAlt(o:Dynamic, alt:Dynamic):Dynamic {
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
		return q == true || q == 1 || q == "1" || q == "true" || q == "yes" || q == "accept";
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
	
}
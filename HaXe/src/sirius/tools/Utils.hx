package sirius.tools;
import haxe.Json;
import haxe.Log;

#if js

	import js.Browser;
	import js.html.Element;
	import sirius.dom.A;
	import sirius.dom.Applet;
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
	import sirius.dom.Dir;
	import sirius.dom.Display;
	import sirius.dom.Display3D;
	import sirius.dom.Div;
	import sirius.dom.DL;
	import sirius.dom.Document;
	import sirius.dom.Embed;
	import sirius.dom.FieldSet;
	import sirius.dom.Font;
	import sirius.dom.Form;
	import sirius.dom.Frame;
	import sirius.dom.FrameSet;
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
	import sirius.dom.Menu;
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
	import sirius.dom.Sprite;
	import sirius.dom.Sprite3D;
	import sirius.dom.Style;
	import sirius.dom.Table;
	import sirius.dom.TD;
	import sirius.dom.Text;
	import sirius.dom.TextArea;
	import sirius.dom.Thead;
	import sirius.dom.Title;
	import sirius.dom.TR;
	import sirius.dom.Track;
	import sirius.dom.UL;
	import sirius.dom.Video;
	
#end

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
			a:A,applet:Applet,area:Area,audio:Audio,
			b:B,base:Base,body:Body,br:BR,
			button:Button,canvas:Canvas,caption:Caption,col:Col,content:Content,
			datalist:DataList,dir:Dir,div:Div,display:Display,display3d:Display3D,dl:DL,document:Document,
			embed:Embed,
			fieldset:FieldSet,font:Font,form:Form,frame:Frame,frameset:FrameSet,
			h1:H1,h2:H2,h3:H3,h4:H4,h5:H5,h6:H6,head:Head,hr:HR,html:Html,
			i:I, iframe:IFrame, img:Img, input:Input,
			label:Label,legend:Legend,li:LI,link:Link,
			map:Map,media:Media,menu:Menu,meta:Meta,meter:Meter,mod:Mod,
			object:Object,ol:OL,optgroup:OptGroup,option:Option,output:Output,
			p:P,param:Param,picture:Picture,pre:Pre,progress:Progress,
			quote:Quote,
			script:Script,select:Select,shadow:Shadow,source:Source,span:Span,sprite:Sprite,sprite3d:Sprite3D,style:Style,
			table:Table,td:TD,text:Text,textarea:TextArea,thead:Thead,title:Title,tr:TR,track:Track,
			ul:UL,
			video:Video
		};
		
		/**
		 * Convert an element to Sirius Display object
		 * @param	t
		 * @return
		 */
		static public function displayFrom(t:Element):IDisplay {
			if (t.nodeType != 1) 
				return new Display(t);
			var OC:Dynamic = Reflect.field(_typeOf, (t.hasAttribute('sru-dom') ? t.getAttribute('sru-dom') : t.tagName).toLowerCase());
			return OC == null ? new Display(t) : untyped __js__('new OC(t)');
		}
	
	#elseif php
	
	
	
	#end
	
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
	 * Check if a value is !null or/and length>0 if a string
	 * @param	o
	 * @return
	 */
	static public function isValid(o:Dynamic):Bool {
		if (o != null) {
			if (Std.is(o, String)) {
				return o.length > 0;
			}else {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Class name of the object
	 * @param	o
	 * @return
	 */
	static public function getClassName(o:Dynamic):String {
		return o != null ? Type.getClassName(Type.getClass(o)) : "null";
	}
	
}
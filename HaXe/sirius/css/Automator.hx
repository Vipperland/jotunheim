package sirius.css;
import css.CSSGroup;
import haxe.Log;
import sirius.Sirius;
import sirius.tools.Delayer;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('Automator')
class Automator {
	
	static private var css:CSSGroup;
		
	static private var _NS:Dynamic = { 
		t:'top',
		b:'botton',
		l:'left',
		r:'right',
		m:'middle',
		c:'center',
		n:'none',
		pc:'%',
		p:'%',
		i:' !important',
		bord:'border',
		marg:'margin',
		padd:'padding',
		line:'line',
		w:'width',
		h:'height',
		o:'outline',
		rad:'radius',
		a:'auto',
		txt:['font-size','color','text-align'],
		bg:'background-color',
		aliceblue:'#f0f8ff',
		antiquewhite:'#faebd7',
		aqua:'#00ffff',
		aquamarine:'#7fffd4',
		azure:'#f0ffff',
		beige:'#f5f5dc',
		bisque:'#ffe4c4',
		black:'#000000',
		blanchedalmond:'#ffebcd',
		blue:'#0000ff',
		blueviolet:'#8a2be2',
		brown:'#a52a2a',
		burlywood:'#deb887',
		cadetblue:'#5f9ea0',
		chartreuse:'#7fff00',
		chocolate:'#d2691e',
		coral:'#ff7f50',
		cornflowerblue:'#6495ed',
		cornsilk:'#fff8dc',
		crimson:'#dc143c',
		cyan:'#00ffff',
		darkblue:'#00008b',
		darkcyan:'#008b8b',
		darkgoldenrod:'#b8860b',
		darkgray:'#a9a9a9',
		darkgreen:'#006400',
		darkkhaki:'#bdb76b',
		darkmagenta:'#8b008b',
		darkolivegreen:'#556b2f',
		darkorange:'#ff8c00',
		darkorchid:'#9932cc',
		darkred:'#8b0000',
		darksalmon:'#e9967a',
		darkseagreen:'#8fbc8f',
		darkslateblue:'#483d8b',
		darkslategray:'#2f4f4f',
		darkturquoise:'#00ced1',
		darkviolet:'#9400d3',
		deeppink:'#ff1493',
		deepskyblue:'#00bfff',
		dimgray:'#696969',
		dodgerblue:'#1e90ff',
		firebrick:'#b22222',
		floralwhite:'#fffaf0',
		forestgreen:'#228b22',
		fuchsia:'#ff00ff',
		gainsboro:'#dcdcdc',
		ghostwhite:'#f8f8ff',
		gold:'#ffd700',
		goldenrod:'#daa520',
		gray:'#808080',
		green:'#008000',
		greenyellow:'#adff2f',
		honeydew:'#f0fff0',
		hotpink:'#ff69b4',
		indianred:'#cd5c5c',
		indigo:'#4b0082',
		ivory:'#fffff0',
		khaki:'#f0e68c',
		lavender:'#e6e6fa',
		lavenderblush:'#fff0f5',
		lawngreen:'#7cfc00',
		lemonchiffon:'#fffacd',
		lightblue:'#add8e6',
		lightcoral:'#f08080',
		lightcyan:'#e0ffff',
		lightgoldenrodyellow:'#fafad2',
		lightgray:'#d3d3d3',
		lightgreen:'#90ee90',
		lightpink:'#ffb6c1',
		lightsalmon:'#ffa07a',
		lightseagreen:'#20b2aa',
		lightskyblue:'#87cefa',
		lightslategray:'#778899',
		lightsteelblue:'#b0c4de',
		lightyellow:'#ffffe0',
		lime:'#00ff00',
		limegreen:'#32cd32',
		linen:'#faf0e6',
		magenta:'#ff00ff',
		maroon:'#800000',
		mediumaquamarine:'#66cdaa',
		mediumblue:'#0000cd',
		mediumorchid:'#ba55d3',
		mediumpurple:'#9370db',
		mediumseagreen:'#3cb371',
		mediumslateblue:'#7b68ee',
		mediumspringgreen:'#00fa9a',
		mediumturquoise:'#48d1cc',
		mediumvioletred:'#c71585',
		midnightblue:'#191970',
		mintcream:'#f5fffa',
		mistyrose:'#ffe4e1',
		moccasin:'#ffe4b5',
		navajowhite:'#ffdead',
		navy:'#000080',
		oldlace:'#fdf5e6',
		olive:'#808000',
		olivedrab:'#6b8e23',
		orange:'#ffa500',
		orangered:'#ff4500',
		orchid:'#da70d6',
		palegoldenrod:'#eee8aa',
		palegreen:'#98fb98',
		paleturquoise:'#afeeee',
		palevioletred:'#db7093',
		papayawhip:'#ffefd5',
		peachpuff:'#ffdab9',
		peru:'#cd853f',
		pink:'#ffc0cb',
		plum:'#dda0dd',
		powderblue:'#b0e0e6',
		purple:'#800080',
		rebeccapurple:'#663399',
		red:'#ff0000',
		rosybrown:'#bc8f8f',
		royalblue:'#4169e1',
		saddlebrown:'#8b4513',
		salmon:'#fa8072',
		sandybrown:'#f4a460',
		seagreen:'#2e8b57',
		seashell:'#fff5ee',
		sienna:'#a0522d',
		silver:'#c0c0c0',
		skyblue:'#87ceeb',
		slateblue:'#6a5acd',
		slategray:'#708090',
		snow:'#fffafa',
		springgreen:'#00ff7f',
		steelblue:'#4682b4',
		tan:'#d2b48c',
		teal:'#008080',
		thistle:'#d8bfd8',
		tomato:'#ff6347',
		turquoise:'#40e0d0',
		violet:'#ee82ee',
		wheat:'#f5deb3',
		white:'#ffffff',
		whitesmoke:'#f5f5f5',
		yellow:'#ffff00',
		yellowgreen:'#9acd32',
		transparent:'transparent',
		disp:'display',
		block:'block',
		"inline":'inline',
		vert:'vertical-align',
		sub:'sub',
		sup:'super',
		pos:'position',
		abs:'absolute',
		rel:'relative',
		pull:'float',
		float:'float',
		over:'overflow',
		scroll:'scroll',
		bold:'font-weight:bold,',
		regular:'font-weight:regular',
		underline:'font-weight:underline',
		italic:'font-weight:italic',
		thin:'font-weight:100',
		upcase:'font-transform:uppercase',
		locase:'font-transform:lowercase',
		curs:'cursor',
		pointer:'pointer',
		loading:'loading',
		arial:'font-family:arial',
		verdana:'font-family:verdana',
		tahoma:'font-family:tahoma',
		lucida:'font-family:lucida',
		georgia:'font-family:georgia',
		trebuchet:'font-family:trebuchet',
		tab:'table',
		cell:'cell',
		solid:'solid',
		dashed:'dashed',
		double:'double',
		dotted:'dotted',
	};
	
	static private var _dev:Bool;
	
	static public function addRules(q:Dynamic):Void {
		Dice.All(q, function(p:String, v:String) {
			Reflect.setField(_NS, p, v);
		});
	}
	
	static public function scan(?dev:Bool = false, ?force:Bool = false):Void {
		Sirius.log("Sirius->Automator::scan[ " + (dev ? "DEBUG_MODE" : "RELEASE_MODE") + (force ? "<!FORCED>" : " (Waiting for DOM)") + " ]", 10, 1);
		_dev = dev;
		if (css == null) {
			css = new CSSGroup();
		}
		if (force) {
			_scanBody();
		}else {
			Sirius.init(function() {
				Sirius.log("Sirius->Automator::status[ SCANNING ]", 10, 1);
				_dev ? _activate() : _scanBody();
				Sirius.log("Sirius->Automator::status[ ...DONE! ]", 10, 1);
			});
		}
	}
	
	static private function _activate():Void {
		_scanBody();
		Delayer.create(_scanBody, 1).call(0);
	}
	
	static private function _scanBody():Void {
		
		var w:Array<String>;
		var q:String = "-xs-sm-md-lg";
		var s:String;
		var m:String;
		var i:Bool;
		var l:Int;
		
		var t:Array<String> = Sirius.document.element.outerHTML.split("class=");
		t.shift();
		
		Dice.Values(t, function(v:String) {
			var i:String = v.substr(0, 1);
			var j:Int = v.indexOf(i, 1);
			if (j > 1) {
				v = v.substring(1, j);
				l = v.length;
				if (l > 0) {
					var c:Array<String> = v.split(" ");
					// XS/SM/MD/LG
					m = q.indexOf(c[c.length - 1]) != -1 ? c.pop() : "";
					//// IMPORTANT
					//i = q.indexOf(c[c.length - 1]) != -1 ? c.pop() == "i" : false;
					// REST OF
					Dice.Values(c, function(v:String) {
						c = v.split("-");
						s = _selector(c, 0, c.length,"");
						
						Log.trace(c + "==" + s);
						//if (s != null && s.indexOf("null") == -1) {
							//css.setSelector("." + v, s, m);
						//}
					});
				}
			}
		});
		
		css.build();
		
	}
	
	static private function _selector(arg:Array<String>, c:Int, l:Int, b:Dynamic):String {
		var p:String = arg[c];
		var v:Dynamic = Reflect.field(_NS, p);
		var r:String = _level(v,0);
		
		if(c > 0){
			v = _color(v, p);
			if (v != null) {
				r = _level(b,1) + v;
			}else {
				v = _measure(v, p);
				if (v != null) {
					r = _level(b,2) + v;
				}
			}
		}
		
		return ++c == l ? r : _selector(arg, c, l, r);
	}
	
	static private function _level(p:Dynamic, l:Int):String {
		/*
		 * 0 = Normal
		 * 1 = Color
		 * 2 = Measure
		 * 3 = Align
		 */
		return Std.is(p, Array) ? p[l] : p;
	}
	
	static private function _align(r:String, x:String):Bool {
		return "ctblr".indexOf(x) != -1;
	}
	
	static private function _color(r:String, x:String):String {
		if (x.substr(0, 1) == "x") {
			r = "#" + x.substr(1, x.length-1);
		}else if (Utils.isValid(r) && r.substr(0, 1) == "#") {
			return r;
		}
		return null;
	}
	
	static private function _measure(r:String, x:String):String {
		if(r == null){
			var l:Int = x.length;
			if (x.substr(l - 2, 2) == "pc") {
				r = x.split("d").join(".").split("pc").join("%");
			}else if (x.substr(l - 1, 1) == "n") {
				r = "-" + x.split("n").join("") + "px";
			}else {
				var n:Int = Std.parseInt(x);
				if (n != null) {
					r = n + "px";
				}
			}
			return r;
		}else {
			return null;
		}
	}
	
	static private function _parse(c:Array<String>, level:Int, x:Array<String>):Array<String> {
		
		var v:String = c[level];
		var r:Dynamic = Reflect.field(_NS, c[level]);
		var j:String = "";
		
		if(r == null){
			if (level > 0) {
				var l:Int = v.length;
				if (v.substr(l - 2, 2) == "pc") {
					r = v.split("d").join(".").split("pc").join("%");
				}else if (v.substr(l - 1, 1) == "n") {
					r = "-" + v.split("n").join("") + "px";
				}else if (v.substr(0, 1) == "x") {
					r = "#" + v.substr(1, l-1);
				}else{
					var x:Int = Std.parseInt(v);
					if (x != null) {
						r = x + "px";
					}else {
						return null;
					}
				}
			}else if(level == 0){
				return null;
			}
		}else if (level == 0 && r != '' && c.length > 1) {
			
			if (Std.is(r, Array)) {
				r = r[0];
				j = "-";
			}
			
			if (v == "txt") {
				if (level == 1) {
					r = 'text';
				}else{
					var cl:String = Reflect.field(_NS, c[1]);
					if (cl != null) {
						if (cl.substr(0, 1) == "#") {
							r = 'color';
						}else if ("lrcj".indexOf(c[1]) != -1) {
							r = 'text-align';
						}
					}
				}
			}else if (v == "bord") {
				var cl:String = Reflect.field(_NS, c[1]);
				if(cl != null && cl.substr(0, 1) == "#") {
					r = 'border-color';
				}else if ("sol,das,dou,dot".indexOf(cl.substr(0, 3)) != -1) {
					r = 'border-style';
				}
			}else if (v == "scroll") {
				var cl:String = Reflect.field(_NS, c[1]);
				if (cl == 'x' || cl == 'y') {
					r = 'overflow-' + cl + ':scroll;overflow-' + (cl == 'x' ? 'y' : 'x') + ':hidden;';
				}
			}
		}
		
		x[x.length] = j + r;
		if (++level != c.length) {
			_parse(c, level, x);
		}
		return x;
	}
	
}
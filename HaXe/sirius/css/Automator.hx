package sirius.css;
import css.CSSGroup;
import haxe.Constraints.Function;
import haxe.Log;
import js.html.Element;
import sirius.css.Automator.IKey;
import sirius.dom.IDisplay;
import sirius.math.ARGB;
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
	
	static private var _scx:String = "#xs#sm#md#lg#";
	
	static private var css:CSSGroup = new CSSGroup();
	
	static public function numericKey(d:Entry, k:IKey, n:IKey):String {
		var v:String = k.entry.value;
		if (n != null && !n.position) {
			if (n.color != null) return v + "-color:";
			if(d.head.key == 'bord') return borderFix(v, d, k, n);
			if (n.measure != null) return v + ":";
			return v + ":";
		}
		return v + (k.index == 0 ? "-" : "");
	}
	
	static public function borderFix(v:String, d:Entry, k:IKey, n:IKey):String {
		if (n.measure != null) return v + "-width:";
		return v + (d.keys[1].key == 'rad' ? '-' : '-style:');
	}
	
	static public function shiftKey(d:Entry, k:IKey, n:IKey):String {
		return "-" + k.entry.value;
	}
	
	static public function commonKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value;
	}
	
	static public function pushKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value + "-";
	}
	
	static public function valueKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value + ":";
	}
	
	static public function appendKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value + (n != null ? "-" : "");
	}
	
	static public function scrollKey(d:Entry, k:IKey, n:IKey):String {
		var v:String = k.entry.value;
		if (d.head.key == 'scroll') {
			if (k.index == 0) return '';
			return "overflow-" + v + ":scroll;overflow-" + (v == 'x'?'y':'x') + ":hidden";
		}
		return commonKey(d, k, n);
	}
	
	static public function shadowKey(d:Entry, k:IKey, n:IKey):String {
		if (d.head == k) {
			d.cancel();
			var i:Bool = d.tail.key == 'i';
			var s:Bool = n.key == 'txt';
			var t:ARGB = new ARGB(d.keys[s ? 2 : 1].color);
			var r:String = "0 1px 0 " + t.range(.7).hex() + ",0 2px 0 " + t.range(.6).hex() + ",0 3px 0 " + t.range(.5).hex() + ",0 4px 0 " + t.range(.4).hex() + ",0 5px 0 " + t.range(.3).hex() + ",0 6px 1px rgba(0,0,0,.1),0 0 5px rgba(0,0,0,.1),0 1px 3px rgba(0,0,0,.3),0 3px 5px rgba(0,0,0,.2),0 5px 10px rgba(0,0,0,.25),0 10px 10px rgba(0,0,0,.2),0 20px 20px rgba(0,0,0,.15);";
			return (s ? 'text-shadow' : 'box-shadow') + ':' + r + (i ? ' !important' : '');
		}
		return 'shadow';
	}
	
	static public function textKey(d:Entry, k:IKey, n:IKey):String {
		if(k.index == 0){
			if (n != null && !n.position) {
				if (n.color != null) return 'color:';
				if (n.measure != null) return 'font-size:';
			}
			return 'text-align:';
		}else {
			return 'text-';
		}
	}
	
	
	/**
	 * RULE TABLE
	 */
	static private var _KEYS:Dynamic = {
		aliceblue:{value:'#f0f8ff',verifier:commonKey},
		antiquewhite:{value:'#faebd7',verifier:commonKey},
		aqua:{value:'#00ffff',verifier:commonKey},
		aquamarine:{value:'#7fffd4',verifier:commonKey},
		azure:{value:'#f0ffff',verifier:commonKey},
		beige:{value:'#f5f5dc',verifier:commonKey},
		bisque:{value:'#ffe4c4',verifier:commonKey},
		black:{value:'#000000',verifier:commonKey},
		blanchedalmond:{value:'#ffebcd',verifier:commonKey},
		blue:{value:'#0000ff',verifier:commonKey},
		blueviolet:{value:'#8a2be2',verifier:commonKey},
		brown:{value:'#a52a2a',verifier:commonKey},
		burlywood:{value:'#deb887',verifier:commonKey},
		cadetblue:{value:'#5f9ea0',verifier:commonKey},
		chartreuse:{value:'#7fff00',verifier:commonKey},
		chocolate:{value:'#d2691e',verifier:commonKey},
		coral:{value:'#ff7f50',verifier:commonKey},
		cornflowerblue:{value:'#6495ed',verifier:commonKey},
		cornsilk:{value:'#fff8dc',verifier:commonKey},
		crimson:{value:'#dc143c',verifier:commonKey},
		cyan:{value:'#00ffff',verifier:commonKey},
		darkblue:{value:'#00008b',verifier:commonKey},
		darkcyan:{value:'#008b8b',verifier:commonKey},
		darkgoldenrod:{value:'#b8860b',verifier:commonKey},
		darkgray:{value:'#a9a9a9',verifier:commonKey},
		darkgreen:{value:'#006400',verifier:commonKey},
		darkkhaki:{value:'#bdb76b',verifier:commonKey},
		darkmagenta:{value:'#8b008b',verifier:commonKey},
		darkolivegreen:{value:'#556b2f',verifier:commonKey},
		darkorange:{value:'#ff8c00',verifier:commonKey},
		darkorchid:{value:'#9932cc',verifier:commonKey},
		darkred:{value:'#8b0000',verifier:commonKey},
		darksalmon:{value:'#e9967a',verifier:commonKey},
		darkseagreen:{value:'#8fbc8f',verifier:commonKey},
		darkslateblue:{value:'#483d8b',verifier:commonKey},
		darkslategray:{value:'#2f4f4f',verifier:commonKey},
		darkturquoise:{value:'#00ced1',verifier:commonKey},
		darkviolet:{value:'#9400d3',verifier:commonKey},
		deeppink:{value:'#ff1493',verifier:commonKey},
		deepskyblue:{value:'#00bfff',verifier:commonKey},
		dimgray:{value:'#696969',verifier:commonKey},
		dodgerblue:{value:'#1e90ff',verifier:commonKey},
		firebrick:{value:'#b22222',verifier:commonKey},
		floralwhite:{value:'#fffaf0',verifier:commonKey},
		forestgreen:{value:'#228b22',verifier:commonKey},
		fuchsia:{value:'#ff00ff',verifier:commonKey},
		gainsboro:{value:'#dcdcdc',verifier:commonKey},
		ghostwhite:{value:'#f8f8ff',verifier:commonKey},
		gold:{value:'#ffd700',verifier:commonKey},
		goldenrod:{value:'#daa520',verifier:commonKey},
		gray:{value:'#808080',verifier:commonKey},
		green:{value:'#008000',verifier:commonKey},
		greenyellow:{value:'#adff2f',verifier:commonKey},
		honeydew:{value:'#f0fff0',verifier:commonKey},
		hotpink:{value:'#ff69b4',verifier:commonKey},
		indianred:{value:'#cd5c5c',verifier:commonKey},
		indigo:{value:'#4b0082',verifier:commonKey},
		ivory:{value:'#fffff0',verifier:commonKey},
		khaki:{value:'#f0e68c',verifier:commonKey},
		lavender:{value:'#e6e6fa',verifier:commonKey},
		lavenderblush:{value:'#fff0f5',verifier:commonKey},
		lawngreen:{value:'#7cfc00',verifier:commonKey},
		lemonchiffon:{value:'#fffacd',verifier:commonKey},
		lightblue:{value:'#add8e6',verifier:commonKey},
		lightcoral:{value:'#f08080',verifier:commonKey},
		lightcyan:{value:'#e0ffff',verifier:commonKey},
		lightgoldenrodyellow:{value:'#fafad2',verifier:commonKey},
		lightgray:{value:'#d3d3d3',verifier:commonKey},
		lightgreen:{value:'#90ee90',verifier:commonKey},
		lightpink:{value:'#ffb6c1',verifier:commonKey},
		lightsalmon:{value:'#ffa07a',verifier:commonKey},
		lightseagreen:{value:'#20b2aa',verifier:commonKey},
		lightskyblue:{value:'#87cefa',verifier:commonKey},
		lightslategray:{value:'#778899',verifier:commonKey},
		lightsteelblue:{value:'#b0c4de',verifier:commonKey},
		lightyellow:{value:'#ffffe0',verifier:commonKey},
		lime:{value:'#00ff00',verifier:commonKey},
		limegreen:{value:'#32cd32',verifier:commonKey},
		linen:{value:'#faf0e6',verifier:commonKey},
		magenta:{value:'#ff00ff',verifier:commonKey},
		maroon:{value:'#800000',verifier:commonKey},
		mediumaquamarine:{value:'#66cdaa',verifier:commonKey},
		mediumblue:{value:'#0000cd',verifier:commonKey},
		mediumorchid:{value:'#ba55d3',verifier:commonKey},
		mediumpurple:{value:'#9370db',verifier:commonKey},
		mediumseagreen:{value:'#3cb371',verifier:commonKey},
		mediumslateblue:{value:'#7b68ee',verifier:commonKey},
		mediumspringgreen:{value:'#00fa9a',verifier:commonKey},
		mediumturquoise:{value:'#48d1cc',verifier:commonKey},
		mediumvioletred:{value:'#c71585',verifier:commonKey},
		midnightblue:{value:'#191970',verifier:commonKey},
		mintcream:{value:'#f5fffa',verifier:commonKey},
		mistyrose:{value:'#ffe4e1',verifier:commonKey},
		moccasin:{value:'#ffe4b5',verifier:commonKey},
		navajowhite:{value:'#ffdead',verifier:commonKey},
		navy:{value:'#000080',verifier:commonKey},
		oldlace:{value:'#fdf5e6',verifier:commonKey},
		olive:{value:'#808000',verifier:commonKey},
		olivedrab:{value:'#6b8e23',verifier:commonKey},
		orange:{value:'#ffa500',verifier:commonKey},
		orangered:{value:'#ff4500',verifier:commonKey},
		orchid:{value:'#da70d6',verifier:commonKey},
		palegoldenrod:{value:'#eee8aa',verifier:commonKey},
		palegreen:{value:'#98fb98',verifier:commonKey},
		paleturquoise:{value:'#afeeee',verifier:commonKey},
		palevioletred:{value:'#db7093',verifier:commonKey},
		papayawhip:{value:'#ffefd5',verifier:commonKey},
		peachpuff:{value:'#ffdab9',verifier:commonKey},
		peru:{value:'#cd853f',verifier:commonKey},
		pink:{value:'#ffc0cb',verifier:commonKey},
		plum:{value:'#dda0dd',verifier:commonKey},
		powderblue:{value:'#b0e0e6',verifier:commonKey},
		purple:{value:'#800080',verifier:commonKey},
		rebeccapurple:{value:'#663399',verifier:commonKey},
		red:{value:'#ff0000',verifier:commonKey},
		rosybrown:{value:'#bc8f8f',verifier:commonKey},
		royalblue:{value:'#4169e1',verifier:commonKey},
		saddlebrown:{value:'#8b4513',verifier:commonKey},
		salmon:{value:'#fa8072',verifier:commonKey},
		sandybrown:{value:'#f4a460',verifier:commonKey},
		seagreen:{value:'#2e8b57',verifier:commonKey},
		seashell:{value:'#fff5ee',verifier:commonKey},
		sienna:{value:'#a0522d',verifier:commonKey},
		silver:{value:'#c0c0c0',verifier:commonKey},
		skyblue:{value:'#87ceeb',verifier:commonKey},
		slateblue:{value:'#6a5acd',verifier:commonKey},
		slategray:{value:'#708090',verifier:commonKey},
		snow:{value:'#fffafa',verifier:commonKey},
		springgreen:{value:'#00ff7f',verifier:commonKey},
		steelblue:{value:'#4682b4',verifier:commonKey},
		tan:{value:'#d2b48c',verifier:commonKey},
		teal:{value:'#008080',verifier:commonKey},
		thistle:{value:'#d8bfd8',verifier:commonKey},
		tomato:{value:'#ff6347',verifier:commonKey},
		turquoise:{value:'#40e0d0',verifier:commonKey},
		violet:{value:'#ee82ee',verifier:commonKey},
		wheat:{value:'#f5deb3',verifier:commonKey},
		white:{value:'#ffffff',verifier:commonKey},
		whitesmoke:{value:'#f5f5f5',verifier:commonKey},
		yellow:{value:'#ffff00',verifier:commonKey},
		yellowgreen:{value:'#9acd32',verifier:commonKey},
		transparent:{value:'bg-color:transparent',verifier:commonKey},
		t:{value:'top', verifier:numericKey},
		b:{value:'bottom', verifier:numericKey},
		l:{value:'left', verifier:numericKey},
		r:{value:'right', verifier:numericKey},
		m:{value:'middle', verifier:commonKey},
		j:{value:'justify', verifier:commonKey},
		c:{value:'center', verifier:commonKey},
		n:{value:'none', verifier:commonKey},
		pc:{value:'%', verifier:commonKey},
		line:{value:'line', verifier:pushKey},
		i:{value:' !important', verifier:commonKey},
		marg:{value:'margin', verifier:numericKey},
		padd:{value:'padding', verifier:numericKey},
		bord:{value:'border', verifier:numericKey},
		w:{value:'width', verifier:valueKey},
		h:{value:'height', verifier:valueKey},
		o:{value:'outline', verifier:valueKey},
		disp:{value:'display', verifier:valueKey},
		vert:{value:'vertical-align', verifier:valueKey},
		block:{value:'block', verifier:commonKey},
		"inline":{value:'inline', verifier:appendKey},
		bg:{value:'background',verifier:numericKey},
		txt: { value:'', verifier:textKey },
		sub:{value:'sub',verifier:commonKey},
		sup:{value:'super',verifier:commonKey},
		pos:{value:'position',verifier:valueKey},
		abs:{value:'absolute',verifier:commonKey},
		rel:{value:'relative',verifier:commonKey},
		fix:{value:'fixed',verifier:commonKey},
		pull:{value:'float',verifier:valueKey},
		float:{value:'float',verifier:valueKey},
		over:{value:'overflow',verifier:valueKey},
		hid:{value:'',verifier:commonKey},
		scroll:{value:'scroll',verifier:scrollKey},
		x:{value:'x',verifier:scrollKey},
		y:{value:'y',verifier:scrollKey},
		z:{value:'z-index',verifier:valueKey},
		bold:{value:'font-weight:bold',verifier:commonKey},
		regular:{value:'font-weight:regular',verifier:commonKey},
		underline:{value:'font-weight:underline',verifier:commonKey},
		italic:{value:'font-weight:italic',verifier:commonKey},
		thin:{value:'font-weight:100',verifier:commonKey},
		upcase:{value:'font-transform:uppercase',verifier:commonKey},
		locase:{value:'font-transform:lowercase',verifier:commonKey},
		curs:{value:'cursor',verifier:valueKey},
		pointer:{value:'pointer',verifier:valueKey},
		loading:{value:'loading',verifier:valueKey},
		arial:{value:'font-family:arial',verifier:commonKey},
		verdana:{value:'font-family:verdana',verifier:commonKey},
		tahoma:{value:'font-family:tahoma',verifier:commonKey},
		lucida:{value:'font-family:lucida',verifier:commonKey},
		georgia:{value:'font-family:georgia',verifier:commonKey},
		trebuchet:{value:'font-family:trebuchet',verifier:commonKey},
		table:{value:'table',verifier:appendKey},
		tab:{value:'table',verifier:appendKey},
		cell:{value:'cell',verifier:commonKey},
		rad:{value:'radius',verifier:valueKey},
		solid:{value:'solid',verifier:commonKey},
		dashed:{value:'dashed',verifier:commonKey},
		double:{value:'double',verifier:commonKey},
		dotted:{value:'dotted',verifier:commonKey},
		alpha:{value:'opacity',verifier:valueKey},
		hidden:{value:'',verifier:commonKey},
		shadow:{value:'',verifier:shadowKey},
	};

	
	static private var _dev:Bool;
	
	static public function addRules(q:Array<Dynamic>):Void {
		Dice.All(q, function(p:String, v:String) {
			Reflect.setField(_KEYS, p, v);
		});
	}
	
	static public function scan(?dev:Bool = false, ?force:Bool = false):Void {
		Sirius.log("Sirius->Automator.scan[ " + (dev == true ? "ACTIVE_MODE" : "SILENT_MODE") + " ]", 10, 1);
		_dev = dev;
		if (force) {
			_scanBody();
		}else {
			Sirius.init(function() {
				Sirius.log("Sirius->Automator::status[ SCANNING... ]", 10, 1);
				if (!_dev) {
					_scanBody();
				}else {
					_activate();
				}
				Sirius.log("Sirius->Automator.scanner[ DONE! ]",10,1);
			});
		}
	}
	
	static private function _activate():Void {
		_scanBody();
		Delayer.create(_scanBody, 1).call(0);
	}
	
	/**
	 * Scan the entire document for class fragments and create the selectors
	 */
	static private function _scanBody():Void {
		search(Sirius.document.element);
	}
	
	/**
	 * Search all element structure for class attributes
	 * @param	t
	 */
	static public function search(t:Dynamic):Void {
		
		if (t == null) return;
		if(!Std.is(t,String)){
			if (Std.is(t, IDisplay)) t = t.element.outerHTML;
			else if (Std.is(t, Element)) t = t.outerHTML;
			else t = Std.string(t);
		}
		
		
		
		var t:Array<String> = t.split("class=");
		
		if (t.length > 0) {
			t.shift();
		}
		
		Dice.Values(t, function(v:String) {
			var i:String = v.substr(0, 1);	// class=["] (string start)
			var j:Int = v.indexOf(i, 1);	// class="["] (string end)
			if (j > 1) {
				v = v.substring(1, j);
				if (v.length > 0) build(v);
			}
		});
		
		css.build();
		
	}
	
	/**
	 * Create selectors from string
	 * @param	query
	 * @param	group
	 */
	static public function build(query:String, ?group:String):Void {
		var c:Array<String> = query.split(" ");
		var m:String = null;
		var s:String;
		var g:Bool = group != null && group.length > 0;
		var r:String = '';
		if (g) m = _screen(group.split("-"));
		if (!g || !css.hasSelector(group, m)) {
			Dice.Values(c, function(v:String) {
				if (v.length > 1) {
					v = v.split("\r").join(" ").split("\n").join(" ").split("\t").join(" ");
					c = v.split("-");
					if (g) {
						_screen(c);
						s = _parse(c).build();
						r += s + ";";
					}else {
						m = _screen(c);
						if (!css.hasSelector(v, m)) {
							s = _parse(c).build();
							if (Utils.isValid(s)) {
								if (_dev) Sirius.log("Sirius->Automator.build[ ." + v + " {" + s + ";} ]",10,1);
								css.setSelector("." + v, s, m);
							}
						}
					}
				}
			});
			if (g) {
				if (_dev) Sirius.log("Sirius->Automator.build[ " + group + " {" + r + "} ]", 10, 1);
				css.setSelector(group, r, m);
			}
		}
	}
	
	/**
	 * If a screen related selector will be applied
	 * @param	args
	 * @return
	 */
	static private function _screen(args:Array<String>):String {
		return _scx.indexOf('#' + args[args.length - 1] + '#') != -1 ? args.pop() : null;
	}
	
	/**
	 * First pass, create the selector structure
	 * @param	args
	 * @return
	 */
	static private function _parse(args:Array<String>):Entry {
		var r:Array<IKey> = [];
		Dice.All(args, function(p:Int, v:String) {
			if(v.length > 0){
				var val:IEntry = Reflect.field(_KEYS, v);
				var v2:String = val != null ? val.value : null;
				r[p] = cast { index:p, key:v, entry:val, position:_position(v2, v), measure:_measure(v2, v), color:_color(v2, v) };
			}
		});
		return new Entry(r,_KEYS);
	}
	
	
	/**
	 * Check if is a !important element
	 * @param	p
	 * @return
	 */
	static private function _important(p:String):Bool {
		return p == "i";
	}
	
	/**
	 * Get a valid value from a Array or String
	 * @param	p
	 * @param	l
	 * @return
	 */
	static private function _level(p:Dynamic, l:Int):String {
		return Std.is(p, Array) ? l < p.length ? p[l] : p[0] : p;
	}
	
	/**
	 * Check if value is one of any edge position
	 * @param	r
	 * @param	x
	 * @return
	 */
	static private function _position(r:String, x:String):Bool {
		return "tblr".indexOf(x) != -1;
	}
	
	/**
	 * Convert value to color (#RRGGBB)
	 * @param	r
	 * @param	x
	 * @return
	 */
	static private function _color(r:String, x:String):String {
		if (x.substr(0, 1) == "x" && (x.length == 4 || x.length == 7)) {
			return "#" + x.substring(1, x.length);
		}else if (Utils.isValid(r) && r.substr(0, 1) == "#") {
			return r;
		}
		return null;
	}
	
	/**
	 * Convert value to numeric (Int|Float)
	 * @param	r
	 * @param	x
	 * @return
	 */
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
	
}

private class Entry {
	public var keys:Array<IKey>;
	public var head:IKey;
	public var tail:IKey;
	public var next:IKey;
	public var missing:Int;
	public var canceled:Bool;
	public function new(keys:Array<IKey>, dict:Dynamic) {
		this.keys = keys;
		this.head = keys[0];
		this.tail = keys[keys.length - 1];
		this.missing = 0;
		this.canceled = false;
	}
	public function build():String {
		var r:String = null;
		if (head != null) {
			r = "";
			var c:Int = 0;
			Dice.Values(keys, function(v:IKey) {
				next = keys[++c];
				r += v.entry != null ? v.entry.verifier(this, v, next) : _valueOf(v);
				return canceled;
			});
		}
		return missing == keys.length ? null : r;
	}
	
	public function cancel():Void {
		canceled = true;
	}
	
	private function _valueOf(v:IKey):String {
		if (v.color != null) return v.color;
		if (v.measure != null) return v.measure;
		++missing;
		return v.key;
	}
}

interface IKey {
	var index:Int;
	var key:String;
	var entry:IEntry;
	var position:Bool;
	var measure:String;
	var color:String;
}

interface IEntry {
	var value:String;
	var verifier:Dynamic;
}

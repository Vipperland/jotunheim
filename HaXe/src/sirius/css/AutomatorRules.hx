package sirius.css;
import sirius.math.ARGB;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:export('AutomatorRules')
class AutomatorRules{
	
	
	/**
	 * Fix any numeric key value or key name
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
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
	
	/**
	 * Fix any border entry
	 * @param	v
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function borderFix(v:String, d:Entry, k:IKey, n:IKey):String {
		if (n.measure != null) return v + "-width:";
		return v + (d.keys[1].key == 'rad' ? '-' : '-style:');
	}
	
	/**
	 * Create a grid value
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function mosaicKey(d:Entry, k:IKey, n:IKey):String {
		if (d.head == k) {
			if (n != null)	Automator.addGrid(Std.parseInt(n.key));
			else 			Automator.addGrid(12);
			d.cancel();
			return null;
		}
		return k.entry.value;
	}
	
	/**
	 * Miscelaneous keys, append '-' to start of the key value
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function shiftKey(d:Entry, k:IKey, n:IKey):String {
		return "-" + k.entry.value;
	}
	
	/**
	 * Return key value
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function commonKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value + (n != null ? ":" : "");
	}
	/**
	 * Return color value with alpha
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function colorKey(d:Entry, k:IKey, n:IKey):String {
		if (n != null && n.measure != null) {
			n.skip = true;
			var v:Int = (cast Std.parseInt(n.measure) / 100 * 255);
			return new ARGB('0x' + k.entry.value.split('#').join(untyped __js__('(v >> 0).toString(16)'))).css();
		}
		return k.entry.value;
	}
	
	/**
	 * Miscelaneous keys, append '-' at the end of the key value
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function pushKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value + "-";
	}
	
	/**
	 * Miscelaneous keys, append ':' at the end of the key value
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function valueKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value + ":";
	}
	
	/**
	 * Return rate (0~1) of numeric range (0~100)
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function alphaKey(d:Entry, k:IKey, n:IKey):String {
		if (d.head == k) {
			d.cancel();
			var o:Int = Std.parseInt(n.key);
			if (o > 100) o = 100;
			else if (o < 0) o = 0;
			return k.entry.value + ":" + (o/100);
		}else {
			return valueKey(d, k, n);
		}
	}
	
	/**
	 * Miscelaneous keys, append '-' at the end of the key value if exists
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function appendKey(d:Entry, k:IKey, n:IKey):String {
		return k.entry.value + (n != null ? "-" : "");
	}
	
	/**
	 * Display sortcuts only (hidden:none,visible:block)
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function displayKey(d:Entry, k:IKey, n:IKey):String {
		return d.head == k ? "display:" + (k.key == 'hidden' ? 'none' : 'block') : k.entry.value;
	}
	
	/**
	 * Z index value fix
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function indexKey(d:Entry, k:IKey, n:IKey):String {
		if (d.head == k) {
			d.cancel();
			return "z-index:" + n.key;
		}
		return k.key;
	}
	
	/**
	 * Controls OVERFLOW
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function scrollKey(d:Entry, k:IKey, n:IKey):String {
		var v:String = k.entry.value;
		if (d.head.key == 'scroll') {
			if (n != null && n.key == 'none') {
				d.cancel();
				return "overflow:hidden";
			}
			if (k.index == 0) return '';
			return "overflow" + (v == 'x'?'-x':'-y') + ":scroll;overflow-" + (v == 'x'?'-y':'-x') + ":hidden";
		}
		return commonKey(d, k, n);
	}
	
	/**
	 * Create a shadow selector for text or other elements
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
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
	
	/**
	 * Create a selector for textkey
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function textKey(d:Entry, k:IKey, n:IKey):String {
		if (k.index == 0) {
			if (n != null && !n.position) {
				if (n.color != null) return 'color:';
				if (n.measure != null) return 'font-size:';
			}
			if(n.key != 'decoration') return 'text-align:';
		}
		return 'text-';
	}
	
	
	/**
	 * A DICTIONARY OF RULES FOR EACH UNIQUE KEYWORD
	 */
	static private var _KEYS:Dynamic = {
		void:{value:'""',verifier:commonKey},
		aliceblue:{value:'#f0f8ff',verifier:colorKey},
		antiquewhite:{value:'#faebd7',verifier:colorKey},
		aqua:{value:'#00ffff',verifier:colorKey},
		aquamarine:{value:'#7fffd4',verifier:colorKey},
		azure:{value:'#f0ffff',verifier:colorKey},
		beige:{value:'#f5f5dc',verifier:colorKey},
		bisque:{value:'#ffe4c4',verifier:colorKey},
		black:{value:'#000000',verifier:colorKey},
		blanchedalmond:{value:'#ffebcd',verifier:colorKey},
		blue:{value:'#0000ff',verifier:colorKey},
		blueviolet:{value:'#8a2be2',verifier:colorKey},
		brown:{value:'#a52a2a',verifier:colorKey},
		burlywood:{value:'#deb887',verifier:colorKey},
		cadetblue:{value:'#5f9ea0',verifier:colorKey},
		chartreuse:{value:'#7fff00',verifier:colorKey},
		chocolate:{value:'#d2691e',verifier:colorKey},
		coral:{value:'#ff7f50',verifier:colorKey},
		cornflowerblue:{value:'#6495ed',verifier:colorKey},
		cornsilk:{value:'#fff8dc',verifier:colorKey},
		crimson:{value:'#dc143c',verifier:colorKey},
		cyan:{value:'#00ffff',verifier:colorKey},
		darkblue:{value:'#00008b',verifier:colorKey},
		darkcyan:{value:'#008b8b',verifier:colorKey},
		darkgoldenrod:{value:'#b8860b',verifier:colorKey},
		darkgray:{value:'#a9a9a9',verifier:colorKey},
		darkgreen:{value:'#006400',verifier:colorKey},
		darkkhaki:{value:'#bdb76b',verifier:colorKey},
		darkmagenta:{value:'#8b008b',verifier:colorKey},
		darkolivegreen:{value:'#556b2f',verifier:colorKey},
		darkorange:{value:'#ff8c00',verifier:colorKey},
		darkorchid:{value:'#9932cc',verifier:colorKey},
		darkred:{value:'#8b0000',verifier:colorKey},
		darksalmon:{value:'#e9967a',verifier:colorKey},
		darkseagreen:{value:'#8fbc8f',verifier:colorKey},
		darkslateblue:{value:'#483d8b',verifier:colorKey},
		darkslategray:{value:'#2f4f4f',verifier:colorKey},
		darkturquoise:{value:'#00ced1',verifier:colorKey},
		darkviolet:{value:'#9400d3',verifier:colorKey},
		deeppink:{value:'#ff1493',verifier:colorKey},
		deepskyblue:{value:'#00bfff',verifier:colorKey},
		dimgray:{value:'#696969',verifier:colorKey},
		dodgerblue:{value:'#1e90ff',verifier:colorKey},
		firebrick:{value:'#b22222',verifier:colorKey},
		floralwhite:{value:'#fffaf0',verifier:colorKey},
		forestgreen:{value:'#228b22',verifier:colorKey},
		fuchsia:{value:'#ff00ff',verifier:colorKey},
		gainsboro:{value:'#dcdcdc',verifier:colorKey},
		ghostwhite:{value:'#f8f8ff',verifier:colorKey},
		gold:{value:'#ffd700',verifier:colorKey},
		goldenrod:{value:'#daa520',verifier:colorKey},
		gray:{value:'#808080',verifier:colorKey},
		green:{value:'#008000',verifier:colorKey},
		greenyellow:{value:'#adff2f',verifier:colorKey},
		honeydew:{value:'#f0fff0',verifier:colorKey},
		hotpink:{value:'#ff69b4',verifier:colorKey},
		indianred:{value:'#cd5c5c',verifier:colorKey},
		indigo:{value:'#4b0082',verifier:colorKey},
		ivory:{value:'#fffff0',verifier:colorKey},
		khaki:{value:'#f0e68c',verifier:colorKey},
		lavender:{value:'#e6e6fa',verifier:colorKey},
		lavenderblush:{value:'#fff0f5',verifier:colorKey},
		lawngreen:{value:'#7cfc00',verifier:colorKey},
		lemonchiffon:{value:'#fffacd',verifier:colorKey},
		lightblue:{value:'#add8e6',verifier:colorKey},
		lightcoral:{value:'#f08080',verifier:colorKey},
		lightcyan:{value:'#e0ffff',verifier:colorKey},
		lightgoldenrodyellow:{value:'#fafad2',verifier:colorKey},
		lightgray:{value:'#d3d3d3',verifier:colorKey},
		lightgreen:{value:'#90ee90',verifier:colorKey},
		lightpink:{value:'#ffb6c1',verifier:colorKey},
		lightsalmon:{value:'#ffa07a',verifier:colorKey},
		lightseagreen:{value:'#20b2aa',verifier:colorKey},
		lightskyblue:{value:'#87cefa',verifier:colorKey},
		lightslategray:{value:'#778899',verifier:colorKey},
		lightsteelblue:{value:'#b0c4de',verifier:colorKey},
		lightyellow:{value:'#ffffe0',verifier:colorKey},
		lime:{value:'#00ff00',verifier:colorKey},
		limegreen:{value:'#32cd32',verifier:colorKey},
		linen:{value:'#faf0e6',verifier:colorKey},
		magenta:{value:'#ff00ff',verifier:colorKey},
		maroon:{value:'#800000',verifier:colorKey},
		mediumaquamarine:{value:'#66cdaa',verifier:colorKey},
		mediumblue:{value:'#0000cd',verifier:colorKey},
		mediumorchid:{value:'#ba55d3',verifier:colorKey},
		mediumpurple:{value:'#9370db',verifier:colorKey},
		mediumseagreen:{value:'#3cb371',verifier:colorKey},
		mediumslateblue:{value:'#7b68ee',verifier:colorKey},
		mediumspringgreen:{value:'#00fa9a',verifier:colorKey},
		mediumturquoise:{value:'#48d1cc',verifier:colorKey},
		mediumvioletred:{value:'#c71585',verifier:colorKey},
		midnightblue:{value:'#191970',verifier:colorKey},
		mintcream:{value:'#f5fffa',verifier:colorKey},
		mistyrose:{value:'#ffe4e1',verifier:colorKey},
		moccasin:{value:'#ffe4b5',verifier:colorKey},
		navajowhite:{value:'#ffdead',verifier:colorKey},
		navy:{value:'#000080',verifier:colorKey},
		oldlace:{value:'#fdf5e6',verifier:colorKey},
		olive:{value:'#808000',verifier:colorKey},
		olivedrab:{value:'#6b8e23',verifier:colorKey},
		orange:{value:'#ffa500',verifier:colorKey},
		orangered:{value:'#ff4500',verifier:colorKey},
		orchid:{value:'#da70d6',verifier:colorKey},
		palegoldenrod:{value:'#eee8aa',verifier:colorKey},
		palegreen:{value:'#98fb98',verifier:colorKey},
		paleturquoise:{value:'#afeeee',verifier:colorKey},
		palevioletred:{value:'#db7093',verifier:colorKey},
		papayawhip:{value:'#ffefd5',verifier:colorKey},
		peachpuff:{value:'#ffdab9',verifier:colorKey},
		peru:{value:'#cd853f',verifier:colorKey},
		pink:{value:'#ffc0cb',verifier:colorKey},
		plum:{value:'#dda0dd',verifier:colorKey},
		powderblue:{value:'#b0e0e6',verifier:colorKey},
		purple:{value:'#800080',verifier:colorKey},
		rebeccapurple:{value:'#663399',verifier:colorKey},
		red:{value:'#ff0000',verifier:colorKey},
		rosybrown:{value:'#bc8f8f',verifier:colorKey},
		royalblue:{value:'#4169e1',verifier:colorKey},
		saddlebrown:{value:'#8b4513',verifier:colorKey},
		salmon:{value:'#fa8072',verifier:colorKey},
		sandybrown:{value:'#f4a460',verifier:colorKey},
		seagreen:{value:'#2e8b57',verifier:colorKey},
		seashell:{value:'#fff5ee',verifier:colorKey},
		sienna:{value:'#a0522d',verifier:colorKey},
		silver:{value:'#c0c0c0',verifier:colorKey},
		skyblue:{value:'#87ceeb',verifier:colorKey},
		slateblue:{value:'#6a5acd',verifier:colorKey},
		slategray:{value:'#708090',verifier:colorKey},
		snow:{value:'#fffafa',verifier:colorKey},
		springgreen:{value:'#00ff7f',verifier:colorKey},
		steelblue:{value:'#4682b4',verifier:colorKey},
		tan:{value:'#d2b48c',verifier:colorKey},
		teal:{value:'#008080',verifier:colorKey},
		thistle:{value:'#d8bfd8',verifier:colorKey},
		tomato:{value:'#ff6347',verifier:colorKey},
		turquoise:{value:'#40e0d0',verifier:colorKey},
		violet:{value:'#ee82ee',verifier:colorKey},
		wheat:{value:'#f5deb3',verifier:colorKey},
		white:{value:'#ffffff',verifier:colorKey},
		whitesmoke:{value:'#f5f5f5',verifier:colorKey},
		yellow:{value:'#ffff00',verifier:colorKey},
		yellowgreen:{value:'#9acd32',verifier:colorKey},
		transparent:{value:'background-color:transparent',verifier:colorKey},
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
		decor: { value:'', verifier:valueKey },
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
		z:{value:'z-index',verifier:indexKey},
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
		alpha:{value:'opacity',verifier:alphaKey},
		hidden:{value:'',verifier:displayKey},
		visible:{value:'',verifier:displayKey},
		shadow:{value:'',verifier:shadowKey},
		mosaic:{value:'',verifier:mosaicKey},
		mouse:{value:'pointer-events',verifier:commonKey},
	};
	
	static public function set(rule:Dynamic, ?value:IEntry):Void {
		if (Std.is(rule, Array))	Dice.All(rule, function(p:String, v:String) {	Reflect.setField(_KEYS, p, v); } );
		else if(value != null)		Reflect.setField(_KEYS, rule, value);
	}
	
	static public function get(name:String):IEntry {
		var e:IEntry = Reflect.field(_KEYS, name);
		return e;
	}
	
	static public function blank(name:String):IEntry {
		var e:IEntry = cast { value:name, verifier:commonKey };
		Reflect.setField(_KEYS, name, e);
		return e;
	}
	
	static public function keys():Dynamic {
		return _KEYS;
	}
	
}
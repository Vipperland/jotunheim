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
	 * Controls OVERFLOW
	 * @param	d
	 * @param	k
	 * @param	n
	 * @return
	 */
	static public function scrollKey(d:Entry, k:IKey, n:IKey):String {
		var v:String = k.entry.value;
		if (d.head.key == 'scroll') {
			if (k.index == 0) return '';
			return "overflow-" + v + ":scroll;overflow-" + (v == 'x'?'y':'x') + ":hidden";
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
	 * A DICTIONARY OF RULES FOR EACH UNIQUE KEYWORD
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
		hidden:{value:'',verifier:displayKey},
		visible:{value:'',verifier:displayKey},
		shadow:{value:'',verifier:shadowKey},
	};
	
	static public function set(rule:Dynamic, ?value:IEntry):Void {
		if (Std.is(rule, Array))	Dice.All(rule, function(p:String, v:String) {	Reflect.setField(_KEYS, p, v); } );
		else if(value != null)		Reflect.setField(_KEYS, rule, value);
	}
	
	static public function get(name:String):IEntry {
		return Reflect.getProperty(_KEYS, name);
	}
	
	static public function keys():Dynamic {
		return _KEYS;
	}
	
}
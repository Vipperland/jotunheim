package sirius.css;
import sirius.math.ARGB;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('AutomatorRules')
class AutomatorRules {
	
	static public var SHADOW_DIST:Int = 5;
	
	static public var SHADOW_DIRECTION:Int = 90;
	
	static public var SHADOW_COLOR_FLEX:Float = .1;
	
	static public var SHADOW_DRAWS:Int = 1;
	
	static public var SHADOW_STRENGTH:Int = 3;
	
	
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
			if (n != null)	Automator.mosaic(Std.parseInt(n.key));
			else 			Automator.mosaic(12);
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
			var x:Array<String> = d.compile(s ? 3 : 2);
			var y:Int = 0;
			var z:Int = 	x[0] == null ? SHADOW_DIST 			: Std.parseInt(x[0]);
			var a:Int = 	x[1] == null ? SHADOW_DIRECTION 	: Std.parseInt(x[1]);
			var c:Float = 	x[2] == null ? SHADOW_COLOR_FLEX 	: Std.parseFloat(x[2]);
			var w:Int = 	x[3] == null ? SHADOW_DRAWS 		: Std.parseInt(x[3]);
			var u:Int = 	x[4] == null ? SHADOW_STRENGTH 		: Std.parseInt(x[4]);
			var cos:Float = Math.cos(.017453 * a);
			var sin:Float = Math.sin(.017453 * a);
			var r:Array<String> = [];
			var tx:Int = 0;
			var ty:Int = 0;
			while (y < z) {
				y += w;
				if (y > z) y = z;
				tx = (cast cos * y);
				ty = (cast sin * y);
				r[r.length] = (tx == 0 ? '0' : Math.round(tx) + 'px') + ' ' + (ty == 0 ? '0' : Math.round(ty) + 'px') + ' 0 ' + t.range(.8 - (y/z*c)).hex();
			}
			y = 0;
			while (y < u) {
				y += w;
				if (y > u) y = u;
				tx = (cast cos * (y+z));
				ty = (cast sin * (y+z));
				r[r.length] = (tx == 0 ? '0' : Math.round(tx) + 'px') + ' ' + (ty == 0 ? '0' : Math.round(ty) + 'px') + ' 0 rgba(0,0,0,.1)';
			}
			return (s ? 'text-shadow' : 'box-shadow') + ':' + r.join(',') + (i ? ' !important' : '');
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
		loading:{value:'loading',verifier:valueKey},
		arial:{value:'font-family:arial',verifier:commonKey},
		verdana:{value:'font-family:verdana',verifier:commonKey},
		tahoma:{value:'font-family:tahoma',verifier:commonKey},
		lucida:{value:'font-family:lucida console',verifier:commonKey},
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
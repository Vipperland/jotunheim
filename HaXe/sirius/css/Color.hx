package sirius.css;
import haxe.Log;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.css.Color")
class Color extends CSS {
	
	public static var COLORS:Dynamic = { aliceblue: { color:"#f0f8ff" }, antiquewhite: { color:"#faebd7" }, aqua: { color:"#00ffff" }, aquamarine: { color:"#7fffd4" }, azure: { color:"#f0ffff" }, beige: { color:"#f5f5dc" }, bisque: { color:"#ffe4c4" }, black: { color:"#000000" }, blanchedalmond: { color:"#ffebcd" }, blue: { color:"#0000ff" }, blueviolet: { color:"#8a2be2" }, brown: { color:"#a52a2a" }, burlywood: { color:"#deb887" }, cadetblue: { color:"#5f9ea0" }, chartreuse: { color:"#7fff00" }, chocolate: { color:"#d2691e" }, coral: { color:"#ff7f50" }, cornflowerblue: { color:"#6495ed" }, cornsilk: { color:"#fff8dc" }, crimson: { color:"#dc143c" }, cyan: { color:"#00ffff" }, darkblue: { color:"#00008b" }, darkcyan: { color:"#008b8b" }, darkgoldenrod: { color:"#b8860b" }, darkgray: { color:"#a9a9a9" }, darkgreen: { color:"#006400" }, darkkhaki: { color:"#bdb76b" }, darkmagenta: { color:"#8b008b" }, darkolivegreen: { color:"#556b2f" }, darkorange: { color:"#ff8c00" }, darkorchid: { color:"#9932cc" }, darkred: { color:"#8b0000" }, darksalmon: { color:"#e9967a" }, darkseagreen: { color:"#8fbc8f" }, darkslateblue: { color:"#483d8b" }, darkslategray: { color:"#2f4f4f" }, darkturquoise: { color:"#00ced1" }, darkviolet: { color:"#9400d3" }, deeppink: { color:"#ff1493" }, deepskyblue: { color:"#00bfff" }, dimgray: { color:"#696969" }, dodgerblue: { color:"#1e90ff" }, firebrick: { color:"#b22222" }, floralwhite: { color:"#fffaf0" }, forestgreen: { color:"#228b22" }, fuchsia: { color:"#ff00ff" }, gainsboro: { color:"#dcdcdc" }, ghostwhite: { color:"#f8f8ff" }, gold: { color:"#ffd700" }, goldenrod: { color:"#daa520" }, gray: { color:"#808080" }, green: { color:"#008000" }, greenyellow: { color:"#adff2f" }, honeydew: { color:"#f0fff0" }, hotpink: { color:"#ff69b4" }, indianred : { color:"#cd5c5c" }, indigo : { color:"#4b0082" }, ivory: { color:"#fffff0" }, khaki: { color:"#f0e68c" }, lavender: { color:"#e6e6fa" }, lavenderblush: { color:"#fff0f5" }, lawngreen: { color:"#7cfc00" }, lemonchiffon: { color:"#fffacd" }, lightblue: { color:"#add8e6" }, lightcoral: { color:"#f08080" }, lightcyan: { color:"#e0ffff" }, lightgoldenrodyellow: { color:"#fafad2" }, lightgray: { color:"#d3d3d3" }, lightgreen: { color:"#90ee90" }, lightpink: { color:"#ffb6c1" }, lightsalmon: { color:"#ffa07a" }, lightseagreen: { color:"#20b2aa" }, lightskyblue: { color:"#87cefa" }, lightslategray: { color:"#778899" }, lightsteelblue: { color:"#b0c4de" }, lightyellow: { color:"#ffffe0" }, lime: { color:"#00ff00" }, limegreen: { color:"#32cd32" }, linen: { color:"#faf0e6" }, magenta: { color:"#ff00ff" }, maroon: { color:"#800000" }, mediumaquamarine: { color:"#66cdaa" }, mediumblue: { color:"#0000cd" }, mediumorchid: { color:"#ba55d3" }, mediumpurple: { color:"#9370db" }, mediumseagreen: { color:"#3cb371" }, mediumslateblue: { color:"#7b68ee" }, mediumspringgreen: { color:"#00fa9a" }, mediumturquoise: { color:"#48d1cc" }, mediumvioletred: { color:"#c71585" }, midnightblue: { color:"#191970" }, mintcream: { color:"#f5fffa" }, mistyrose: { color:"#ffe4e1" }, moccasin: { color:"#ffe4b5" }, navajowhite: { color:"#ffdead" }, navy: { color:"#000080" }, oldlace: { color:"#fdf5e6" }, olive: { color:"#808000" }, olivedrab: { color:"#6b8e23" }, orange: { color:"#ffa500" }, orangered: { color:"#ff4500" }, orchid: { color:"#da70d6" }, palegoldenrod: { color:"#eee8aa" }, palegreen: { color:"#98fb98" }, paleturquoise: { color:"#afeeee" }, palevioletred: { color:"#db7093" }, papayawhip: { color:"#ffefd5" }, peachpuff: { color:"#ffdab9" }, peru: { color:"#cd853f" }, pink: { color:"#ffc0cb" }, plum: { color:"#dda0dd" }, powderblue: { color:"#b0e0e6" }, purple: { color:"#800080" }, rebeccapurple: { color:"#663399" }, red: { color:"#ff0000" }, rosybrown: { color:"#bc8f8f" }, royalblue: { color:"#4169e1" }, saddlebrown: { color:"#8b4513" }, salmon: { color:"#fa8072" }, sandybrown: { color:"#f4a460" }, seagreen: { color:"#2e8b57" }, seashell: { color:"#fff5ee" }, sienna: { color:"#a0522d" }, silver: { color:"#c0c0c0" }, skyblue: { color:"#87ceeb" }, slateblue: { color:"#6a5acd" }, slategray: { color:"#708090" }, snow: { color:"#fffafa" }, springgreen: { color:"#00ff7f" }, steelblue: { color:"#4682b4" }, tan: { color:"#d2b48c" }, teal: { color:"#008080" }, thistle: { color:"#d8bfd8" }, tomato: { color:"#ff6347" }, turquoise: { color:"#40e0d0" }, violet: { color:"#ee82ee" }, wheat: { color:"#f5deb3" }, white: { color:"#ffffff" }, whitesmoke: { color:"#f5f5f5" }, yellow: { color:"#ffff00" }, yellowgreen: { color:"#9acd32" }};
	
	static public var FLAT:Array<Dynamic> = [];
	
	static public var ALL:Array<Dynamic> = [];
	
	private static var _active:Bool = false;
	
	static public function rnd(?flatOnly:Bool = false):Dynamic {
		if (ALL.length == 0) {
			Dice.All(COLORS, function(p:String, v:Dynamic) {
				v.name = p;
				ALL[ALL.length] = v;
			});
		}
		var v:Array<Dynamic> = (flatOnly ? FLAT : ALL);
		return v[Std.random(v.length)];
	}
	
	
	static public function byName(name:String):Dynamic {
		return Reflect.field(COLORS, name);
	}
	
	public function new():Void {
		super(false);
		if (!_active) {
			setSelector(".transparent", "background-color:transparent;");
			_active = true;
			_parse();
		}
	}
	
	private function _parse():Void {
		Dice.All(COLORS, function(p:String, v:Dynamic) {
			v.name = p;
			setSelector(".bg-" + p, "background-color:" + v.color + ";");
			setSelector(".bg-" + p + ":hover", "background-color:" + v.color + ";");
			setSelector(".txt-" + p, "color:" + v.color + ";");
			setSelector(".bord-" + p, "border-color:" + v.color + ";");
		});
	}
	
}
package sirius.css;
import css.CSSGroup;
import haxe.Log;
import sirius.Sirius;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('CSSAutomator')
class Automator {
	
	static private var css:CSSGroup;
	
	static private var _NS:Dynamic = { 
		t:'top',
		b:'botton',
		l:'left',
		r:'right',
		pc:'%',
		i:' !important',
		bord:'border',
		marg:'margin',
		padd:'padding',
		line:'line',
		w:'width',
		h:'height',
		o:'outline',
		wh:['width', 'height'],
		rad:'radius',
		a:'auto',
		txt:'font-size',
		xs:'',
		sm:'',
		md:'',
		lg:'',
	};
	
	static public function scan(?force:Bool = false):Void {
		if (css == null) {
			Dice.Values([new Decoration(), new Color()], function(v:ICSS) {
				v.build();
			});
			css = new CSSGroup();
		}
		if (force) {
			_scanBody();
		}else {
			Sirius.init(_scanBody);
		}
	}
	
	static private function _scanBody() {
		
		var s:String;
		
		var t:Array<String> = Sirius.document.element.outerHTML.split("class=");
		t.shift();
		
		Dice.Values(t, function(v:String) {
			var i:String = v.substr(0, 1);
			var j:Int = v.indexOf(i, 1);
			if (j > 1) {
				v = v.substring(1, j);
				var c:Array<String> = v.split(" ");
				Dice.Values(c, function(v:String) {
					c = v.split("-");
					s = _parse(c, 0);
					if (s != null && s.indexOf("null") == -1) {
						css.setSelector("." + v, s, c.pop());
					}
				});
			}
		});
		
		css.build();
		
	}
	
	static private function _parse(c:Array<String>, level:Int) {
		var v:String = c[level];
		var r:String = Reflect.field(_NS, c[level]);
		if (r == null && level > 0) {
			var l:Int = v.length;
			if (v.substr(l - 2, 2) == "pc") {
				r = v.split("d").join(".").split("pc").join("%");
			}else if (v.substr(l - 1, 1) == "n") {
				r = "-" + v.split("n").join("") + "px";
			}else {
				var x:Int = Std.parseInt(v);
				if (x != null) {
					r = x + "px";
				}else {
					return null;
				}
			}
		}else if(r == null && level == 0){
			return null;
		}
		return ++level == c.length ? r + ";": r + (level == 1 ? ":" : "") + _parse(c, level);
	}
	
}
package sirius.css;
import js.html.Element;
import sirius.css.CSSGroup;
import sirius.css.IKey;
import sirius.dom.IDisplay;
import sirius.math.ARGB;
import sirius.Sirius;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('Automator')
class Automator {
	
	static private var _scx:String = "#xs#sm#md#lg#pr#";
	
	static private var css:CSSGroup = new CSSGroup();
	
	static private var _dev:Bool = false;
	
	static private var _inits:Dynamic = {
		reset : false,
		sprites : false,
	};
	
	static public function reset():Void {
		if (!_inits.reset){
			_inits.reset = true;
			css.setSelector('@-ms-viewport', 'width:device-width;');
			css.setSelector('*,*:before,*:after', 'box-sizing:border-box;');
			parse('html,body=h-100pc arial txt-12;.hidden=disp-none-i;*=marg-0 padd-0 bord-0 bord-solid outline-0 color-inherit font-inherit vert-baseline glass;a,a:link,a:visited,a:active,a:hover=txt-decoration-none;ol,ul,dl=list-style-none;input,textarea,select,hr=padd-5;label=disp-inline-block;marg-a vert-m float-l float-r txt-c pos-abs pos-rel pos-fix;');
			scan();
			enableSprites();
			css.build();
		}
	}
	
	static public function enableSprites() {
		if (!_inits.sprites){
			_inits.sprites = true;
			parse('.sprite=w-100pc disp-table txt-c;.sprite > div=disp-table-cell vert-m;.sprite > div > div=marg-l-auto marg-r-auto');
			if (!_inits.reset)
				css.build();
		}
	}
	
	static public function unmute():Void {
		_dev = true;
	}
	
	static public function mute():Void {
		_dev = false;
	}
	
	static public function shadowConfig(data:Dynamic):Void {
		Dice.All(data, function(p:String, v:UInt) {	Reflect.setField(AutomatorRules.shadowConfig, p, v); } );
	}
	
	static public function scan():Void {
		Sirius.all('noscript[automator]').each(function(o:IDisplay){
			parse(o.element.innerText, o.attribute('automator').toLowerCase() == 'omni');
			o.dispose();
		});
		css.build(); // Apply changes / Append to ScriptElement
	}
	
	/**
	 * Build the selector for all resolution modes
	 * @param	query
	 * @param	group
	 * @param	silent
	 */
	static public function omnibuild(query:String, ?group:String):Void {
		build(query, group + '-xs'	, true);
		build(query, group + '-sm'	, true);
		build(query, group + '-md'	, true);
		build(query, group + '-lg'	, true);
		build(query, group + '-pr'	, true);
		build(query, group 			, true);
	}
	
	/**
	 * Create selectors from string
	 * @param	query
	 * @param	group
	 */
	static public function build(?query:String, ?group:String, ?silent:Bool):Void {
		
		if (query == null || query == ''){
			css.build();
			return;
		}
		
		var c:Array<String> = query.split(" ");						// Split class names
		var m:String = null;										// MediaQueries rule
		var s:String;												// Final selector
		var g:Bool = Utils.isValid(group);							// Is a valid group?
		var r:String = ''; 											// Group value, if available
		if (g && group.length > 0) m = _screen(group.split("-"));	// Remove MediaQuery rule from group name
		
		Dice.Values(c, function(v:String) {
			if (v.length > 1) {
				v = v.split("\r").join(" ").split("\n").join(" ").split("\t").join(" "); // Remove linebreaks invalid characters from class names
				c = v.split("-"); // create sections
				if (c.length > 0) {
					if (c[0] == 'ref') return;
					if (g) { // Rule for groups
						_screen(c); // Remove @media signature
						var en:Entry = _parse(c);
						s = en.build(); // Create class for selector
						if (Utils.isValid(s)) r += s + ";";
						else if (_dev == true)  Sirius.log("Automator => ERROR (" + en + ")");
					}else { // Rule for single class name
						m = _screen(c); // Target @media
						if (!css.hasSelector(v, m)) { // Check if selector exists
							s = _parse(c).build(); // Create class for selector
							if (Utils.isValid(s)) { // Check if value is valid
								if (_dev == true) 
									Sirius.log("Automator => ." + v + " {" + s + ";}", 1);
								css.setSelector('.' + v, s, m); // Add selector to correspondent @media group
							}
						}
					}
				}
			}
		});
		if (g && Utils.isValid(r)) { // If is a group, register all classes to correspondent group and @media value
			if (_dev == true) 
				Sirius.log("Automator => " + group + " {" + r + "}", 1);
			css.setSelector(group, r, m);
		}
		if (silent == null || silent == false) css.build();
		
	}
	
	/**
	 * Build from custom text (selector: automator css-syntax;)
	 * @param	data
	 */
	static public function parse(data:String, ?omni:Bool):Void {
		Dice.Values(data.split(';'), function(v:String) {
			var set:Array<String> = v.split('\r\n').join(' ').split('\r').join(' ').split('\n').join(' ').split('=');
			if(set.length==2)
				omni ? omnibuild(set[1], set[0]) : build(set[1], set[0], true);
			else if(set.length == 1)
				omni ? omnibuild(set[0], null) : build(set[0], null, true);
		});
	}
	
	/**
	 * Create a grid container
	 * @param	size
	 */
	static public function grid(size:Dynamic):Void {
		if(!Reflect.hasField(_inits, 'grid-' + size)){
			if (!Std.is(size, Array)) 
				size = [size];
			Dice.Values(size, function(v:Int) {	_createGridCol(v); });
			Reflect.setField(_inits, 'grid-' + size, true);
		}
	}
	
	static public function cell(size:UInt, pad:UInt):Void {
		Dice.Count(0, size, function(a:Int, b:Int, c:Bool) {
			++a;
			var t:Dynamic = a / b * 100 - .001;
			var s:String = t.toFixed(16).split(".").join("d") + "pc"; // 00d00pc
			var n:String = '.cel-' + a + (b==12 ? '' : 'x' + b);	// .cel-AxB | .cel-A
			omnibuild('w-' + s + ' padd-' + pad, n); // w-00d00pc padd-10
			return null;
		});
		css.build();
	}
	
	/**
	 * Create all cell styles
	 * @param	size
	 */
	static private function _createGridCol(size:Int):Void {
		var n:String = '.grid' + (size != 12 ? '-' + size : '');
		if (!css.hasSelector(n, null, '')){
			build('disp-table content-void', n + ':before,' + n + ':after', true);
			build('clear-both', n + ':after', true);
			Dice.Count(0, size, function(a:Int, b:Int, c:Bool) {
				++a;
				var t:Dynamic = a / b * 100 - .001;
				var s:String = t.toFixed(16).split(".").join("d") + "pc"; // 00d00pc
				var n:String = '.cel-' + a + (b==12 ? '' : 'x' + b);	// .cel-AxB | .cel-A
				omnibuild('w-' + s + ' padd-5', n); // w-00d00pc padd-10
				omnibuild('pull-l', n); 
				if (a < b - 1) 
					omnibuild('marg-l-' + s, 'o-' + n);
				return null;
			});
		}
		css.build();
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
		var i:Bool = false;
		if (args[args.length-1] == 'i') {
			i = true;
			args.pop();
		}
		Dice.All(args, function(p:Int, v:String) {
			if(v.length > 0){
				var val:IEntry = AutomatorRules.get(v);
				var v2:String = val != null ? val.value : null;
				// create a Entry for the group
				// Index: Entry point
				// key: property shortcut
				// entry: property parser method
				// position: css common direction values (top,left,bottom and right)
				// measure: CSS position value (positive or negative, pixels or percent)
				// color: css Color value in formar #RRGGBB
				r[p] = cast { index:p, key:v, entry:val, position:getPosition(v2, v), measure:getMeasure(v2, v), color:getColor(v2, v) };
			}
		});
		// return all Entry structure
		return new Entry(r,AutomatorRules.keys(),i);
	}
	
	/**
	 * Check if value is one of any edge position
	 * @param	r
	 * @param	x
	 * @return
	 */
	static public function getPosition(r:String, x:String):Bool {
		return "tblrcm".indexOf(x) != -1 || "#top#bottom#left#right#center#middle#".indexOf(x) != -1;
	}
	
	/**
	 * Convert value to color (#RRGGBB)
	 * @param	r
	 * @param	x
	 * @return
	 */
	static public function getColor(r:String, x:String):String {
		var argb:Bool = x.length == 9;
		if (x.substr(0, 1) == "x" && (x.length == 4 || x.length == 7 || argb)) {
			x = "#" + x.substring(1, x.length);
			return argb ? new ARGB(x).css() : x;
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
	static public function getMeasure(r:String, x:String):String {
		if(r == null){
			var l:Int = x.length;
			if (x.substr(l - 2, 2) == "pc") {
				r = x.split("d").join(".").split("pc").join("%");
			}else if (x.substr(l - 1, 1) == "n" && Std.parseInt(x.substr(0, 2)) != null) {
				r = "-" + x.split("n").join("") + "px";
			}else {
				var n:Int = Std.parseInt(x);
				if (n != null) {
					r = n + (n > 0 ? "px" : "");
				}
			}
			return r;
		}else {
			return null;
		}
	}
	
}
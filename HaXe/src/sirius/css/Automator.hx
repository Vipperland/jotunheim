package sirius.css;
import js.html.Element;
import sirius.css.CSSGroup;
import sirius.css.IKey;
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
	
	static private var _scx:String = "#xs#sm#md#lg#pr#";
	
	static private var css:CSSGroup = new CSSGroup();
	
	static private var _dev:Bool;
	
	static public function reset():Void {
		build('marg-0 padd-0 bord-0 bord-solid outline-0 color-inherit font-inherit vert-baseline glass','*',true);
		build('arial txt-12', 'body',true);
		build('txt-decoration-none', 'a,a:link,a:visited,a:active,a:hover',true);
		build('list-style-none', 'ol,ul,dl',true);
		build('padd-5', 'hr', true);
		build('padd-10','input,textarea,select', true);
		build('marg-a vert-m float-l float-r txt-c pos-abs pos-rel pos-fix',null,true);
		css.setSelector('@-ms-viewport', 'width:device-width;');
		css.setSelector('*,*:before,*:after', 'box-sizing:border-box;');
		css.build();
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
	
	static public function scan(?dev:Bool = false, ?force:Bool = false):Void {
		Sirius.log("Automator => SCAN " + (dev == true ? "ACTIVE" : "[x1]"), 1);
		_dev = dev == true;
		if (force) {
			_scanBody();
		}else {
			if (!_dev) 	_scanBody();
			else		_activate();
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
		
		
		
		var t:Array<String> = t.split("class=");	// Search all class entries
		
		if (t.length > 0) t.shift();
		
		Dice.Values(t, function(v:String) {
			var i:String = v.substr(0, 1);	// class=["] (string start)
			var j:Int = v.indexOf(i, 1);	// class="["] (string end)
			if (j > 1) {
				v = v.substring(1, j);		// Remove quotes (single & double)
				if (v.length > 0) build(v,null,true);	// If result is not empty
			}
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
	static public function build(query:String, ?group:String, ?silent:Bool):Void {
		
		var c:Array<String> = query.split(" ");						// Split class names
		var m:String = null;										// MediaQueries rule
		var s:String;												// Final selector
		var g:Bool = Utils.isValid(group);							// Is a valid group?
		var r:String = ''; 											// Group value, if available
		if (g) m = _screen(group.split("-"));						// Remove MediaQuery rule from group name
		
		Dice.Values(c, function(v:String) {
			if (v.length > 1) {
				v = v.split("\r").join(" ").split("\n").join(" ").split("\t").join(" "); // Remove linebreaks invalid characters from class names
				c = v.split("-"); // Split class name sections
				if (c.length > 0) {
					if (c[0] == 'ref') return;
					if (g) { // Rule for groups
						_screen(c); // Remove @media signature
						var en:Entry = _parse(c);
						s = en.build(); // Create class for selector
						if (Utils.isValid(s))
							r += s + ";";
						else if (_dev == true) 
							Sirius.log("Automator => ERROR (" + en + ")");
					}else { // Rule for single class name
						m = _screen(c); // Target @media
						if (!css.hasSelector(v, m)) { // Check if selector exists
							s = _parse(c).build(); // Create class for selector
							if (Utils.isValid(s)) { // Check if value is valid
								if (_dev == true) 
									Sirius.log("Automator => ." + v + " {" + s + ";}", 1);
								css.setSelector("." + v, s, m); // Add selector to correspondent @media group
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
	static public function parse(data:String):Void {
		Dice.Values(data.split(';'), function(v:String) {
			var set:Array<String> = v.split(':');
			var grp:String = set.shift();
			build(set.join(' '), grp);
		});
	}
	
	/**
	 * Create a grid container
	 * @param	size
	 */
	static public function grid(size:Dynamic):Void {
		if (!Std.is(size, Array)) 
			size = [size];
		Dice.Values(size, function(v:Int) {	_createGridCol(v); });
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
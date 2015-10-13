package sirius.css;
import js.html.Element;
import sirius.css.CSSGroup;
import sirius.css.IKey;
import sirius.dom.IDisplay;
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
	
	static public function enableLogging():Void {
		_dev = true;
	}
	
	static public function disableLogging():Void {
		_dev = false;
	}
	
	static public function scan(?dev:Bool = false, ?force:Bool = false):Void {
		Sirius.log("Sirius->Automator.scanner[ " + (dev == true ? "Infinity" : "1x") + " ]", 10, 1);
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
	
	static public function build4All(query:String, ?group:String, ?silent:Bool):Void {
		build(query, group + '-xs'	, silent);
		build(query, group + '-sm'	, silent);
		build(query, group + '-md'	, silent);
		build(query, group + '-lg'	, silent);
		build(query, group + '-pr'	, silent);
		build(query, group 			, silent);
	}
	
	/**
	 * Create selectors from string
	 * @param	query
	 * @param	group
	 */
	static public function build(query:String, ?group:String, ?silent:Bool):Void {
		var c:Array<String> = query.split(" ");	// Split class names
		var m:String = null;	// MediaQueries rule
		var s:String;	// Final selector
		var g:Bool = group != null && group.length > 0;	// Is a valid group?
		var r:String = ''; // Group value, if available
		if (g) m = _screen(group.split("-")); // Remove MediaQuery rule from group name
		
		Dice.Values(c, function(v:String) {
			if (v.length > 1) {
				v = v.split("\r").join(" ").split("\n").join(" ").split("\t").join(" "); // Remove linebreaks invalid characters from class names
				c = v.split("-"); // Split class name sections
				if (g) { // Rule for groups
					_screen(c); // Remove @media signature
					var en:Entry = _parse(c);
					s = en.build(); // Create class for selector
					if (s != null) {
						r += s + ";";
					}else {
						Sirius.log("Sirius->Automator.build::error( [" + en + "] )");
					}
				}else { // Rule for single class name
					m = _screen(c); // Target @media
					if (!css.hasSelector(v, m)) { // Check if selector exists
						s = _parse(c).build(); // Create class for selector
						if (Utils.isValid(s)) { // Check if value is valid
							if (_dev == true) Sirius.log("Sirius->Automator.build[ ." + v + " {" + s + ";} ]",10,1);
							css.setSelector("." + v, s, m); // Add selector to correspondent @media group
						}
					}
				}
			}
		});
		if (g) { // If is a group, register all classes to correspondent group and @media value
			if (_dev == true) Sirius.log("Sirius->Automator.build[ " + group + " {" + r + "} ]", 10, 1);
			css.setSelector(group, r, m);
		}
		if (silent == null) css.build();
		
	}
	
	static public function addGrid(size:Dynamic):Void {
		if (!Std.is(size, Array)) size = [size];
		Dice.Values(size, function(v:Int) {	_createGridCol(v); });
	}
	
	static private function _createGridCol(size:Int):Void {
		var n:String = '.mosaic-' + size;
		if(!css.hasSelector(n,null,'')){
			Dice.Count(0, size, function(a:Int, b:Int, c:Bool) {
				++a;
				var s:String = untyped __js__("(a/b*100).toFixed(9)").split(".").join("d") + "pc"; // 00d00pc
				var n:String = '.cel-' + a + 'x' + b;	// .cel-AxB
				build4All('w-' + s + ' padd-10', n); // w-00d00pc padd-r-15 padd-l-15
				if (a < b-1) {
					build4All('pull-l', n); // 
					build4All('marg-l-' + s, 'skip-' + n);
				}
				return null;
			});
		}
	}
	
	static public function _init() {
		build('marg-0 padd-0 bord-0 outline-0 color-inherit font-inherit vert-baseline transparent','*');
		build('arial txt-12', 'body');
		build('txt-decoration-none', 'a,a:link,a:visited,a:active,a:hover');
		build('list-style-none', 'ol,ul,dl');
		build('padd-5', 'hr');
		//build('border-collapse-collapse border-spacing-0', 'table');
		build('disp-table content-void', '.grid:before,.grid:after');
		build('clear-both', '.grid:after');
		//build('border-collapse-collapse border-spacing-0', 'table');
		//css.setSelector(':focus', 'outline: 0;');
		css.setSelector('@-ms-viewport', 'width:device-width;');
		css.setSelector('*,*:before,*:after', '-webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;');
		build('marg-a vert-m float-l float-r txt-c');
		Reflect.deleteField(Automator, '_init');
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
				var val:IEntry = AutomatorRules.get(v);
				var v2:String = val != null ? val.value : null;
				// create a Entry for the group
				// Index: Entry point
				// key: property shortcut
				// entry: property parser method
				// position: css common direction values (top,left,bottom and right)
				// measure: CSS position value (positive or negative, pixels or percent)
				// color: css Color value in formar #RRGGBB
				r[p] = cast { index:p, key:v, entry:val, position:_position(v2, v), measure:_measure(v2, v), color:_color(v2, v) };
			}
		});
		// return all Entry structure
		return new Entry(r,AutomatorRules.keys());
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
			}else if (x.substr(l - 1, 1) == "n" && Std.parseInt(x.substr(0, 2)) != null) {
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
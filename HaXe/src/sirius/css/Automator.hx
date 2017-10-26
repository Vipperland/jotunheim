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
		grid: false,
	};
	
	
	/**
	 * Create all cell styles
	 * @param	size
	 */
	static private function _createGrid(size:Int):Void {
		if (!_inits.grid){
			omnibuild('display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-flex-wrap:wrap;-ms-flex-wrap:wrap;flex-wrap:wrap;width:100%;', '.shelf');
			// Auto grow
			omnibuild('-webkit-box-flex:1;-ms-flex-positive:1;flex-grow:1;-ms-flex-preferred-size:0;flex-basis:0;max-width:100%;', '.cel');
			// Pack will align left, center or right
			omnibuild('-webkit-box-pack:center;','.o-center');
			omnibuild('-webkit-box-pack:start;-ms-flex-pack:start;justify-content:flex-start;text-align:start;', '.o-left');
			omnibuild('-webkit-box-pack:end;-ms-flex-pack:end;justify-content:flex-end;text-align:end;', '.o-right');
			// Lift will align top, middle and bottom
			omnibuild('-webkit-box-align:start;-ms-flex-align:start;align-items:flex-start;','.o-top');
			omnibuild('-webkit-box-align:center;-ms-flex-align:center;align-items:center;','.o-middle');
			omnibuild('-webkit-box-align:end;-ms-flex-align:end;align-items:flex-end;', '.o-bottom');
			// Fill empty spaces around the cells
			omnibuild('-ms-flex-pack:distribute;justify-content: space-around;', '.o-arrange');
			// Fill empty spaces between the cells
			omnibuild('-webkit-box-pack:justify;-ms-flex-pack:justify;justify-content: space-between;', '.o-fill');
			// Order by right to left instead of left to right
			omnibuild('-webkit-box-direction:reverse;-ms-flex-direction:row-reverse;flex-direction:row-reverse;', '.o-reverse');
			
			var i:Int = 1;
			while (i < 12){
				omnibuild('-webkit-box-ordinal-group:-' + i + ';-ms-flex-order:-' + i + ';order:-' + i + ';', '.o-left-' + i);
				omnibuild('-webkit-box-ordinal-group:' + i + ';-ms-flex-order:' + i + ';order:' + i + ';', '.o-right-' + i);
				++i;
			}
			_inits.grid = true;
		}
		Dice.Count(0, size, function(a:Int, b:Int, c:Bool) {
			++a;
			var t:String = (cast (a / b * 100)).toFixed(16) + '%';
			var s:String = "-webkit-box-flex:0;-webkit-flex:0 0 " + t + ";-ms-flex:0 0 " + t + ";flex: 0 0 " + t + ";max-width:" + t + ";padding: 0 0.5rem;position:relative;";
			var n:String = 'cel-' + a + (b == 12 ? '' : 'x' + b);	// .cel-AxB | .cel-A
			omnibuild(s, '.'+n); // w-00d00pc padd-10
			if (a < b) 
				omnibuild('margin-left:' + t, '.x-' + n);
			return null;
		});
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
	
	
	static public function reset():Void {
		if (!_inits.reset){
			_inits.reset = true;
			css.add('html{line-height:1.15;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;}body{margin:0;}article,aside,footer,header,nav,section{display:block;}h1{font-size:2em;margin:0.67em 0;}figcaption,figure,main{display:block;}figure{margin:1em 40px;}hr{box-sizing:content-box;height:0;overflow:visible;}pre{font-family:monospace, monospace;font-size:1em;}a{background-color:transparent;-webkit-text-decoration-skip:objects;}abbr[title]{border-bottom:none;text-decoration:underline;text-decoration:underline dotted;}b,strong{font-weight:inherit;}b,strong{font-weight:bolder;}code,kbd,samp{font-family:monospace, monospace;font-size:1em;}dfn{font-style:italic;}mark{background-color:#ff0;color:#000;}small{font-size:80%;}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline;}sub{bottom:-0.25em;}sup{top:-0.5em;}audio,video{display:inline-block;}audio:not([controls]){display:none;height:0;}img{border-style:none;}svg:not(:root){overflow:hidden;}button,input,optgroup,select,textarea{font-family:sans-serif;font-size:100%;line-height:1.15;margin:0;border:0;}button,input{overflow:visible;}button,select{text-transform:none;}button,[type="button"],[type="reset"],[type="submit"]{-webkit-appearance:button;}button::-moz-focus-inner,[type="button"]::-moz-focus-inner,[type="reset"]::-moz-focus-inner,[type="submit"]::-moz-focus-inner{border-style:none;padding:0;}button:-moz-focusring,[type="button"]:-moz-focusring,[type="reset"]:-moz-focusring,[type="submit"]:-moz-focusring{outline:1px dotted ButtonText;}fieldset{padding:0.35em 0.75em 0.625em;}legend{box-sizing:border-box;color:inherit;display:table;max-width:100%;padding:0;white-space:normal;}progress{display:inline-block;vertical-align:baseline;}textarea{overflow:auto;}[type="checkbox"],[type="radio"]{box-sizing:border-box;padding:0;}[type="number"]::-webkit-inner-spin-button,[type="number"]::-webkit-outer-spin-button{height:auto;}[type="search"]{-webkit-appearance:textfield;outline-offset:-2px;}[type="search"]::-webkit-search-cancel-button,[type="search"]::-webkit-search-decoration{-webkit-appearance:none;}::-webkit-file-upload-button{-webkit-appearance:button;font:inherit;}details,menu{display:block;}summary{display:list-item;}canvas{display:inline-block;}template{display:none;}[hidden]{display:none;}*{box-sizing:border-box;}');
			//css.add();
			grid(12);
			css.build();
			Sirius.run(scan);
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
	
	static public function apply():Void {
		css.build();
	}
	
	/**
	 * Build the selector for all resolution modes
	 * @param	query
	 * @param	group
	 * @param	silent
	 */
	static public function omnibuild(query:String, ?group:String):Void {
		if(query.indexOf(':') == -1){
			build(query, group + '-xs'	, true);
			build(query, group + '-sm'	, true);
			build(query, group + '-md'	, true);
			build(query, group + '-lg'	, true);
			build(query, group + '-pr'	, true);
			build(query, group 			, true);
		}else{
			css.add(group + '-xs' + '{' + query + '}', 'xs');
			css.add(group + '-sm' + '{' + query + '}', 'sm');
			css.add(group + '-md' + '{' + query + '}', 'md');
			css.add(group + '-lg' + '{' + query + '}', 'lg');
			css.add(group + '-pr' + '{' + query + '}', 'pr');
			css.add(group +         '{' + query + '}', null);
		}
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
						if (!css.exists(v, m)) { // Check if selector exists
							s = _parse(c).build(); // Create class for selector
							if (Utils.isValid(s)) { // Check if value is valid
								if (_dev == true) 
									Sirius.log("Automator => ." + v + " {" + s + ";}", 1);
								css.set('.' + v, s, m); // Add selector to correspondent @media group
							}
						}
					}
				}
			}
		});
		if (g && Utils.isValid(r)) { // If is a group, register all classes to correspondent group and @media value
			if (_dev == true) 
				Sirius.log("Automator => " + group + " {" + r + "}", 1);
			css.set(group, r, m);
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
			Dice.Values(size, function(v:Int) {	_createGrid(v); });
			Reflect.setField(_inits, 'grid-' + size, true);
		}
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
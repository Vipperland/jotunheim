package sirius.css;
import js.html.Element;
import sirius.Sirius;
import sirius.css.CSSGroup;
import sirius.css.IKey;
import sirius.dom.IDisplay;
import sirius.dom.Style;
import sirius.dom.Svg;
import sirius.math.ARGB;
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
	
	static private var _filters:Svg;
	
	static private var _motions:Style;
	
	static private var _inits:Dynamic = {
		reset : false,
		grid: false,
	};
	
	
	/**
	 * Create all cell styles
	 * @param	size
	 */
	static private function _createGrid():Void {
		if (!_inits.grid){
			/*
				SHELf = [0,1,2,3,4] 	== ROW, NO WRAP
							+ o-stack  to reverse
				|
				
				HACK = [0,1,2,3,4		== ROW + COLUMNS
				|		5,6,7,8,9]
							+ o-stack  to reverse
				
				DRAWER = 	[0,		== COLUMN
				|			 1,
				|			 2]
							+ o-stack  to reverse
				
				Placement
				|	cel					AUTO width
				|	cel-X (x = 1~12)
				|	rcell-X (x = 1~12) 	Empty cell
				|	tag-X (x = 1~12)		Cardinal count
				
				Distribuition
				|	o-arrange		Space around
				|	o-welfit			Space between
				|
				
				Alignment:
				|	o-top-left		o-top			o-top-right		
				|	o-left			[h|v|o]-middle	o-right			
				|	o-bottom-left		o-bottom			o-bottom-right	
			*/
			omnibuild('display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;', '.shelf,.hack,.drawer');
			omnibuild('-webkit-flex-wrap:nowrap;-ms-flex-wrap:nowrap;flex-wrap:nowrap;', '.shelf');
			omnibuild('-webkit-flex-wrap:wrap;-ms-flex-wrap:wrap;flex-wrap:wrap;', '.hack,.drawer');
			omnibuild('-webkit-box-direction:column;-ms-flex-direction:column;flex-direction:column;', '.drawer');
			// Auto grow
			omnibuild('-webkit-box-flex:1;-ms-flex-positive:1;flex-grow:1;-ms-flex-preferred-size:0;flex-basis:0;max-width:100%;', '.cel');
			// Pack will align left, center or right
			omnibuild('-webkit-box-pack:start;-ms-flex-pack:start;justify-content:flex-start;text-align:start;', '.o-left,.o-top-left,.o-bottom-left');
			omnibuild('-webkit-box-pack:center;-ms-flex-pack:center;justify-content:center;', '.v-middle,.o-middle');
			omnibuild('-webkit-box-pack:end;-ms-flex-pack:end;justify-content:flex-end;text-align:end;', '.o-right,.o-top-right,o-bottom-right');
			// Lift will align top, middle and bottom
			omnibuild('-webkit-box-align:start;-ms-flex-align:start;align-items:flex-start;','.o-top,.o-top-left,.o-top-right');
			omnibuild('-webkit-box-align:center;-ms-flex-align:center;align-items:center;','.h-middle,.o-middle');
			omnibuild('-webkit-box-align:end;-ms-flex-align:end;align-items:flex-end;', '.o-bottom,.o-bottom-left,.o-bottom-right');
			// Fill empty spaces around the cells
			omnibuild('-ms-flex-pack:distribute;justify-content: space-around;', '.o-arrange');
			// Fill empty spaces between the cells
			omnibuild('-webkit-box-pack:justify;-ms-flex-pack:justify;justify-content: space-between;', '.o-wellfit');
			// Order by right to left instead of left to right
			omnibuild('-webkit-box-direction:reverse;-ms-flex-direction:row-reverse;flex-direction:row-reverse;', '.shelf.o-stack,.hack.o-stack');
			omnibuild('-webkit-box-direction:column;-ms-flex-direction:column-reverse;flex-direction:column-reverse;', '.drawer.o-stack');
			// Wrap modes
			omnibuild('-webkit-flex-wrap:wrap-reverse;flex-wrap:wrap-reverse;', '.hack.o-stack');
			Dice.Count(0, 12, function(a:Int, b:Int, c:Bool) {
				// Create order selectors, positive and negative (-12 to 12)
				if(a > 0){
					omnibuild('-webkit-box-ordinal-group:-' + a + ';-ms-flex-order:-' + a + ';order:-' + a + ';', '.tag-' + a + 'n');
				}
				omnibuild('-webkit-box-ordinal-group:' + a + ';-ms-flex-order:' + a + ';order:' + a + ';', '.tag-' + a);
				++a;
				// Create cel values (from 1 to 12), the .001 value fix some gaps between the cells
				var m:Float = cast (a / b * 100 - .001);
				var t:String = (cast m).toFixed(5) + '%';
				var s:String = "flex-basis:" + t + ";max-width:" + t;
				omnibuild(s, '.cel-' + a);
				if (a < b) {
					omnibuild('margin-left:' + t, '.rcell-' + a);
				}
				return null;
			});
			_inits.grid = true;
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
			omnibuild('display:none !important;', '.hidden');
			_createGrid();
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
			parse(o.element.innerText, o.attribute('automator').toLowerCase() == 'all');
			o.dispose();
		});
		css.build(); // Apply changes + Append to ScriptElement
	}
	
	static public function search(t:Dynamic):Void {
		if (t == null) {
			return;
		}
		if(!Std.is(t,String)){
			if (Std.is(t, IDisplay)) {
				t = t.element.outerHTML;
			}else if (Std.is(t, Element)){
				t = t.outerHTML;
			}else {
				t = Std.string(t);
			}
		}
		var t:Array<String> = t.split("class=");	// Search all class entries
		if (t.length > 0) {
			t.shift();
		}
		Dice.Values(t, function(v:String) {
			var i:String = v.substr(0, 1);	// class=["] (string start)
			var j:Int = v.indexOf(i, 1);	// class="["] (string end)
			if (j > 1) {
				v = v.substring(1, j);		// Remove quotes (single & double)
				if (v.length > 0) {
					build(v,null,true);	// If result is not empty
				}
			}
		});
		css.build(); // Apply changes / Append to ScriptElement
	}
	
	static public function style(group:String, value:String):Void {
		css.add(group + '{' + value + '}');
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
		var g:Bool = group != null && group.length > 0;
		if (query.indexOf(':') == -1){
			query = build(query, group, true).style;
		}else if (g){
			css.add(group + '{' + query + '}', null);
		}
		if (g){
			css.styleXS += (group.split(',').join('-xs,') + '-xs' + '{' + query + '}');
			css.styleSM += (group.split(',').join('-sm,') + '-sm' + '{' + query + '}');
			css.styleMD += (group.split(',').join('-md,') + '-md' + '{' + query + '}');
			css.styleLG += (group.split(',').join('-lg,') + '-lg' + '{' + query + '}');
			css.stylePR += (group.split(',').join('-pr,') + '-pr' + '{' + query + '}');
		}
		
	}
	
	/**
	 * Create selectors from string
	 * @param	query
	 * @param	group
	 */
	static public function build(?query:String, ?group:String, ?silent:Bool):Dynamic {
		
		if (query == null || query == ''){
			css.build();
			return null;
		}
		
		var c:Array<String> = query.split(" ");						// Split class names
		var m:String = null;										// MediaQueries rule
		var s:String;												// Final selector
		var g:Bool = Utils.isValid(group);							// Is a valid group?
		var r:String = ''; 	
		// Group value, if available
		if (g && group.length > 0) {
			m = _screen(group.split("-"));	// Remove MediaQuery rule from group name
		}
		
		Dice.Values(c, function(v:String) {
			if (v.length > 1) {
				v = v.split("\r").join(" ").split("\n").join(" ").split("\t").join(" "); // Remove linebreaks invalid characters from class names
				c = v.split("-"); // create sections
				if (c.length > 0) {
					if (c[0] == 'ref') {
						return;
					}
					if (g) { // Rule for groups
						_screen(c); // Remove @media signature
						var en:Entry = _parse(c);
						s = en.build(); // Create class for selector
						if (Utils.isValid(s)) {
							r += s + ";";
						} else if (_dev == true) {
							Sirius.log("Automator => ERROR (" + en + ")");
						}
					}else { // Rule for single class name
						m = _screen(c); // Target @media
						if (!css.exists(v, m)) { // Check if selector exists
							s = _parse(c).build(); // Create class for selector
							if (Utils.isValid(s)) { // Check if value is valid
								if (_dev == true) {
									Sirius.log("Automator => ." + v + " {" + s + ";}", 1);
								}
								css.set('.' + v, s, m); // Add selector to correspondent @media group
								r += s + ";";
							}
						}
					}
				}
			}
		});
		if (g && Utils.isValid(r)) { // If is a group, register all classes to correspondent group and @media value
			if (_dev == true) {
				Sirius.log("Automator => " + group + " {" + r + "}", 1);
			}
			css.set(group, r, m);
		}
		if (silent == null || silent == false) {
			css.build();
		}
		return {style:r, group:group, media:m};
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
	
	static public function createFilter(id:String, a:Float, r:Float, g:Float, b:Float):Void {
		if (_filters == null){
			_filters = new Svg();
			Sirius.document.head.addChild(_filters);
		}
		var filter:IDisplay = _filters.one('#' + id);
		if (filter != null){
			_filters.removeChild(filter);
		}
		var end:String = "<filter id=\"" + id + "\" color-interpolation-filters=\"sRGB\" x=\"0\" y=\"0\" height=\"100%\" width=\"100%\">";
			end += "<feColorMatrix type=\"matrix\" values=\"" + r + " 0 0 0 0 0 " + g + " 0 0 0 0 0 " + b + " 0 0 0 0 0 " + a + " 0\"/>";
			end += "</filter>";
		_filters.appendHtml(end);
	}
	
	static public function clearDisplacements():Void {
		if (_filters != null){
			_filters.empty(true);
		}
	}
	
	static public function createDisplacement(id:String, freq:Float, octaves:Int, scale:Int, ?seed:Int=0):Void {
		if (_filters == null){
			_filters = new Svg();
			Sirius.document.head.addChild(_filters);
		}
		var filter:IDisplay = _filters.one('#' + id);
		if (filter != null){
			_filters.removeChild(filter);
		}
		var end:String = "<filter id=\"" + id + "\">";
			end += "<feTurbulence baseFrequency=\"" + freq + "\" numOctaves=\"" + octaves + "\" result=\"noise\" seed=\"" + seed + "\"/>";
			end += "<feDisplacementMap id=\"displacement\" in=\"SourceGraphic\" in2=\"noise\" scale=\"" + scale + "\" />";
			end += "</filter>";
		_filters.appendHtml(end);
	}
	
	
	
	static public function createMotionFor(name:String, time:Float, values:Array<String>):Void {
		if (_motions == null){
			_motions = new Style();
			_motions.publish();
		}
		var css:String = '@keyframes ' + name + '{';
		var len:Int = values.length;
		Dice.All(values, function(p:String, v:Dynamic){
			var i:Int = Std.int(Std.parseInt(p) / len);
			css += i + '%{' + v + '}'; 
		});
		css += '} animation: ' + name + ' ' + time + 's linear infinite; /*EOF ' + name + '*/';
		_motions.appendHtml(css);
	}
	
}
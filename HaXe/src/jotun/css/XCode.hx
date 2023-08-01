package jotun.css;
import jotun.utils.IColor;
import js.html.Element;
import jotun.Jotun;
import jotun.css.CSSGroup;
import jotun.dom.IDisplay;
import jotun.dom.Style;
import jotun.dom.Svg;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('XCode')
class XCode {
	
	static private var css:CSSGroup = new CSSGroup();
	
	static private var _filters:Svg;
	
	static private var _motions:Style;
	
	static private var _morph_rules:Array<Array<String>>;
	
	static private var _inits:Dynamic = {
		reset : false,
		grid: false,
	};
	
	static function _filterCheck(id:String, replace:Bool):Bool {
		if (_filters == null){
			_filters = new Svg();
			Jotun.document.head.addChild(_filters);
		}
		var filter:IDisplay = _filters.one('#' + id);
		if (filter != null){
			if (replace){
				_filters.removeChild(filter);
				return true;
			}else{
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Create all cell styles
	 * @param	size
	 */
	static private function _createGrid():Void {
		if (!_inits.grid){
			/*
				SHELF = [0,1,2,3,4] 	== ROW, NO WRAP
							+ o-stack  to reverse
				|
				
				HACK = [0,1,2,3,4		== ROW + COLUMNS
				|       5,6,7,8,9]
							+ o-stack  to reverse
				
				DRAWER = 	[0,		== COLUMN
		|			 1,
		|			 2]
							+ o-stack  to reverse
				
				Placement
				|	cel		AUTO width
				|	cel-X (x = 1~12)
				|	rcell-X (x = 1~12) 	Empty cell
				|	tag-X (x = 1~12)	Cardinal count
				
				Distribuition
				|	o-arrange			Space around
				|	o-welfit			Space between
				|
				
				Alignment:
				|	o-top-left		o-top			o-top-right		
				|	o-left			[h|v|o]-middle		o-right			
				|	o-bottom-left		o-bottom			o-bottom-right	
			*/
			omnibuild('.shelf,.hack,.drawer', 'display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;');
			omnibuild('.shelf', '-webkit-flex-wrap:nowrap;-ms-flex-wrap:nowrap;flex-wrap:nowrap;');
			omnibuild('.hack,.drawer', '-webkit-flex-wrap:wrap;-ms-flex-wrap:wrap;flex-wrap:wrap;');
			omnibuild('.drawer', '-webkit-box-direction:column;-ms-flex-direction:column;flex-direction:column;');
			// Auto grow
			omnibuild('.cel', '-webkit-box-flex:1;-ms-flex-positive:1;flex-grow:1;-ms-flex-preferred-size:0;flex-basis:0;max-width:100%;');
			// Pack will align left, center or right
			omnibuild('.o-left,.o-top-left,.o-bottom-left', '-webkit-box-pack:start;-ms-flex-pack:start;justify-content:flex-start;text-align:start;');
			omnibuild('.a-middle,.o-middle', '-webkit-box-pack:center;-ms-flex-pack:center;justify-content:center;');
			omnibuild('.o-right,.o-top-right,o-bottom-right', '-webkit-box-pack:end;-ms-flex-pack:end;justify-content:flex-end;text-align:end;');
			// Lift will align top, middle and bottom
			omnibuild('.o-top,.o-top-left,.o-top-right', '-webkit-box-align:start;-ms-flex-align:start;align-items:flex-start;');
			omnibuild('.x-middle,.o-middle', '-webkit-box-align:center;-ms-flex-align:center;align-items:center;');
			omnibuild('.o-bottom,.o-bottom-left,.o-bottom-right', '-webkit-box-align:end;-ms-flex-align:end;align-items:flex-end;');
			// Fill empty spaces around the cells
			omnibuild('.o-outer-fill', '-ms-flex-pack:distribute;justify-content: space-around;');
			// Fill empty spaces between the cells
			omnibuild('.o-inner-fill', '-webkit-box-pack:justify;-ms-flex-pack:justify;justify-content: space-between;');
			// Order by right to left instead of left to right
			omnibuild('.shelf.o-reverse,.hack.o-stack', '-webkit-box-direction:reverse;-ms-flex-direction:row-reverse;flex-direction:row-reverse;');
			omnibuild('.drawer.o-reverse', '-webkit-box-direction:column;-ms-flex-direction:column-reverse;flex-direction:column-reverse;');
			// Wrap modes
			omnibuild('.hack.o-reverse', '-webkit-flex-wrap:wrap-reverse;flex-wrap:wrap-reverse;');
			Dice.Count(0, 12, function(a:Int, b:Int, c:Bool) {
				// Create order selectors, positive and negative (-12 to 12)
				if(a > 0){
					omnibuild('.tag-' + a + 'n', '-webkit-box-ordinal-group:-' + a + ';-ms-flex-order:-' + a + ';order:-' + a + ';');
				}
				omnibuild('.tag-' + a, '-webkit-box-ordinal-group:' + a + ';-ms-flex-order:' + a + ';order:' + a + ';');
				++a;
				// Create cel values (from 1 to 12), the .001 value fix some gaps between the cells
				var m:Float = cast (a / b * 100 - .001);
				var t:String = (cast m).toFixed(5) + '%';
				var s:String = "flex-basis:" + t + ";max-width:" + t;
				omnibuild('.cel-' + a, s);
				if (a < b) {
					omnibuild('.rcell-' + a, 'margin-left:' + t);
				}
				return null;
			});
			_inits.grid = true;
		}
	}
	
	static public function reset():Void {
		if (!_inits.reset){
			_inits.reset = true;
			function cor(i:Int, q:String):String {
				return '.container'+q+'{max-width:' + i + 'px;}';
			}
			css.add('html{line-height:1.15;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;}body{margin:0;}article,aside,footer,header,nav,section{display:block;}h1{font-size:2em;margin:0.67em 0;}figcaption,figure,main{display:block;}figure{margin:1em 40px;}hr{box-sizing:content-box;height:0;overflow:visible;}pre{font-family:monospace, monospace;font-size:1em;}a{background-color:transparent;-webkit-text-decoration-skip:objects;}abbr[title]{border-bottom:none;text-decoration:underline;text-decoration:underline dotted;}b,strong{font-weight:inherit;}b,strong{font-weight:bolder;}code,kbd,samp{font-family:monospace, monospace;font-size:1em;}dfn{font-style:italic;}mark{background-color:#ff0;color:#000;}small{font-size:80%;}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline;}sub{bottom:-0.25em;}sup{top:-0.5em;}audio,video{display:inline-block;}audio:not([controls]){display:none;height:0;}img{border-style:none;}svg:not(:root){overflow:hidden;}button,input,optgroup,select,textarea{font-family:sans-serif;font-size:100%;line-height:1.15;margin:0;border:0;}button,input{overflow:visible;}button,select{text-transform:none;}button,[type="button"],[type="reset"],[type="submit"]{-webkit-appearance:button;}button::-moz-focus-inner,[type="button"]::-moz-focus-inner,[type="reset"]::-moz-focus-inner,[type="submit"]::-moz-focus-inner{border-style:none;padding:0;}button:-moz-focusring,[type="button"]:-moz-focusring,[type="reset"]:-moz-focusring,[type="submit"]:-moz-focusring{outline:1px dotted ButtonText;}fieldset{padding:0.35em 0.75em 0.625em;}legend{box-sizing:border-box;color:inherit;display:table;max-width:100%;padding:0;white-space:normal;}progress{display:inline-block;vertical-align:baseline;}textarea{overflow:auto;}[type="checkbox"],[type="radio"]{box-sizing:border-box;padding:0;}[type="number"]::-webkit-inner-spin-button,[type="number"]::-webkit-outer-spin-button{height:auto;}[type="search"]{-webkit-appearance:textfield;outline-offset:-2px;}[type="search"]::-webkit-search-cancel-button,[type="search"]::-webkit-search-decoration{-webkit-appearance:none;}::-webkit-file-upload-button{-webkit-appearance:button;font:inherit;}details,menu{display:block;}summary{display:list-item;}canvas{display:inline-block;}template{display:none;}[hidden]{display:none;}*{box-sizing:border-box;}');
			css.style += '.container-s,.container,.container-l{width:100%;}';
			css.styleXS += cor(480,'');
			css.styleSM += cor(540,'');
			css.styleMD += cor(640,'');
			css.styleLG += cor(1024,'');
			css.styleXL += cor(1600, '');
			omnibuild('.hidden', 'display:none !important;');
			_createGrid();
			commit();
		}
	}
	
	static public function style(selector:String, value:Dynamic, ?mode:String):Void {
		if (!Std.isOfType(value, String)){
			var r:String = '';
			Dice.All(value, function(p:String, v:Dynamic):Void {
				r += (r == '' ? '' : ';') + (p + ': ' + v);
			});
			value = r;
		}
		css.add(selector + '{' + value + '}', mode);
	}
	
	static public function media(a:String, b:String, style:String):String {
		return  '@media ' + a + (b != null ? ' and ' + b : '') + '{ ' + style + '}';
	}
	
	static public function morph(q:String):String {
		if(_morph_rules == null){
			var e:String = ' and ';
			var m:String = '@media ';
			_morph_rules = [
				// FROM MIN TO MAX
				['~@XS', e + CSSGroup.MEDIA_XS_MAX],
				['~@SM', e + CSSGroup.MEDIA_SM_MAX],
				['~@MD', e + CSSGroup.MEDIA_MD_MAX],
				['~@LG', e + CSSGroup.MEDIA_LG_MAX],
				// LESS OR
				['@XS-', m + CSSGroup.MEDIA_XS_MAX],
				['@SM-', m + CSSGroup.MEDIA_SM_MAX],
				['@MD-', m + CSSGroup.MEDIA_MD_MAX],
				['@LG-', m + CSSGroup.MEDIA_LG_MAX],
				// GREATER OR
				['@XS', m + CSSGroup.MEDIA_XS],
				['@SM', m + CSSGroup.MEDIA_SM],
				['@MD', m + CSSGroup.MEDIA_MD],
				['@LG', m + CSSGroup.MEDIA_LG],
				['@XL', m + CSSGroup.MEDIA_XL],
			];
		}
		Dice.Values(_morph_rules, function(v:Array<String>){
			q = q.split(v[0]).join(v[1]);
		});
		return q;
	}
	
	static public function commit():Void {
		css.build();
	}
	
	/**
	 * Build the selector for all resolution modes
	 * @param	query
	 * @param	group
	 * @param	silent
	 */
	static public function omnibuild(selector:String, query:String):Void {
		build(selector, query);
		css.styleXS += (selector.split(',').join('-xs,') + '-xs' + '{' + query + '}');
		css.styleSM += (selector.split(',').join('-sm,') + '-sm' + '{' + query + '}');
		css.styleMD += (selector.split(',').join('-md,') + '-md' + '{' + query + '}');
		css.styleLG += (selector.split(',').join('-lg,') + '-lg' + '{' + query + '}');
		css.styleXL += (selector.split(',').join('-xl,') + '-xl' + '{' + query + '}');
		css.stylePR += (selector.split(',').join('-pr,') + '-pr' + '{' + query + '}');
	}
	
	static public function build(selector:String, query:String):Void {
		css.style += (selector + '{' + query + '}');
	}
	
	static public function clearDisplacements():Void {
		if (_filters != null){
			_filters.empty(true);
		}
	}
	
	static public function filter(id:String, a:Float, r:Float, g:Float, b:Float, ?replace:Bool):Void {
		if(_filterCheck(id, replace)){
			var end:String = "<filter id=\"" + id + "\" color-interpolation-filters=\"sRGB\" x=\"0\" y=\"0\" height=\"100%\" width=\"100%\">";
				end += "<feColorMatrix type=\"matrix\" values=\"" + r + " 0 0 0 0 0 " + g + " 0 0 0 0 0 " + b + " 0 0 0 0 0 " + a + " 0\"/>";
				end += "</filter>";
			_filters.appendHtml(end);
		}
	}
	
	/**
	 * 
	 * @param	id
	 * @param	freq		FLOAT (low values = less noise)
	 * @param	octaves	INT	(higher values = more natural, +cpu intensive)
	 * @param	scale		FLOAT	(wave length)
	 * @param	seed		INT	
	 * @param	replace	
	 */
	static public function displacement(id:String, freq:Float, octaves:Int, scale:Int, ?seed:Int=0, ?replace:Bool = true):Void {
		if(_filterCheck(id, replace)){
			var end:String = "<filter id=\"" + id + "\">";
				end += "<feTurbulence baseFrequency=\"" + freq + "\" numOctaves=\"" + octaves + "\" result=\"noise\" seed=\"" + seed + "\"/>";
				end += "<feDisplacementMap id=\"" + id + "-map\" in=\"SourceGraphic\" in2=\"noise\" scale=\"" + scale + "\" />";
				end += "</filter>";
			_filters.appendHtml(end);
		}
	}
	
	/**
	 * 
	 * @param	id
	 * @param	data
	 * @param	width
	 * @param	height
	 * @param	x
	 * @param	y
	 * @param	replace
	 */
	static public function imageFilter(id:String, data:String, width:String, height:String, x:String, y:String, ?replace:Bool = true):Void {
		if(_filterCheck(id, replace)){
			var end:String = "<filter id=\"" + id + "\">";
				end += "<feImage x=\"" + x + "\" y=\"" + y + "\" width=\"" + width + "\" height=\"" + height + "\" result=\"" + id + "-res\" xlink:href=\"" + data + "\"/>";
				end += "<feDisplacementMap id=\"" + id + "-map\" xChannelSelector=\"R\" yChannelSelector=\"G\" in=\"SourceGraphic\" in2=\"" + id + "-res\" result=\"displacementMap\" color-interpolation-filters=\"sRGB\" scale=\"100\"/>";
				end += "<feComposite operator=\"in\" in2=\"" + id + "-res\"></feComposite>";
				end += "</filter>";
			_filters.appendHtml(end);
		}
	}
	
	static public function stroke(id:String, text:Bool, color:String, ?strenght:Int, ?blur:Int):String {
		var l:Int = Utils.getValidOne(strenght, 1);
		var b:Int = Utils.getValidOne(blur, 1);
		var x:Int = 0;
		var s:Array<String> = [];
		var t:String = Utils.getValidOne(blur, 1) + 'px ' + color;
		while (x < l) {
			++x;
			if(x != 0){
				var xs:String = x + 'px';
				s[s.length] = '-' + xs + ' 0 ' + t;
				s[s.length] = '0 ' + xs + ' ' + t;
				s[s.length] = '' + xs + ' 0 ' + t;
				s[s.length] = '0 -' + xs + ' ' + t;
				if (x % 2 == 0){
					//xs = Std.int(x/2) + 'px';
					s[s.length] = '-' + xs + ' -' + xs + ' ' + t;
					s[s.length] = '' + xs + ' -' + xs + ' ' + t;
					s[s.length] = '-' + xs + ' ' + xs + ' ' + t;
					s[s.length] = '' + xs + ' ' + xs + ' ' + t;
				}
			}
		}
		omnibuild(id, (text ? 'text-shadow' : 'box-shadow') + ':' + s.join(','));
		return id;
	}
	
	static public function shadow(id:String, text:Bool, color:String, ?distance:Int, ?direction:Int, ?float:Int, ?steps:Int, ?multiplier:Float):String {
		var cc:IColor = Utils.color(color);
		var y:Int = 0;
		var z:Int = Utils.getValidOne(distance, text ? 1 : 5);
		var a:Int = Utils.getValidOne(direction, 45);
		var w:Int = Utils.getValidOne(steps, 5);
		var u:Int = Utils.getValidOne(float, 10);
		var c:Float = Utils.getValidOne(multiplier, .5)/1 * .85;
		var cos:Float = Math.cos(.017453 * a);
		var sin:Float = Math.sin(.017453 * a);
		var r:Array<String> = [];
		var tx:Int = 0;
		var ty:Int = 0;
		if (a % 90 == 0){
			w = z;
		}
		w = Math.floor(cast z / w);
		if (w <= 0) {
			w = 1;
		}
		while (y < z) {
			y += w;
			if (y > z) {
				y = z;
			}
			tx = (cast cos * y);
			ty = (cast sin * y);
			r[r.length] = (tx == 0 ? '0' : Math.round(tx) + 'px') + ' ' + (ty == 0 ? '0' : Math.round(ty) + 'px') + ' 0 ' + Utils.colorToCss(cc, .85-(y/z*c));
		}
		y = 0;
		var oX:Float = cos * z;
		var oY:Float = sin * z;
		while (y < u) {
			y += w;
			if (y > u) {
				y = u;
			}
			tx = (cast cos * y + oX);
			ty = (cast sin * y + oY);
			r[r.length] = (tx == 0 ? '0' : Math.round(tx) + 'px') + ' ' + (ty == 0 ? '0' : Math.round(ty) + 'px') + ' 0 rgb(0 0 0/.1)';
		}
		var q:String = (text ? 'text-shadow' : 'box-shadow') + ':' + r.join(',');
		omnibuild(id, q);
		return id;
	}
	
	static public function motion(name:String, time:Float, values:Array<String>):Void {
		if (_motions == null){
			_motions = new Style();
			_motions.publish();
		}
		var css:String = '@keyframes ' + name + '{';
		var len:Int = values.length;
		Dice.All(values, function(p:String, v:Dynamic):Void {
			var i:Int = Std.int(Std.parseInt(p) / len);
			css += i + '%{' + v + '}'; 
		});
		css += '} animation: ' + name + ' ' + time + 's linear infinite; /*EOF ' + name + '*/';
		_motions.appendHtml(css);
	}
	
}
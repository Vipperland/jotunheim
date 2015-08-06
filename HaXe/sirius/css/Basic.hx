package sirius.css;
import haxe.Log;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.css.Basic")
class Basic extends CSS {
	/**
	 * Margin
	 * Width
	 * Height
	 */
	public function new() {
		
		super(true,true);
		
		setSelector(".disp-none", 			"display:none;");
		setSelector(".disp-block", 			"display:block;");
		setSelector(".disp-inline", 		"display:inline;");
		setSelector(".disp-inline-block",	"display:inline-block;");
		setSelector(".vert-baseline",		"vertical-align:baseline;");
		setSelector(".vert-t",				"vertical-align:top;");
		setSelector(".vert-m",				"vertical-align:middle;");
		setSelector(".vert-b",				"vertical-align:bottom;");
		setSelector(".vert-txt-t",			"vertical-align:text-top;");
		setSelector(".vert-txt-b",			"vertical-align:text-bottom;");
		setSelector(".vert-sub", 			"vertical-align:sub;");
		setSelector(".vert-sup", 			"vertical-align:super;");
		setSelector(".pos-abs", 			"position:absolute;");
		setSelector(".pos-rel", 			"position:relative;");
		setSelector(".pos-fix", 			"position:fixed;");
		setSelector(".pull-r",				"float:right;");
		setSelector(".pull-l",				"float:left;");
		setSelector(".pull-n", 				"float:none;");
		setSelector(".over-hid", 			"overflow:hidden;");
		setSelector(".over-scroll",			"overflow:scroll;");
		setSelector(".scroll-x", 			"overflow-x:scroll;overflow-y:hidden;");
		
		setSelector(".scroll-y", 			"overflow-y:scroll;overflow-x:hidden;");
		setSelector(".txt-l",				"text-align:left;");
		setSelector(".txt-r",				"text-align:right;");
		setSelector(".txt-c",				"text-align:center;");
		setSelector(".txt-j",				"text-align:justify;");
		
		setSelector(".bold", 				"font-weight:bold;");
		setSelector(".regular", 			"font-weight:normal;");
		setSelector(".underline", 			"font-weight:underline;");
		setSelector(".italic", 				"font-weight:italic;");
		setSelector(".thin", 				"font-weight:100;");
		setSelector(".up-case", 			"font-transform:uppercase");
		setSelector(".lo-case", 			"font-transform:lowercase");
		
		setSelector(".curs-pointer", 		"cursor:pointer");
		setSelector(".curs-loading", 		"cursor:loading");
		setSelector(".curs-default", 		"cursor:default");
		
		setSelector(".arial", 				"font-family:arial;");
		setSelector(".verdana", 			"font-family:verdana;");
		setSelector(".tahoma",	 			"font-family:tahoma;");
		setSelector(".lucida",	 			"font-family:lucida console;");
		setSelector(".georgia", 			"font-family:georgia;");
		setSelector(".trebuchet", 			"font-family:trebuchet ms;");
		setSelector(".segoe",	 			"font-family:segoe ui;");
		
		setSelector(".disp-tab",			"display:table;");
		setSelector(".disp-tab-cell", 		"display:table-cell");
		
		setSelector(".bord-solid", 			"border-style:solid");
		setSelector(".bord-dashed", 		"border-style:dashed");
		setSelector(".bord-double", 		"border-style:double");
		setSelector(".bord-dotted", 		"border-style:dotted");
		
	}
	
	/**
	 * Negative and positive selectors (INT)
	 * @param	m
	 * @param	a
	 */
	private function _normal(m:String, a:Int):Void {
		
		/**
		 *  t-50  		top: 50px;
		 *  t-50n		top:-50px;
		 *  t-50i		top:-50px !important;
		 *  t-50pc		top: 50%;
		 *  t-50pc10		top: 50.10%;
		 */
		
		if (a < 0)	m += "n";
		if (a > -300) {
			setSelector(".z" + m,		"z-index:" + a + ";");
		}
		
		setSelector(".o" + m, 			"outline:" + a + ";");
		setSelector(".w" + m, 			"width:" + a + "px;");
		setSelector(".h" + m, 			"height:" + a + "px;");
		setSelector(".wh" + m,			"width:" + a + "px;height:" + a + "px;");
		setSelector(".t" + m, 			"top:" + a + "px;");
		setSelector(".b" + m, 			"bottom:" + a + "px;");
		setSelector(".l" + m, 			"left:" + a + "px;");
		setSelector(".r" + m, 			"right:" + a + "px;");
		setSelector(".bord" + m,		"border-width:" + a + "px;");
		setSelector(".bord-t" + m,		"border-top:" + a + "px;");
		setSelector(".bord-b" + m,		"border-bottom:" + a + "px;");
		setSelector(".bord-l" + m,		"border-left:" + a + "px;");
		setSelector(".bord-r" + m,		"border-right:" + a + "px;");
		setSelector(".marg" + m, 		"margin:" + a + "px;");
		setSelector(".marg-t" + m, 		"margin-top:" + a + "px;");
		setSelector(".marg-b" + m, 		"margin-bottom:" + a + "px;");
		setSelector(".marg-l" + m, 		"margin-left:" + a + "px;");
		setSelector(".marg-r" + m, 		"margin-right:" + a + "px;");
		setSelector(".padd" + m, 		"padding:" + a + "px;");
		setSelector(".padd-t" + m,		"padding-top:" + a + "px;");
		setSelector(".padd-b" + m,		"padding-bottom:" + a + "px;");
		setSelector(".padd-l" + m,		"padding-left:" + a + "px;");
		setSelector(".padd-r" + m,		"padding-right:" + a + "px;");
		setSelector(".line-h" + m, 		"line-height:" + a + "px;");
		setSelector(".bord-rad" + m,	"border-radius:" + a + "px;");
		setSelector(".marg-a", 			"margin-left:auto;margin-right:auto;");
		setSelector(".txt" + m, 		"font-size:" + a + "px;");
	}
	
	/** 
	 * Positive selectors with percentage (FLOAT)
	 * @private 
	 **/
	private function _pct(m:String, a:Int):Void {
		
		if (a < 101) {
			
			setSelector(".bord-rad" + m,		"border-radius:" + a + "%;");
			setSelector(".w" + m, 				"width:" + a + "%;");
			setSelector(".h" + m, 				"height:" + a + "%;");
			setSelector(".wh" + m, 				"width:" + a + "%;height:" + a + "%;");
			setSelector(".marg" + m, 			"margin:" + a + "%;");
			setSelector(".marg-t" + m, 			"margin-top:" + a + "%;");
			setSelector(".marg-b" + m, 			"margin-bottom:" + a + "%;");
			setSelector(".marg-l" + m, 			"margin-left:" + a + "%;");
			setSelector(".marg-r" + m, 			"margin-right:" + a + "%;");
			setSelector(".line-h" + m, 			"line-height:" + a + "%;");
			
		}
		
	}
	
	override public function add(a:Int,b:Int):Void {
		var m:String = a < 0 ? "" + a : "-" + a;
		_normal(m, a);
		if (a > 0) {
			_pct(m + "pc", a);
		}
	}
	
}
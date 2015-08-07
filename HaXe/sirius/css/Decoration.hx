package sirius.css;
import haxe.Log;
import sirius.css.Color;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.css.Decoration")
class Decoration extends CSS {
	/**
	 * Margin
	 * Width
	 * Height
	 */
	public function new() {
		
		super();
		
		distribute(".disp-none", 			"display:none;");
		distribute(".disp-block", 			"display:block;");
		distribute(".disp-inline", 			"display:inline;");
		distribute(".disp-inline-block",	"display:inline-block;");
		distribute(".vert-baseline",		"vertical-align:baseline;");
		distribute(".vert-t",				"vertical-align:top;");
		distribute(".vert-m",				"vertical-align:middle;");
		distribute(".vert-b",				"vertical-align:bottom;");
		distribute(".vert-txt-t",			"vertical-align:text-top;");
		distribute(".vert-txt-b",			"vertical-align:text-bottom;");
		distribute(".vert-sub", 			"vertical-align:sub;");
		distribute(".vert-sup", 			"vertical-align:super;");
		distribute(".pos-abs", 				"position:absolute;");
		distribute(".pos-rel", 				"position:relative;");
		distribute(".pos-fix", 				"position:fixed;");
		distribute(".pull-r",				"float:right;");
		distribute(".pull-l",				"float:left;");
		distribute(".pull-n", 				"float:none;");
		distribute(".over-hid", 			"overflow:hidden;");
		distribute(".over-scroll",			"overflow:scroll;");
		distribute(".scroll-x", 			"overflow-x:scroll;overflow-y:hidden;");
		distribute(".scroll-y", 			"overflow-y:scroll;overflow-x:hidden;");
		
		distribute(".txt-l",				"text-align:left;");
		distribute(".txt-r",				"text-align:right;");
		distribute(".txt-c",				"text-align:center;");
		distribute(".txt-j",				"text-align:justify;");
		
		distribute(".bold", 				"font-weight:bold;");
		distribute(".regular", 				"font-weight:normal;");
		distribute(".underline", 			"font-weight:underline;");
		distribute(".italic", 				"font-weight:italic;");
		distribute(".thin", 				"font-weight:100;");
		distribute(".up-case", 				"font-transform:uppercase");
		distribute(".lo-case", 				"font-transform:lowercase");
		
		distribute(".curs-pointer", 		"cursor:pointer");
		distribute(".curs-loading", 		"cursor:loading");
		distribute(".curs-default", 		"cursor:default");
		
		distribute(".arial", 				"font-family:arial;");
		distribute(".verdana", 				"font-family:verdana;");
		distribute(".tahoma",	 			"font-family:tahoma;");
		distribute(".lucida",	 			"font-family:lucida console;");
		distribute(".georgia", 				"font-family:georgia;");
		distribute(".trebuchet", 			"font-family:trebuchet ms;");
		distribute(".segoe",	 			"font-family:segoe ui;");
		
		distribute(".disp-tab",				"display:table;");
		distribute(".disp-tab-cell", 		"display:table-cell");
		
		distribute(".bord-solid", 			"border-style:solid");
		distribute(".bord-dashed", 			"border-style:dashed");
		distribute(".bord-double", 			"border-style:double");
		distribute(".bord-dotted", 			"border-style:dotted");
		
	}
	
}
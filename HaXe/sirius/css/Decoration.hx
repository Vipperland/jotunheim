package sirius.css;
import haxe.Log;

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
		
		super(false);
		
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
		
		setSelector(".border-solid", 		"border-style:solid");
		setSelector(".border-dashed", 		"border-style:dashed");
		setSelector(".border-double", 		"border-style:double");
		setSelector(".border-dotted", 		"border-style:dotted");
		
		
	}
	
}
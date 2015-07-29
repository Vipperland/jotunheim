package sirius.css;
import haxe.Log;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.css.Common")
class Common extends CSS {
	/**
	 * Margin
	 * Width
	 * Height
	 */
	public function new() {
		super();
		setSelector(".none", 		"display:none;");
		setSelector(".block", 		"display:block;");
		setSelector(".inline", 		"display:inline;");
		setSelector(".inline-b",	"display:inline-block;");
		setSelector(".va-bl",		"vertical-align:baseline;");
		setSelector(".va-t",		"vertical-align:top;");
		setSelector(".va-m",		"vertical-align:middle;");
		setSelector(".va-b",		"vertical-align:bottom;");
		setSelector(".va-txt-t",	"vertical-align:text-top;");
		setSelector(".va-txt-b",	"vertical-align:text-bottom;");
		setSelector(".va-sub", 		"vertical-align:sub;");
		setSelector(".va-sup", 		"vertical-align:super;");
		setSelector(".w-a", 		"width:auto;");
		setSelector(".h-a", 		"height:auto;");
		setSelector(".wh-a", 		"width:auto;height:auto;");
		setSelector(".abs", 		"position:absolute;");
		setSelector(".rel", 		"position:relative;");
		setSelector(".fix", 		"position:fixed;");
		setSelector(".float-r",		"float:right;");
		setSelector(".float-l",		"float:left;");
		setSelector(".no-float", 	"float:none;");
		setSelector(".no-scroll", 	"overflow:hidden;");
		setSelector(".scroll", 		"overflow:scroll;");
		setSelector(".scroll-h", 	"overflow-x:scroll;overflow-y:hidden;");
		setSelector(".scroll-v", 	"overflow-y:scroll;overflow-x:hidden;");
		setSelector(".txt-l",		"text-align:left;");
		setSelector(".txt-r",		"text-align:right;");
		setSelector(".txt-c",		"text-align:center;");
		setSelector(".txt-j",		"text-align:justify;");
		
		setSelector(".bold", 		"font-weight:bold;");
		setSelector(".regular", 	"font-weight:normal;");
		setSelector(".underline", 	"font-weight:underline;");
		setSelector(".italic", 		"font-weight:italic;");
		setSelector(".thin", 		"font-weight:100;");
		setSelector(".up-case", 	"font-transform:uppercase");
		setSelector(".lo-case", 	"font-transform:lowercase");
		
		setSelector(".buttom", 		"cursor:pointer");
		setSelector(".locader", 	"cursor:loading");
		
		setSelector(".arial", 		"font-family:arial;");
		setSelector(".verdana", 	"font-family:verdana;");
		setSelector(".tahoma",	 	"font-family:tahoma;");
		setSelector(".lucida",	 	"font-family:lucida console;");
		setSelector(".georgia", 	"font-family:georgia;");
		setSelector(".trebuchet", 	"font-family:trebuchet ms;");
		setSelector(".segoe",	 	"font-family:segoe ui;");
		setSelector(".center",		"display:table;");
		setSelector(".center>div",	"display:table-cell;vertical-align:middle;margin-left:auto;margin-right:auto;text-align:center;");
		setSelector(".center-h", 	"margin-left:auto;margin-right:auto;text-align:center;");
		setSelector(".center-v",	"display:table;");
		setSelector(".center-v>div", "display:table-cell;vertical-align:middle;");
		setSelector(".centered", 	"margin-left:auto;margin-right:auto;");
		
		setSelector(".round-0", " border-radius:0px;");
		
	}
	
	override public function add(a:Int):Void {
		var m:String = (a < 0) ? a + "n" : "-" + a;
		if(a>-1)	setSelector(".z" + m, "z-index:" + a + ";");
		setSelector(".o" + m, "outline:" + a + ";");
		setSelector(".w" + m, "width:" + a + "px;");
		setSelector(".h" + m, "height:" + a + "px;");
		setSelector(".wh" + m, "width:" + a + "px;height:" + a + "px;");
		setSelector(".va" + m, "vertical-align: " + a + "px;");
		setSelector(".t" + m, "top:" + a + "px;");
		setSelector(".b" + m, "bottom:" + a + "px;");
		setSelector(".l" + m, "left:" + a + "px;");
		setSelector(".r" + m, "right:" + a + "px;");
		setSelector(".bd" + m, "border-width:" + a + "px;border-style:solid;");
		setSelector(".bd-t" + m, "border-top:" + a + "px;border-style:solid;");
		setSelector(".bd-b" + m, "border-bottom:" + a + "px;border-style:solid;");
		setSelector(".bd-l" + m, "border-left:" + a + "px;border-style:solid;");
		setSelector(".bd-r" + m, "border-right:" + a + "px;border-style:solid;");
		setSelector(".mg" + m, "margin:" + a + "px;");
		setSelector(".mg-t" + m, "margin-top:" + a + "px;");
		setSelector(".mg-b" + m, "margin-bottom:" + a + "px;");
		setSelector(".mg-l" + m, "margin-left:" + a + "px;");
		setSelector(".mg-r" + m, "margin-right:" + a + "px;");
		setSelector(".pd" + m, "padding:" + a + "px;");
		setSelector(".pd-t" + m, "padding-top:" + a + "px;");
		setSelector(".pd-b" + m, "padding-bottom:" + a + "px;");
		setSelector(".pd-l" + m, "padding-left:" + a + "px;");
		setSelector(".pd-r" + m, "padding-right:" + a + "px;");
		setSelector(".ln" + m, "line-height:" + a + "px;");
		if (a > 0) {
			if (a < 300) {
				setSelector(".txt" + m, "font-size:" + a + "px;");
			}
			if (a < 101) {
				setSelector(".round" + m, " border-radius:" + a + "px;");
			}
			var p:Dynamic = untyped __js__("(a / 1000 * 100).toFixed(1)");
			var i:Array<String> = p.split(".");
			var n:String = i[0];
			var j:String = i[1];
			if (j == "0") j = "";
			var k:String = n == "0" && j != "" ?  "u" + j : i.join("u");
			setSelector(".op-" + k, "opacity:" + p + ";");
			if (j == "") k = n;
			setSelector(".w-" + k + "p", "width:" + p + "%;");
			setSelector(".h-" + k + "p", "height:" + p + "%;");
			setSelector(".wh-" + k + "p", "width:" + p + "%;height:" + p + "%;");
			setSelector(".mg-" + k + "p", "margin:" + p + "%;");
			setSelector(".mg-t-" + k + "p", "margin-top:" + p + "%;");
			setSelector(".mg-b-" + k + "p", "margin-bottom:" + p + "%;");
			setSelector(".mg-l-" + k + "p", "margin-left:" + p + "%;");
			setSelector(".mg-r-" + k + "p", "margin-right:" + p + "%;");
			setSelector(".ln-" + k + "p", "line-height:" + p + "%;");
			add( -a);
		}
	}
	
}
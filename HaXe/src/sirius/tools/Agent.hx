package sirius.tools;
import js.Browser;
import sirius.css.CSSGroup;
import sirius.tools.IAgent;
import sirius.tools.Utils;
import sirius.transitions.Animator;

/**
 * ...
 * @author Rafael Moreira
 */
class Agent implements IAgent {
	
	public var ie:Bool;
	
	public var edge:Bool;
	
	public var opera:Bool;
	
	public var firefox:Bool;
	
	public var safari:Bool;
	
	public var chrome:Bool;
	
	public var mobile:Bool;
	
	public var cookies:Bool;
	
	public var xs:Bool;
	
	public var sm:Bool;
	
	public var md:Bool;
	
	public var lg:Bool;
	
	public var screen:Int;
	
	public var jQuery:Bool;
	
	public var display:String;
	
	public var animator:Bool;
	
	public var os:String;

	public function new() {
		
	}
	
	public function update():IAgent {
		var ua:String = Browser.navigator.userAgent;
		// Dectect version of IE (8 to 12);
		var ie:Int = ~/MSIE/i.match(ua) ? 8 : 0;
			ie = ~/MSIE 9/i.match(ua) ? 9 : ie;
			ie = ~/MSIE 10/i.match(ua) ? 10 : ie;
			ie = ~/rv:11./i.match(ua) ? 11 : ie;
			ie = ~/Edge/i.match(ua) ? 12 : ie;
		// Detect version of each browser for more accurate result
		var opera:Bool = ~/OPR/i.match(ua);
		var safari:Bool = ~/Safari/i.match(ua);
		var firefox:Bool = ~/Firefox/i.match(ua);
		var chrome:Bool = ~/Chrome/i.match(ua);
		var chromium:Bool = ~/Chromium/i.match(ua);
		// Check all other versions, including mobile browsers
		this.ie = ie > 0; 
		this.edge = ie > 11;
		this.opera = opera; 
		this.firefox = firefox; 
		this.safari = safari && !chrome && !chromium; 
		this.chrome = (chrome || chromium) && !opera;
		this.mobile = ~/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.match(ua);
		if (Utils.matchMedia(CSSGroup.MEDIA_XS)) { 		
			this.xs = true; 
			this.screen = 1; 
		}else if (Utils.matchMedia(CSSGroup.MEDIA_SM)) { 
			this.sm = true; 
			this.screen = 2; 
		}else if (Utils.matchMedia(CSSGroup.MEDIA_MD)) { 
			this.md = true; 
			this.screen = 3; 
		}else if (Utils.matchMedia(CSSGroup.MEDIA_LG)) { 
			this.lg = true; 
			this.screen = 4; 
		}else {
			this.screen = 0; 
		}
		this.cookies = Browser.navigator.cookieEnabled == true;
		if (!this.cookies){
			Browser.document.cookie = '#validating#';
			this.cookies = (Browser.document.cookie.indexOf('#validating#') != -1);
		}
		this.jQuery = Reflect.hasField(Browser.window, "$") || Reflect.hasField(Browser.window, "jQuery");
		this.animator = Animator.available();
		this.display = Utils.screenOrientation();
		
		var platform:String = Browser.navigator.platform.toLowerCase();
		if (['macintosh', 'macintel', 'macppc', 'mac68k'].indexOf(platform) != -1) {
			os = 'MAC';
		} else if (['iphone', 'ipad', 'ipod'].indexOf(platform) != -1) {
			os = 'IOS';
		} else if (['win32', 'win64', 'windows', 'wince'].indexOf(platform) != -1) {
			os = 'WINDOWS';
		} else if (~/Android/i.match(ua)) {
			os = 'ANDROID';
		} else if (~/linux/i.match(platform)) {
			os = 'LINUX';
		} else{
			os = 'CUSTOM';
		}
		
		return this;
	}
	
	public function value():String {
		return 'OS:' + Browser.navigator.oscpu + '/Browser:' + Browser.navigator.userAgent + '/Mobile:' + mobile;
	}
	
}
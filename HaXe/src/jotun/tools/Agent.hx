package jotun.tools;
import js.Browser;
import jotun.css.CSSGroup;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class Agent {
	
	// Is Edge?
	public var edge:Bool;
	// Is Opera?
	public var opera:Bool;
	// Is Firefox?
	public var firefox:Bool;
	// Is Safari?
	public var safari:Bool;
	// Is Chrome?
	public var chrome:Bool;
	// Is a mobile version?
	public var mobile:Bool;
	
	public var cookies:Bool;
	// Is JQuery available?
	public var jQuery:Bool;
	// Display info
	public var display:String;
	// User Operating System name
	public var os:String;

	public var lang:String;

	public function new() {
		
	}
	
	public function update():Agent {
		var ua:String = Browser.navigator.userAgent;
		// Detect version of each browser for more accurate result
		var edge:Bool = ~/Edge/i.match(ua);
		var opera:Bool = ~/OPR/i.match(ua);
		var safari:Bool = ~/Safari/i.match(ua);
		var firefox:Bool = ~/Firefox/i.match(ua);
		var chrome:Bool = ~/Chrome/i.match(ua);
		var chromium:Bool = ~/Chromium/i.match(ua);
		// Check all other versions, including mobile browsers
		this.edge = edge;
		this.opera = opera; 
		this.firefox = firefox; 
		this.safari = safari && !chrome && !chromium; 
		this.chrome = (chrome || chromium) && !opera;
		this.mobile = ~/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.match(ua);
		this.cookies = (Browser.navigator.cookieEnabled == true);
		if (!this.cookies){
			Browser.document.cookie = '#validating#';
			this.cookies = (Browser.document.cookie.indexOf('#validating#') != -1);
		}
		this.jQuery = Reflect.hasField(Browser.window, "$") || Reflect.hasField(Browser.window, "jQuery");
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
		
		this.lang = Browser.navigator.language.toLowerCase();
		
		return this;
	}
	
	public function value():String {
		return 'OS:' + Browser.navigator.oscpu + '/Browser:' + Browser.navigator.userAgent + '/Mobile:' + mobile;
	}
	
	public function isXS():Bool {
		return Utils.matchMedia(CSSGroup.MEDIA_XS + ' and ' + CSSGroup.MEDIA_XS_MAX);
	}
	
	public function isSM():Bool {
		return Utils.matchMedia(CSSGroup.MEDIA_SM + ' and ' + CSSGroup.MEDIA_SM_MAX);
	}
	
	public function isMD():Bool {
		return Utils.matchMedia(CSSGroup.MEDIA_MD + ' and ' + CSSGroup.MEDIA_MD_MAX);
	}
	
	public function isLG():Bool {
		return Utils.matchMedia(CSSGroup.MEDIA_LG + ' and ' + CSSGroup.MEDIA_LG_MAX);
	}
	
	public function isXL():Bool {
		return Utils.matchMedia(CSSGroup.MEDIA_XL);
	}
	
}
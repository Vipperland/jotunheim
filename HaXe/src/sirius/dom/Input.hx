package sirius.dom;
import haxe.Log;
import js.Browser;
import js.html.File;
import js.html.FileList;
import js.html.FileReader;
import js.html.InputElement;
import js.RegExp;
import sirius.dom.Img;
import sirius.events.IEvent;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Input")
class Input extends Display {
	
	static public function get(q:String):Input {
		return cast Sirius.one(q);
	}
	
	static public var fixer:Dynamic = { backgroundSize : 'cover', backgroundPosition : 'center center' };
	
	static public var icons:Dynamic = { }
	
	public var object:InputElement;
	
	private var _rgx:EReg;
	
	private var _flt:String;
	
	private var fillTarget:IDisplay;
	
	private var _ioHandler:Input->Void;
	
	private function _onFileSelected(e:Dynamic) {
		var ftype:String = file(0).type.substr(0, 5);
		if (ftype == 'image'){
			if(fillTarget != null){
				if (fillTarget.typeOf() == 'IMG'){
					var img:Img = cast fillTarget;
					img.src(readFile(0));
				}else{
					fixer.backgroundImage = 'url(' + readFile(0) + ')';
					fillTarget.style(fixer);
					Reflect.deleteField(fixer, 'backgroundImage');
				}
			}
			if(_ioHandler != null)
				_ioHandler(this);
		}else{
			var bg:String = Reflect.hasField(icons, ftype) ? Reflect.field(icons, ftype) : icons.common;
			if(bg != null && fillTarget != null){
				fillTarget.style({backgroundImage : 'url(' + bg + ')'});
			}
			if(_ioHandler != null)
				_ioHandler(this);
		}
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createInputElement();
		super(q, null);
		object = cast element;
	}
	
	public function type(?q:String):String {
		if (q != null) object.type = q;
		return object.type;
	}
	
	public function required(?q:Bool):Bool {
		if (q != null) object.required = q;
		return object.required;
	}
	
	public function pattern(?q:String):String {
		if (q != null) object.pattern = q;
		return object.pattern;
	}
	
	public function placeholder(?q:String):String {
		if (q != null) object.placeholder = q;
		return object.placeholder;
	}
	
	public function restrict(q:EReg, ?filter:String):Void {
		_rgx = q;
		// phone: "() -"
		// Number " "
		_flt = filter;
	}
	
	public function value(?q:String):String {
		if (q != null) {
			object.value = q;
		}else{
			q = object.value;
			if (object.maxLength != null && object.maxLength > 0)
				q = q.substr(0, object.maxLength);
			if(_flt !=null){
				var k:Array<String> = _flt.split("");
				Dice.Values(k, function(v1:String) { q = q.split(v1).join(''); } );
			}
		}
		return q;
	}
	
	public function clear(?background:String):Void {
		value("");
		if (fillTarget != null){
			fillTarget.style("backgroundImage", background);
		}
	}
	
	public function isValid():Bool {
		var v:String = object.value;
		return v.length == 0 ? false :  _rgx != null ? _rgx.match(v) : true;
	}
	
	public function isEmpty():Bool {
		return value() == "";
	}
	
	public function hasFile():Bool {
		return files().length > 0;
	}
	
	public function files():FileList {
		return object.files;
	}
	
	public function file(id:UInt = 0):File {
		return files().item(id);
	}
	
	public function readFile(id:UInt = 0):String {
		return (cast Browser.window).URL.createObjectURL(file());
	}
	
	/**
	 * After file selected, show loaded image in any target background
	 * @param	target
	 * @param	handler
	 */
	public function control(handler:Input->Void, ?target:IDisplay):Void {
		_ioHandler = handler;
		fillTarget = target;
		if (attribute('sr-control') != "ready"){
			type('file');
			attribute('sr-control', "ready");
			this.events.change(_onFileSelected);
		}
	}
	
	public function check(?toggle:Dynamic = true):Void {
		object.checked = toggle == null ? !object.checked : toggle == true || toggle == 1;
	}
	
	public function isChecked():Bool {
		return object.checked;
	}
	
}
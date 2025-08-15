package jotun.dom;
import haxe.Log;
import jotun.Jotun;
import jotun.tools.Utils;
import jotun.utils.IDiceRoll;
import js.Browser;
import js.html.Blob;
import js.html.File;
import js.html.FileList;
import js.html.FileReader;
import js.html.InputElement;
import js.RegExp;
import jotun.dom.Img;
import jotun.events.Activation;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.Input")
class Input extends Display {
	
	static public function get(q:String):Input {
		return cast Jotun.one(q);
	}
	
	static public var icons:Dynamic = { }
	
	public var _object(get, null):InputElement;
	
	private function get__object():InputElement {
		return cast element;
	}
	
	private var _rgx:EReg;
	
	private var _flt:String;
	
	private var _ioHandler:Input->Void;
	
	private function _onFileSelected(e:Dynamic) {
		if (_ioHandler != null){
			_ioHandler(this);
		}
	}
	
	public function new(?q:Dynamic) {
		if (q == null) {
			q = Browser.document.createInputElement();
		}
		super(q, null);
		_object = cast element;
	}
	
	public function type(?q:String):String {
		if (q != null) _object.type = q;
		return _object.type;
	}
	
	public function required(?q:Bool):Bool {
		if (q != null) _object.required = q;
		return _object.required;
	}
	
	public function pattern(?q:String):String {
		if (q != null) _object.pattern = q;
		return _object.pattern;
	}
	
	public function placeholder(?q:String):String {
		if (q != null) _object.placeholder = q;
		return _object.placeholder;
	}
	
	public function restrict(q:Dynamic, ?filter:String):Void {
		if (!Std.isOfType(q, EReg)){
			if (!Std.isOfType(q, String)){
				q = q.toString();
			}
			q = q.split('$/');
			if (!Utils.isValid(q[1])){
				q[1] = "";
			}
			q = new EReg(q[0].substring(1), q[1]);
		}
		_rgx = q;
		_flt = filter;
	}
	
	@:overload(function(?q:Int):File{})
	@:overload(function():FileList{})
	@:overload(function(?q:String):String{})
	override public function value(?q:Dynamic):Dynamic {
		switch(type()){
			case 'file' : {
				if (hasFile()){
					if (_object.files.length > 0){
						return _object.files;
					}else if (q != null){
						if (q != ''){
							return file(q);
						}else{
							clearAttribute('jtn-ctrl');
						}
					}else{
						return file(0);
					}
				}else{
					return null;
				}
			}
			case 'checkbox' : {
				if (q != null){
					check(Utils.boolean(q));
				}else{
					return hasAttribute('value') ? attribute('value') : isChecked();
				}
			}
		}
		if (q != null) {
			_object.value = q;
		}else{
			q = _object.value;
			if (_object.maxLength != null && _object.maxLength > 0)
				q = q.substr(0, _object.maxLength);
			if(_flt !=null){
				var k:Array<String> = _flt.split("");
				Dice.Values(k, function(v1:String) { q = q.split(v1).join(''); } );
			}
		}
		return q;
	}
	
	public function clear():Void {
		value('');
	}
	
	public function isValid():Bool {
		switch(type()){
			case 'file' : {
				if (hasFile()){
					var mime:Array<String> = attribute('accept').split(', ');
					var roll:IDiceRoll = Dice.Values(files(), function(f:File){
						return mime.indexOf(f.type) == -1;
					});
					return roll.completed;
				}
			}
			case 'checkbox' : {
				return true;
			}
			default : {
				var v:String = _object.value;
				return v.length == 0 ? false :  _rgx != null ? _rgx.match(v) : true;
			}
		}
		return false;
	}
	
	public function isEmpty():Bool {
		return value() == "";
	}
	
	public function hasFile():Bool {
		return files().length > 0;
	}
	
	public function files():FileList {
		return _object.files;
	}
	
	public function file(id:UInt = 0):File {
		return files().item(id);
	}
	
	public function readFile(id:UInt = 0):String {
		return (cast Browser.window).URL.createObjectURL(file(id));
	}
	
	/**
	 * After file selected, show loaded image in any target background
	 * @param	handler
	 * @param	target
	 * @param	filter
	 */
	public function control(handler:Input->Void, ?mime:Array<String>):Void {
		_ioHandler = handler;
		if (mime != null){
			acceptOnly(mime);
		}
		if (attribute('jtn-ctrl') != "ready"){
			type('file');
			attribute('jtn-ctrl', "ready");
			this.events.change(_onFileSelected);
		}
	}
	
	public function acceptOnly(mime:Array<String>):Void {
		attribute('accept', mime.join(', '));
	}
	
	public function check(?toggle:Dynamic = true):Void {
		_object.checked = toggle == null ? !_object.checked : toggle == true || toggle == 1;
	}
	
	public function isChecked():Bool {
		return _object.checked;
	}
	
	public function filesToArray(?o:Array<Blob>):Array<Blob> {
		if (o == null) { o = []; }
		if (hasFile()){
			var f:FileList = files();
			Dice.Count(0, f.length, function(a:Int, b:Int, e:Bool) {
				o.push(f.item(a));
				return false;
			});
		}
		return o;
	}
	
	public function filesToObject(?o:Dynamic):Dynamic {
		if (o == null){ o = {}; }
		Dice.All(filesToArray(), function(p:String, v:Blob):Void {
			Reflect.setField(o, 'file_' + p, v);
		});
		return o;
	}
	
}
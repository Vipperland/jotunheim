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
import jotun.events.IEvent;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Input")
class Input extends Display {
	
	static public function get(q:String):Input {
		return cast Jotun.one(q);
	}
	
	static public var icons:Dynamic = { }
	
	public var object:InputElement;
	
	private var _rgx:EReg;
	
	private var _flt:String;
	
	private var fillTarget:IDisplay;
	
	private var _ioHandler:Input->Void;
	
	private function _onFileSelected(e:Dynamic) {
		var bg:String = null;
		var ftype:Array<String> = file(0).type.split('/');
		if (ftype[0] == 'image'){
			bg = readFile(0);
		}else{
			bg = Reflect.hasField(icons, ftype[1]) ? Reflect.field(icons,  ftype[1]) : icons.common;
		}
		if(bg != null && fillTarget != null){
			if (fillTarget.typeOf() == 'IMG'){
				fillTarget.attribute('src', bg);
			}else{
				fillTarget.style({backgroundImage : 'url(' + bg + ')'});
			}
		}
		if (_ioHandler != null){
			_ioHandler(this);
		}
	}
	
	
	public function validateCardExp():Void {
		_rgx = ~/\d{2}\/\d{2,4}/;
	}
	
	public function validateDate():Void {
		_rgx = ~/\d{1,2}\/\d{1,2}\/\d{4}/;
	}
	
	public function validateURL():Void {
		_rgx = ~/https?:\/\/.+/;
	}
	
	public function validateIPv4():Void {
		_rgx = ~/^\d{1,3}d{1,3}.\d{1,3}.\d{1,3}/;
	}
	
	public function validateCurrency():Void {
		_rgx = ~/\d+(.\d{2})?/;
	}
	
	public function validateEmail():Void {
		_rgx = ~/^[a-z0-9!'#$%&*+\/=?^_`{|}~-]+(?:\.[a-z0-9!'#$%&*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-zA-Z]{2,}$/giu;
		_flt = " \t";
	}
	
	public function validateNumbers():Void {
		_rgx = ~/^\d{1,}$/;
		_flt = " ";
	}
	
	public function validateMobile():Void {
		_rgx = ~/^(\d{10,11})|(\(\d{2}\) \d{5}-\d{4})$/;
		_flt = "+()- ";
	}
	
	public function validatePhone():Void {
		_rgx = ~/^(\d{10,11})|(\(\d{2}\) \d{5}-\d{4})$/;
		_flt = "+()- ";
	}
	
	public function validateDoc():Void {
		_rgx = ~/^(\d{3}.\d{3}.\d{3}-\d{2})|(\d{2}.\d{3}.\d{3}\/\d{4}-\d{2})$/;
		_flt = "-./";
	}
	
	public function validateZipcode():Void {
		_rgx = ~/^(\d{5}-\d{3})|(\d{8})$/;
		_flt = "- ";
	}
	
	public function validateLetters():Void {
		_rgx = ~/^[a-zA-Z]{3,}$/;
	}
	
	public function validatePwd():Void {
		_rgx = ~/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
	}
	
	public function validateUsr():Void {
		_rgx = ~/^[A-Za-z0-9._-]{6,24}$/;
	}
	
	public function validateMd5():Void {
		_rgx = ~/^[A-Za-z0-9._-]{35}$/;
	}
	
	public function validateCard():Void {
		_rgx = ~/\d{4}-\d{4}-\d{4}-\d{4}$/;
	}
	
	public function new(?q:Dynamic) {
		if (q == null) {
			q = Browser.document.createInputElement();
		}
		super(q, null);
		object = cast element;
		if (type() == 'file'){
			if (hasAttribute('display-on')){
				fillTarget = Jotun.one(attribute('display-on'));
			}
		}
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
		_flt = filter;
	}
	
	@:overload(function(?q:Int):File{})
	@:overload(function():FileList{})
	@:overload(function(?q:String):String{})
	override public function value(?q:Dynamic):Dynamic {
		switch(type()){
			case 'file' : {
				if (hasFile()){
					if (object.files.length > 0){
						return object.files;
					}else if (q != null){
						if (q != ''){
							return file(q);
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
					return isChecked();
				}
			}
		}
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
		value('');
		if (fillTarget != null){
			fillTarget.style("backgroundImage", background);
		}
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
				var v:String = object.value;
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
	 * @param	handler
	 * @param	target
	 * @param	filter
	 */
	public function control(handler:Input->Void, ?display:IDisplay, ?mime:Array<String>):Void {
		_ioHandler = handler;
		if (display != null){
			fillTarget = display;
		}
		if (mime != null){
			acceptOnly(mime);
		}
		if (attribute('jotun-control') != "ready"){
			type('file');
			attribute('jotun-control', "ready");
			this.events.change(_onFileSelected);
		}
	}
	
	public function acceptOnly(mime:Array<String>):Void {
		attribute('accept', mime.join(', '));
	}
	
	public function check(?toggle:Dynamic = true):Void {
		object.checked = toggle == null ? !object.checked : toggle == true || toggle == 1;
	}
	
	public function isChecked():Bool {
		return object.checked;
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
		Dice.All(filesToArray(), function(p:String, v:Blob){
			Reflect.setField(o, 'file_' + p, v);
		});
		return o;
	}
	
}
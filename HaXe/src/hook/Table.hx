package hook;
/**
* ...
@author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
*/
@:native('sru.utils.Table')
extern public class Table {
	
	public static function empty () : Table;
	
	public var content : Array<Display>;
	
	public var elements : Array<Dynamic>;

	public function new (?q:String="*", ?t:Dynamic=null);

	public function contains (q:String) : Table;

	public function flush (handler:Display->Void, ?complete:Dynamic->Void) : Table;

	public function first () : Display;

	public function last () : Display;

	public function obj (i:Int) : Display;

	public function css (styles:String) : Table;

	public function attribute (name:String, value:String) : Table;

	public function attributes (values:Dynamic) : Table;

	public function show () : Table;

	public function hide () : Table;

	public function remove () : Table;

	public function cursor (value:String) : Table;

	public function detach () : Table;

	public function attach () : Table;

	public function pin () : Table;

	public function clear (?fast:Bool) : Table;

	public function addTo (?target:Display) : Table;

	public function addToBody () : Table;

	public function length () : Int;

	public function each (handler:Display->Void) : Table;

	public function call (method:String, ?args:Array<Dynamic>) : Table;

	public function on (name:String, handler:Dynamic->Void, ?mode:String) : Table;

	public function merge (?tables:Array<Table>) : Table;

	public function onWheel (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onCopy (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onCut (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPaste (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onAbort (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onBlur (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onFocusIn (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onFocusOut (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onCanPlay (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onCanPlayThrough (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onChange (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onClick (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onContextMenu (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDblClick (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDrag (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDragEnd (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDragEnter (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDragLeave (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDragOver (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDragStart (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDrop (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onDurationChange (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onEmptied (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onEnded (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onInput (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onInvalid (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onKeyDown (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onKeyPress (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onKeyUp (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onLoad (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onLoadedData (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onLoadedMetadata (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onLoadStart (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onMouseDown (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onMouseEnter (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onMouseLeave (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onMouseMove (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onMouseOut (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onMouseOver (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onMouseUp (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPause (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPlay (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPlaying (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onProgress (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onRateChange (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onReset (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onScroll (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onSeeked (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onSeeking (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onSelect (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onShow (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onStalled (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onSubmit (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onSuspend (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onTimeUpdate (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onVolumeChange (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onWaiting (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerCancel (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerDown (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerUp (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerMove (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerOut (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerOver (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerEnter (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerLeave (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onGotPointerCapture (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onLostPointerCapture (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerLockChange (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onPointerLockError (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onError (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onTouchStart (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onTouchEnd (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onTouchMove (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onTouchCancel (?handler:Dynamic->Void, ?mode:Dynamic) : Table;

	public function onVisibility (?handler:Dynamic->Void, ?mode:Dynamic) : Table;
}

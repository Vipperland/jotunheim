package hook;
/**
* ...
@author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
*/
@:native('sru.utils.Table')
extern public class TableHook {
	
	public static function empty () : TableHook;
	
	public var content : Array<DisplayHook>;
	
	public var elements : Array<Dynamic>;

	public function new (?q:String="*", ?t:Dynamic=null);

	public function contains (q:String) : TableHook;

	public function flush (handler:DisplayHook->Void, ?complete:Dynamic->Void) : TableHook;

	public function first () : DisplayHook;

	public function last () : DisplayHook;

	public function obj (i:Int) : DisplayHook;

	public function css (styles:String) : TableHook;

	public function attribute (name:String, value:String) : TableHook;

	public function attributes (values:Dynamic) : TableHook;

	public function show () : TableHook;

	public function hide () : TableHook;

	public function remove () : TableHook;

	public function cursor (value:String) : TableHook;

	public function detach () : TableHook;

	public function attach () : TableHook;

	public function pin () : TableHook;

	public function clear (?fast:Bool) : TableHook;

	public function addTo (?target:DisplayHook) : TableHook;

	public function addToBody () : TableHook;

	public function length () : Int;

	public function each (handler:DisplayHook->Void) : TableHook;

	public function call (method:String, ?args:Array<Dynamic>) : TableHook;

	public function on (name:String, handler:Dynamic->Void, ?mode:String) : TableHook;

	public function merge (?TableHooks:Array<TableHook>) : TableHook;

	public function onWheel (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onCopy (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onCut (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPaste (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onAbort (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onBlur (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onFocusIn (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onFocusOut (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onCanPlay (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onCanPlayThrough (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onChange (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onClick (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onContextMenu (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDblClick (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDrag (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDragEnd (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDragEnter (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDragLeave (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDragOver (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDragStart (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDrop (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onDurationChange (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onEmptied (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onEnded (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onInput (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onInvalid (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onKeyDown (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onKeyPress (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onKeyUp (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onLoad (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onLoadedData (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onLoadedMetadata (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onLoadStart (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onMouseDown (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onMouseEnter (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onMouseLeave (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onMouseMove (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onMouseOut (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onMouseOver (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onMouseUp (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPause (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPlay (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPlaying (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onProgress (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onRateChange (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onReset (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onScroll (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onSeeked (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onSeeking (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onSelect (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onShow (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onStalled (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onSubmit (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onSuspend (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onTimeUpdate (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onVolumeChange (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onWaiting (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerCancel (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerDown (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerUp (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerMove (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerOut (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerOver (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerEnter (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerLeave (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onGotPointerCapture (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onLostPointerCapture (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerLockChange (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onPointerLockError (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onError (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onTouchStart (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onTouchEnd (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onTouchMove (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onTouchCancel (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;

	public function onVisibility (?handler:Dynamic->Void, ?mode:Dynamic) : TableHook;
}

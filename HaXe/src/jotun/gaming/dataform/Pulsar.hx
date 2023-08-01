package jotun.gaming.dataform;
import jotun.errors.Error;
import jotun.serial.Packager;
import jotun.signals.Signals;
import jotun.tools.Key;
import jotun.utils.Dice;
#if js
	import js.Syntax;
#elseif php
	import php.Syntax;
#end

/**
 * ...
 * @author Rim Project
 */
@:expose("Pulsar")
class Pulsar {
	
	public static var BLOCK_SIZE:Int = 64;
	
	public static var ID_SIZE:Int = 32;
	
	private static var _dictio:Dynamic = {
		"*": {
			'Construct': Spark, 
			Properties: null, 
			Indexable: false, 
			Tag: false,
		}
	};
	
	/**
	 * 
	 * @param	name			Pulsar object name
	 * @param	props		Object props to be mapped
	 * @param	objClass		Object Class to initialize
	 * @param	indexable		If true, generate an alphanumeric 32 length unique ID for each instance
	 */
	public static function map(name:String, props:Dynamic, objClass:Dynamic = null, indexable:Bool = false):Void {
		Reflect.setField(_dictio, name, {
			'Construct':objClass == null ? Spark : objClass, 
			Properties: props == null ? null : props, 
			Indexable: indexable == true, 
		});
	}
	
	public static function construct(name:String, r:Array<String>):Spark {
		var O:Dynamic = null;
		var o:Spark = null;
		var indexable:Bool;
		if (Reflect.hasField(_dictio, name)){
			O = Reflect.field(_dictio, name);
			o = Syntax.construct(O.Construct, name);
		}
		if (o != null){
			if (r.length == 3){
				o.id = r[1];
				o.merge(r[2]);
			}else if (r.length == 2){
				if (O.Indexable){
					o.id = Key.GEN(ID_SIZE);
				}
				o.merge(r[1]);
			}
		}
		return o;
	}
	
	public static function isIndexable(name:String):Bool {
		return Reflect.hasField(_dictio, name) ? Reflect.field(_dictio, name).Indexable : false;
	}
	
	static public function isList(name:String) {
		return Reflect.hasField(_dictio, name) ? Reflect.field(_dictio, name).IsList : false;
	}
	
	public static function propertiesOf(name:String):Array<String> {
		return Reflect.hasField(_dictio, name) ? Reflect.field(_dictio, name).Properties : null;
	}
	
	public static function extract(data:Dynamic):Array<String> {
		var a:Array<String> = [];
		Dice.Params(data, function(p:Dynamic){
			a[a.length] = p;
		});
		return a;
	}
	
	public static function create(data:String):Pulsar {
		return new Pulsar(data);
	}
	
	private var _open_links:Dynamic;
	
	private function _getOrCreate(name:String):PulsarLink {
		var x:PulsarLink = Reflect.field(_open_links, name);
		if (x == null){
			x = new PulsarLink(name);
			Reflect.setField(_open_links, name, x);
		}
		return x;
	}
	
	private function _exists(o:Spark, r:Array<String>):Bool {
		if (r.length >= 2){
			var x:PulsarLink = link(r[0]);
			if (x != null){
				return x.exists(r[1]);
			}
		}
		return false;
	}
	
	private function _grab(r:Array<String>):Spark {
		if (r.length >= 2){
			var x:PulsarLink = link(r[0]);
			if (x != null){
				return x.get(r[1]);
			}
		}
		return null;
	}
	
	private function _delete(r:Array<String>):Void {
		if (r.length == 2){
			var x:PulsarLink = link(r[0]);
			if (x != null){
				_onLinkDelete(x.delete(r[1], true));
			}
		}
	}
	
	private function _onLinkAdd(o:Spark):Void {
		signals.call(PulsarSignals.LINK_CREATED, o);
	}
	
	private function _onObjectAdd(o:Spark):Void {
		if (o != null){
			signals.call(PulsarSignals.SPARK_CREATED, o);
		}
	}
	
	private function _onLinkDelete(o:Spark):Void {
		signals.call(PulsarSignals.LINK_DELETED, o);
	}
	
	private function _onObjectDelete(o:Spark):Void {
		if (o != null){
			signals.call(PulsarSignals.SPARK_DELETED, o);
		}
	}
	
	private function _onLinkUpdate(o:Spark):Void {
		signals.call(PulsarSignals.LINK_UPDATED, o);
	}
	
	private function _onObjectUpdate(o:Spark):Void {
		if (o != null){
			signals.call(PulsarSignals.SPARK_UPDATED, o);
		}
	}
	
	public var signals:Signals;
	
	public function new(?data:String) {
		_open_links = {};
		signals = new Signals(this);
		if (data != null && data.length > 0){
			parse(data);
		}
	}
	
	/**
	   
	   @param	o
	   @return
	**/
	public function insert(o:Spark):Bool {
		var name:String = o.getName();
		if(name != null && name.length > 0){
			var x:PulsarLink = _getOrCreate(name);
			// Create an unique ID
			if(isIndexable(name)){
				while (o.id == null && !x.exists(o.id)){
					o.id = Key.GEN(ID_SIZE);
				}
			}
			x.insert(o);
		}else{
			o = null;
		}
		return o != null;
	}
	
	/**
	   
	   @param	data
	   @return length
	**/
	public function parse(data:String):Int {
		if (data.substr(0, 1) == '#'){
			data = data.split('\n').join('');
			var key:String = data.substring(1, 33);
			var e:Int = Std.parseInt(data.substring(33, 34));
			data = data.substring(34, data.length);
			if (Packager.md5Encode(data) != key){
				throw new Error(1, 'Invalid data object');
			}
			while (e > 0){
				data += '=';
				--e;
			}
			data = Packager.decodeBase64(data);
		}
		var len:Int = 0;
		var i:Array<String> = data.split('\n');
		var l:Spark = null;
		Dice.Values(i, function(v:String){
			var q:Array<String> = v.split(' @::');
			var r:Array<String> = q[0].split(' ');
			if (q.length > 1){
				r[r.length] = q[1];
			}
			if (r.length > 0){
				v = r[0];
				var cmd:String = v.substring(0, 1);
				var o:Spark = null;
				switch(cmd){
					case '>' : {
						if (l != null){
							v = v.substring(1, v.length);
							if (r.length == 3 && l.exists(r[1])){
								o = l.get(r[1]);
								o.merge(r[2]);
								_onObjectUpdate(o);
							}else{
								o = construct(v, r);
								if (l.insert(o)){
									++len;
									_onObjectAdd(o);
								}
							}
						}
					}
					case '/' : {
						if (l != null){
							_onObjectDelete(l.delete(r[1], true));
						}
					}
					case '-' : {
						cmd = r[0];
						r[0] = cmd.substring(1, cmd.length);
						if (_exists(null, r)){
							_delete(r);
						}
					}
					default : {
						if (_exists(null, r)){
							o = _grab(r);
							if (r.length == 3){
								o.merge(r[2]);
								_onLinkUpdate(o);
							}
							l = o;
						}else{
							o = construct(v, r);
							if (insert(o)){
								if (l != null){
									l.refresh();
								}
								l = o;
								++len;
								_onLinkAdd(o);
							}else{
								l = null;
							}
						}
					}
				}
			}
		});
		if (l != null){
			l.refresh();
		}
		refresh();
		return len;
	}
	
	private function _encode(r:String):String {
		r = Packager.encodeBase64(r);
		var i:Int = 0;
		while (r.substr(r.length - 1, 1) == '='){
			r = r.substring(0, r.length - 1);
			++i;
		}
		r = '#' + Packager.md5Encode(r) + i + r;
		i = 0;
		var nr:String = '';
		var len:Int = r.length;
		while (i < len){
			nr += r.substr(i, BLOCK_SIZE) + '\n';
			i += BLOCK_SIZE;
		}
		return nr.substring(0, nr.length-1);
	}
	
	private function _toString(?encode:Bool, ?changes:Bool, ?name:String):String {
		var r:String = '';
		var c:String = null;
		Dice.Values(_open_links, function(list:PulsarLink){
			if (name == null || list.is(name)){
				//r += list.getName();
				c = list.stringify(changes);
				if (c != null){
					if (r.length > 0){
						r += '\n';
					}
					r += c;
				}
			}
		});
		if (encode){
			r = _encode(r);
		}
		return r;
	}
	
	/**
	   
	   @return
	**/
	public function toString(?encode:Bool, ?name:String):String {
		return _toString(encode, false, name);
	}
	
	/**
	   
	   @return
	**/
	public function toChangedString(?encode:Bool, ?name:String):String {
		return _toString(encode, true, name);
	}
	
	public function exists(name:String):Bool {
		return Reflect.hasField(_open_links, name);
	}
	
	public function link(name:String):PulsarLink {
		return _getOrCreate(name);
	}
	
	public function links():Array<PulsarLink> {
		var r:Array<PulsarLink> = [];
		Dice.Values(_open_links, function(v){
			r.push(v);
		});
		return r;
	}
	
	public function each(handler:PulsarLink->Bool):Void {
		Dice.Values(_open_links, handler);
	}
	
	public function refresh(?name:String):Void {
		Dice.Values(_open_links, function(list:PulsarLink){
			if (name == null || list.is(name)){
				list.refresh();
			}
		});
	}
	
	public function commit():Void {
		Dice.Values(_open_links, function(list:PulsarLink){
			list.commit();
		});
	}
	
	public function clone():Pulsar {
		var o:Pulsar = new Pulsar();
		o.parse(toString(false));
		return o;
	}
	
	public function getObject():Dynamic {
		var r:Dynamic = {};
		Dice.All(_open_links, function(p:String, v:PulsarLink):Void {
			if (!Reflect.hasField(r, p)){
				Reflect.setField(r, p, v.getObject(v.isSingle() ? null : []));
			}else {
				v.getObject(Reflect.field(r, p));
			}
		});
		return r;
	}
	
}
package jotun.tools;
import haxe.Json;
import jotun.serial.IOTools;
#if js
	import js.Browser;
#end
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose('Vault')
class Vault {
	
	/**
	   
	   @param	keyA
	   @param	keyB
	   @param	data
	   @return
	**/
	public static function getHash(keyA:String, keyB:String, data:Dynamic):String {
		var q:String = IOTools.encodeBase64(data);
		// KEYA.CONTENT.KEYB.TIME
		return IOTools.md5Encode('JTN:' + keyA + '.' + q) + '.' + q + '.' + IOTools.md5Encode('VLT:' + keyA + keyB) + '.' + (Std.int(Date.now().getTime()/1000));
	}
	
	/**
	   
	   @param	keyA
	   @param	keyB
	   @param	hash
	   @param	session
	   @return
	**/
	static private function get(keyA:String, keyB:String, hash:String, ?session:VaultObject):VaultObject {
		var time:Int = 0;
		var data:Dynamic = null;
		try {
			if (hash != null){
				var ks:Array<String> = hash.split('.');
				if (ks.length == 4){
					hash = ks[1];
					// KEYA[0].CONTENT[1].KEYB[2].TIME[3]
					if (ks[0] == IOTools.md5Encode('JTN:' + keyA + '.' + hash) && ks[2] == IOTools.md5Encode('VLT:' + keyA + keyB)){
						data = IOTools.decodeBase64(hash, true);
						time = Std.parseInt(ks[3]);
					}
				}
			}
		}catch (e:Dynamic){trace(e); }
		if (data == null){
			data = {};
		}
		if (session == null){
			session = new VaultObject(data);
		}else{
			Dice.All(data, function(p:Dynamic, v:Dynamic){
				Reflect.setField(session.data, p, v);
			});
		}
		session._kA = keyA;
		session._kB = keyB;
		session.time = time;
		return session;
	}
	
	#if php 
		
		public static function getSalt(key:String):String {
			return untyped __call__("password_hash", key, untyped __php__("PASSWORD_BCRYPT"), untyped __php__("['cost'=>12]"));
		}
		
		public static function match(key:String, hash:String):Bool {
			return untyped __call__("password_verify", key, hash);
		}
		
	#elseif js	
		
		static public function putLocal(keyA:String, keyB:String, data:Dynamic):Bool {
			try {
				Browser.window.localStorage.setItem(IOTools.md5Encode(keyA), getHash(keyA, keyB, data));
				return true;
			}catch (e:Dynamic){
				return false;
			}
		}
		
		static public function getLocal(keyA:String, keyB:String, ?o:VaultObject):Dynamic {
			return get(keyA, keyB, Browser.window.localStorage.getItem(IOTools.md5Encode(keyA)), o);
		}
		
		static public function clearLocal(keyA:String):Void {
			Browser.window.localStorage.removeItem(IOTools.md5Encode(keyA));
		}
		
	#end
	
}
package jotun.tools;

/**
 * ...
 * @author Rim Project
 */
class VaultObject {

	public var _kA:String;
	
	public var _kB:String;
	
	public var data:Dynamic;
	
	public var time:Int;
	
	public function new(?data:Dynamic){
		this.data = data;
	}
	
	public function isA(keyA:String):Bool {
		return _kA == keyA;
	}
	public function isB(keyB:String):Bool {
		return _kB == keyB;
	}
	
	#if js
		
		public function save():Bool {
			return Vault.putLocal(_kA, _kB, data);
		}
		
		public function load():VaultObject {
			Vault.getLocal(_kA, _kB, this);
			return this;
		}
		
		public function clear():VaultObject {
			Vault.clearLocal(_kA);
			return this;
		}
		
	#elseif php 
		
		public function save():Bool {
			Vault.put(_kA, _kB, data);
		}
		
		public function load(hash:String):Bool {
			Vault.get(_kA, _kB, hash, this);
		}
		
	#end
	
	public function allocate(keyA:String, keyB:String):VaultObject {
		_kA = keyA;
		_kB = keyB;
		return this;
	}
	
}
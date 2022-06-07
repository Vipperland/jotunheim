package jotun.idb;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class WebDBAssist {
	
	private var _ready:Bool;
	
	private var _db:WebDB;
	
	private var _name:String;
	
	private var _version:Int;
	
	private var _layout:Dynamic;
	
	private function _open(handler:Dynamic){
		if(_db == null){
			WebDB.open(_name, _version, function(db:WebDB){
				_db = db;
				if (_db.isUpgradeNeeded()){
					Dice.All(_layout, function(p:String, v:Dynamic){
						var t:WebDBTable = db.createTable(p, v.create);
						Dice.All(v.indexes, function(p1:Dynamic, v1:Dynamic){
							t.addIndex(p1+'_idx', p1, v1.indexes[p1]);
						});
					});
				}else{
					if(!_ready){
						_ready = true;
						_layout = null;
					}
					handler(_db);
				}
			});
		}
	}
	
	public function new(name:String, version:Int, layout:Dynamic) {
		_name = name;
		_version = version;
		_layout = layout;
	}
	
	public function table(name:String, mode:String, handler:WebDBTable->Void){
		if(_db != null){
			try {
				_db.getTables(name,  Utils.getValidOne(mode, 'rw'));
				handler(_db.table(name));
			}catch(e:Dynamic){
				handler(null);
			}
		}else{
			_open(function(db:WebDB){
				table(name, mode, handler);
			});
		}
	}
	
	
	public function put(tableName:String, key:String, value:Dynamic):Void {
		this.table(tableName, 'w', function(t1:WebDBTable){
			if(t1 != null){
				if(key != null){
					key = key+"";
					value._uid = key;
					t1.add(value);
				}else{
					key = value._uid;
					if(key != null){
						t1.get(key, function(t2:WebDBTable){
							var res:Dynamic = t2.getResult();
							if(res != null){
								t2.put(value);
							}else{
								t2.add(value);
							}
						});
					}
				}
			}
		});
	}
	
	public function get(tableName:String, key:String, handler:Dynamic->Void):Dynamic {
		var data:Dynamic = null;
		table(tableName, 'r', function(t1:WebDBTable){
			if (t1 != null){
				t1.get("" + key, function(res){
					data = res.getResult();
					if(handler != null){
						handler(data);
					}
				});
			}else if(handler != null){
				handler(null);
			}
		});
		return data;
	}
	
	public function upd(tableName:String, value:Dynamic):Void {
		this.table(tableName, 'w', function(table:WebDBTable){
			if(value._uid != null){
				table.put(value);
			}
		});
	}
	
	public function del(tableName:String, key:Dynamic){
		if (!Std.is(key, String)){
			if (Std.is(key, Float) || Std.is(key, Int)){
				key = '' + key;
			}else{
				key = key._uid;
			}
		}
		if(key != null){
			this.table(tableName, 'w', function(t1:WebDBTable){
				if(t1 != null){
					t1.delete(key);
				}
			});
		}
	}
	
	public function each(tableName:String, handler:Dynamic){
		this.table(tableName, 'rw', function(t1:WebDBTable){
			if(t1 != null){
				t1.each(handler);
			}
		});
	}
	
}
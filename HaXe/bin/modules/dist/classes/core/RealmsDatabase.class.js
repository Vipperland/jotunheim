export class RealmsDatabase {
		static #_me;
		#_db;
		#_state;
		#_info;
		constructor(name, version, structure){
			RealmsDatabase.#_me = this;
			this.#_state = 0;
			structure._props = {
				"create" : {"keyPath" : "_uid", "unique": true},
			};
			this.#_info = {
				name: name,
				version: version,
				structure: structure,
			};
		}
		#_open(callback){
			var $this = RealmsDatabase.#_me;
			if($this.#_db == null){
				$this.#_state = 1;
				J_WebDB.open($this.#_info.name, $this.#_info.version, function(db){
					$this.#_db = db;
					if(db.isUpgradeNeeded()){
						for(var p in  $this.#_info.structure){
							var o = $this.#_info.structure[p];
							var t = db.createTable(p, o.create);
							for(var q in o.indexes){
								t.addIndex(q+'_idx', q, o.indexes[q]);
							}
						}
					}else{
						if($this.#_state == 1){
							$this.#_state = 2;
							trace('[IndexedDB] << V' + $this.#_info.version + ' ready!');
						}
						if(callback != null){
							callback($this.#_db);
						}
					}
				});
			}
		}
		table(name, mode, callback){
			var $this = RealmsDatabase.#_me;
			if(callback == null && typeof mode == "function"){
				callback = mode;
				mode = 'rw';
			}
			if($this.#_db == null){
				$this.#_open(function(db){
					$this.table(name, mode, callback);
				});
			}else{
				try {
					$this.#_db.getTables(name, mode, function(table){});
					callback($this.#_db.table(name));
				}catch(e){
					trace('[IndexedDB] > Can´t find "' + name + '" table. ' + e.message);
					callback(null);
				}
			}
		}
		replace(key, value, callback){
			value._uid = key;
			this.put(null, value, callback);
		}
		put(key, value, callback){
			this.table('_props', 'w', function(table){
				if(table){
					if(key != null){
						key = key+"";
						value._uid = key;
						table.add(value);
						if(callback != null){
							callback(value);
						}
					}else{
						key = value._uid;
						if(key != null){
							table.get(key, function(tab){
								var res = tab.getResult();
								if(res){
									table.put(value);
								}else{
									table.add(value);
								}
								if(callback != null){
									callback(value);
								}
							});
						}
					}
				}
			});
		}
		upd(value){
			this.table('_props', 'w', function(table){
				if(value._uid != null){
					table.put(value);
				}
			});
		}
		get(id, callback){
			this.table('_props', 'r', function(table){
				if(table){
					table.get(""+id, function(res){
						if(callback != null){
							callback(res.getResult());
						}
					});
				}else{
					if(callback != null){
						callback(null);
					}
				}
			});
		}
		del(id, callback){
			this.table('_props', 'w', function(table){
				if(table){
					table.delete(""+id);
				}
				if(callback != null){
					callback();
				}
			});
		}
		each(callback){
			this.table('_props', 'rw', function(table){
				if(table){
					table.each(callback);
				}
			});
		}
	}
/**
 * ...
 * @author Rafael Moreira
 */
var OBJECT_UID = 0;
const NO_ROOM = {x:0, y:0, w:0, h:0, top:0, left:0, bottom:0, right: 0};
export default class StaticObject {
	#_id;
	#_name;
	#_data;
	#_room;
	#_visible;
	#_pending;
	#_updated;
	#_options;
	#_area;
	#_blocked;
	#_test(flag){
		return (this.#_options & flag) == flag;
	}
	#_testf(opt,flag){
		return (opt & flag) == flag;
	}
	constructor(name, x, y, width, height, options, data){
		this.#_id = '' + OBJECT_UID++;
		this.#_name = name;
		this.#_data = data || {};
		this.#_options = options || biome.data.Constants.TILE_WALKABLE;
		this.#_area = new biome.data.Location(x, y, width, height);
	}
	get room(){
		return this.#_room;
	}
	set room(value){
		this.#_room = value || NO_ROOM;
	}
	get biome(){
		return this.room.biome;
	}
	get isWalkable(){
		return !this.#_blocked && this.#_test(biome.data.Constants.TILE_WALKABLE);
	}
	get isSolid(){
		return this.#_test(biome.data.Constants.TILE_SOLID);
	}
	get data(){
		return this.#_data;
	}
	get id(){
		return this.#_id;
	}
	get name(){
		return this.#_name;
	}
	get top(){
		return this.room.top + this.#_area.yT;
	}
	get left(){
		return this.room.left + this.#_area.xT;
	}
	get bottom(){
		return this.room.top +this.#_area.yT + this.#_area.hT - 1;
	}
	get right(){
		return this.room.left + this.#_area.xT + this.#_area.wT - 1;
	}
	get localX(){
		return this.#_area.xT;
	}
	get localY(){
		return this.#_area.yT;
	}
	get globalX(){
		return (this.room ? this.room.left + this.#_area.xT: 0);
	}
	get globalY(){
		return (this.room ? this.room.top + this.#_area.yT: 0);
	}
	get biomePivotX(){
		return this.left + (this.#_area.wT >> 1);
	}
	get biomePivotY(){
		return this.top + (this.#_area.hT >> 1);
	}
	get visible(){
		return this.room && this.#_visible;
	}
	block(value){
		this.#_blocked = value;
	}
	get blocked(){
		return this.#_blocked;
	}
	#_load(){
		let object = this;
		this.room.biome.map(this.left, this.top, this.right, this.bottom, function(t){
			t.load(object);
		});
	}
	#_unload(){
		let object = this;
		this.room.biome.map(this.left, this.top, this.right, this.bottom, function(t){
			t.unload(object);
		});
	}
	load(){
		if(this.room && !this.#_visible){
			this.#_visible = true;
			this.#_load();
			return true;
		}else{
			return false;
		}
	}
	unload(){
		if(this.visible){
			this.room = null;
			this.#_visible = false;
			this.#_updated = false;
			this.#_pending = false;
			this.#_unload();
			return true;
		}else{
			return false;
		}
	}
	update(){
		if(!this.#_updated && this.visible){
			this.#_updated = true;
			this.#_pending = true;
			this.room.queue(this);
		}
	}
	commit(){
		if(this.#_pending == true){
			this.#_pending = false;
			return true;
		}else{
			return false;
		}
	}
	normalize(){
		if(this.#_updated == true){
			this.#_updated = false;
			if(this.room && this.room.biome){
				this.#_unload();
				this.#_area.sync();
				this.#_load();
			}
			return true;
		}else{
			return false;
		}
	}
	place(x,y){
		this.#_area.place(x,y);
	}
	move(x,y){
		this.#_area.move(x,y);
	}
	scale(w,h){
		this.#_area.scale(w,h);
	}
	get changed(){
		return this.#_area.changed;
	}
	get revert(){
		return this.#_area.revert;
	}
	get tx(){
		return this.#_room.biome.area.tx(this.biomeX);
	}
	get ty(){
		return this.#_room.biome.area.ty(this.biomeY);
	}
	/**
		
	**/
	outerTiles(){
		var tiles = biome.data.Utils.scanner();
		this.room.biome.map(this.left-1, this.top-1, this.right+1, this.top-1, tiles);
		this.room.biome.map(this.right+1, this.top, this.right+1, this.bottom, tiles);
		this.room.biome.map(this.left-1, this.top, this.left-1, this.bottom, tiles);
		this.room.biome.map(this.left-1, this.bottom+1, this.right+1, this.bottom+1, tiles);
		return tiles.result;
	}
	innerTiles(){
		return this.room.biome.map(this.left, this.top, this.right, this.bottom, null);
	}
	collision(filter){
		if(this.visible){
			return this.room.biome.collision(this.left, this.top, this.right, this.bottom, filter);
		}
	}
	signal(distance,filter){
		return this.room.biome.signal(this.biomePivotX, this.biomePivotY, distance, filter);
	}
	raycast(direction, distance, filter){
		var tiles = biome.data.Utils.scanner();
		switch(direction){
			case Constants.TOP : {
				this.room.biome.map(this.left, this.top, this.right, this.top, tiles);
				tiles.data = [{x:0,y:-1}];
				break;
			}
			case Constants.TOP_RIGHT : {
				this.room.biome.map(this.left, this.top, this.right, this.top, tiles);
				this.room.biome.map(this.left, this.top, this.right, this.top, tiles);
				tiles.data = [{x:1,y:-1}];
				break;
			}
			case Constants.RIGHT : {
				this.room.biome.map(this.right, this.top, this.right, this.bottom, tiles);
				tiles.data = [{x:1,y:0}];
				break;
			}
			case Constants.BOTTOM_RIGHT : {
				this.room.biome.map(this.left, this.bottom, this.right, this.bottom, tiles);
				this.room.biome.map(this.right, this.top, this.right, this.bottom, tiles);
				tiles.data = [{x:1,y:1}];
				break;
			}
			case Constants.BOTTOM : {
				this.room.biome.map(this.left, this.bottom, this.right, this.bottom, tiles);
				tiles.data = [{x:0,y:1}];
				break;
			}
			case Constants.LEFT : {
				this.room.biome.map(this.left, this.top, this.left, this.bottom, tiles);
				tiles.data = [{x:-1,y:0}];
				break;
			}
		}
		return this.room.biome.raycast(tiles.result, tiles.data, distance, filter);
	}
	path(x, y, filter){
		return this.room.biome.find(this.x, this.y, x, y, filter);
	}
	near(filter){
		return this.room.objects(filter);
	}
	toString(){
		return "[RomObject{id:" + this.id + ",name:" + this.name + ",x:" + this.biomeX + ",y:" + this.biomeY + ",width:" + this.position.width + ",height:" + this.position.height + "}]";
	}
	
}
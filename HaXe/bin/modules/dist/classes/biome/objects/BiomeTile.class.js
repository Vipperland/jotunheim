/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeScan} from '../data/BiomeScan.class.js';
import {BiomeUtils} from '../data/BiomeUtils.class.js';
export class BiomeTile {
	#_id;
	#_x;
	#_y;
	#_objects;
	#_biome;
	#_tTop;
	#_tTRight;
	#_tTLeft;
	#_tRight;
	#_tBottom;
	#_tBRight;
	#_tBLeft;
	#_tLeft;
	#_data;
	#_astar;
	#_locked;
	#_junctions;
	#_put(os,o){
		if(o != null){
			os[os.length] = o;
		}
		return os;
	}
	constructor(x,y,biome){
		this.#_id = x + '.' + y;
		this.#_x = x;
		this.#_y = y;
		this.#_objects = [];
		this.#_biome = biome;
		this.#_locked = false;
		this.#_junctions = [];
		this.#_astar = {
			f:0,
			g:0,
			g:0,
		};
		this.#_data = {};
	}
	/* 
		Check if tile is locked. Locked tiles are excluded in pathfind.
	*/
	get locked(){
		return this.#_locked == true;
	}
	/*
		Unique tile ID
	*/
	get id(){
		return this.#_id;
	}
	/*
		Grid x position
	*/
	get x(){
		return this.#_x;
	}
	/*
		Grid y position
	*/
	get y(){
		return this.#_y;
	}
	/*
		Custom tile data
	*/
	get data(){
		return this.#_data;
	}
	/*
		Temporary pathfind data
	*/
	get astar(){
		return this.#_astar;
	}
	/*
		Tile parent Biome
	*/
	get biome(){
		return this.#_biome;
	}
	/*
		Tile position x
	*/
	get tx(){
		return this.biome.area.tx(this.#_x);
	}
	/*
		Tile position y
	*/
	get ty(){
		return this.biome.area.ty(this.#_y);
	}
	/*
		Tile isometric position x
	*/
	get ax(){
		return this.biome.area.ax(this.#_x, this.#_y);
	}
	/*
		Tile isometric position y
	*/
	get ay(){
		return this.biome.area.ay(this.#_y, this.#_x);
	}
	/*
		If tile is in top border of the Biome
	*/
	get borderTop(){
		return this.#_y <= this.#_biome.area.top;
	}
	/*
		If tile is in right border of the Biome
	*/
	get borderRight(){
		return this.#_x >= this.#_biome.area.right;
	}
	/*
		If tile is in bottom border of the Biome
	*/
	get borderBottom(){
		return this.#_y >= this.#_biome.area.bottom;
	}
	/*
		If tile is in left border of the Biome
	*/
	get borderLeft(){
		return this.#_x <= this.#_biome.area.left;
	}
	/*
		The tile on top of this
	*/
	get tileTop(){
		if(!this.borderTop && this.#_tTop == null){
			this.#_tTop = this.#_biome.tile(this.#_x, this.#_y - 1);
		}
		return this.#_tTop;
	}
	/*
		The tile on top left of this
	*/
	get tileTopLeft(){
		if(!this.borderTop && !this.borderLeft && this.#_tTLeft == null){
			this.#_tTLeft = this.#_biome.tile(this.#_x - 1, this.#_y - 1);
		}
		return this.#_tTLeft;
	}
	/*
		The tile on top right of this
	*/
	get tileTopRight(){
		if(!this.borderTop && !this.borderRight && this.#_tTRight == null){
			this.#_tTRight = this.#_biome.tile(this.#_x + 1, this.#_y - 1);
		}
		return this.#_tTRight;
	}
	
	/*
		The tile on bottom of this
	*/
	get tileBottom(){
		if(!this.borderBottom && this.#_tBottom == null){
			this.#_tBottom = this.#_biome.tile(this.#_x, this.#_y + 1);
		}
		return this.#_tBottom;
	}
	
	/*
		The tile on bottom left of this
	*/
	get tileBottomLeft(){
		if(!this.borderBottom && !this.borderLeft && this.#_tBLeft == null){
			this.#_tBLeft = this.#_biome.tile(this.#_x - 1, this.#_y + 1);
		}
		return this.#_tBLeft;
	}
	/*
		The tile on bottom right of this
	*/
	get tileBottomRight(){
		if(!this.borderBottom && !this.borderRight && this.#_tBRight == null){
			this.#_tBRight = this.#_biome.tile(this.#_x + 1, this.#_y + 1);
		}
		return this.#_tBRight;
	}
	/*
		The tile on left of this
	*/
	get tileLeft(){
		if(!this.borderLeft && this.#_tLeft == null){
			this.#_tLeft = this.#_biome.tile(this.#_x - 1, this.#_y);
		}
		return this.#_tLeft;
	}
	/*
		The tile on right of this
	*/
	get tileRight(){
		if(!this.borderRight && this.#_tRight == null){
			this.#_tRight = this.#_biome.tile(this.#_x + 1, this.#_y);
		}
		return this.#_tRight;
	}
	/*
		Iterate all objects occupying this tile
	*/
	objects(filter){
		filter = BiomeUtils.scanner(filter);
		for(let i=0;i<this.#_objects.length;++i){
			filter.add(this.#_objects[i]);
			if(!filter.active){
				break;
			}
		}
	}
	/*
		Getts a copy of the list of objects occupying this tile
	*/
	get occupation(){
		return this.objects().result;
	}
	/*
		Load object in this tile
	*/
	load(object){
		if(!this.#_objects.includes(object)){
			this.#_objects.push(object);
		}
	}
	/*
		Unolad object from this tile
	*/
	unload(object){
		let iof = this.#_objects.indexOf(object);
		if(iof != -1){
			this.#_objects.splice(iof, 1);
		}
	}
	/*
		Creates a door/junction point in this tile
	*/
	junction(room){
		if(!this.#_junctions.includes(room)){
			this.#_junctions.push(room);
			this.#_locked = false;
		}
	}
	/*
		Iterate all doors/junctions in this tile
	*/
	junctions(filter){
		filter = BiomeUtils.scanner(filter);
		for(let i=0;i<this.#_junctions.length;++i){
			filter.add(this.#_junctions[i]);
			if(!filter.active){
				break;
			}
		}
	}
	/*
		Check if tile matches a position
	*/
	equals(x, y){
		return this.x == x && this.y == y;
	}
	/*
		Get a tile from this
	*/
	next(x,y){
		return this.#_biome.tile(this.x + x, this.y + y);
	}
	/*
		Get all four neightbors
	*/
	neighbors(filter){
		filter = BiomeUtils.scanner(filter);
		filter.add(this.tileTop);
		filter.add(this.tileRight);
		filter.add(this.tileBottom);
		filter.add(this.tileLeft);
		return filter;
	}
	/*
		Get all eight neightbors
	*/
	surroundings(filter){
		filter = BiomeUtils.scanner(filter);
		filter.add(this.tileTop);
		filter.add(this.tileTopRight);
		filter.add(this.tileRight);
		filter.add(this.tileBottomRight);
		filter.add(this.tileBottom);
		filter.add(this.tileBottomLeft);
		filter.add(this.tileLeft);
		filter.add(this.tileTopLeft);
		return filter;
	}
	/*
		Lock this tile in pathfind
	*/
	lock(){
		this.#_locked = this.#_junctions.length == 0 && value == true;
	}
	/*
		Unlock this tile in pathfind
	*/
	unlock(){
		return this.#_locked;
	}
	toString(){
		return "[BiomeTile{id:" + this.id + "}]";
	}
}
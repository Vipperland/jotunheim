/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeArea} from './BiomeArea.class.js';
import {BiomeConstants} from './BiomeConstants.class.js';
import {BiomeScan} from './BiomeScan.class.js';
import {BiomeUtils} from './BiomeUtils.class.js';
import {BiomeTile} from '../objects/BiomeTile.class.js';
export class BiomeGrid {
	#_tiles;
	#_area; 
	#_biome; 
	/*
		The tile grid [y,x]
	*/
	get tiles(){
		return this.#_tiles;
	}
	/*
		The grid area
	*/
	get area(){
		return this.#_area;
	}
	constructor(biome, tw, th){
		this.#_tiles = [];
		this.#_biome = biome;
		this.#_area = new BiomeArea(tw, th);
	}
	/*
		Creates tiles in grid
	*/
	create(x1,y1,x2,y2){
		let tx = x1;
		let ty = null;
		let t;
		this.#_area.fit(x1,y1,x2,y2);
		while(y1<y2){
			if(this.#_tiles[y1] == null){
				this.#_tiles[y1] = [];
			}
			ty = this.#_tiles[y1];
			while(x1<x2){
				if(ty[x1] == null){
					t = new BiomeTile(x1,y1,this.#_biome);
					ty[x1] = t;
					this.#_biome.heart.call(BiomeConstants.EVT_TILE_CREATED, t);
				}
				++x1;
			}
			x1 = tx;
			++y1;
		}
	}
	/*
		Iterate valid tiles in a area and calls fx(tile), can't go out of bounds
	*/
	map(x1,y1,x2,y2,filter){
		++x2;
		++y2;
		filter = BiomeUtils.scanner(filter);
		if(x1 < this.#_area.left){
			x1 = this.#_area.left;
		}
		if(x2 > this.#_area.right){
			x2 = this.#_area.right;
		}
		if(y1 < this.#_area.top){
			y1 = this.#_area.top;
		}
		if(y2 > this.#_area.bottom){
			y2 = this.#_area.bottom;
		}
		let tx = x1;
		let ty = null;
		let tz = null;
		main: while(y1<y2){
			ty = this.#_tiles[y1];
			while(x1<x2){
				filter.add(ty[x1]);
				if(!filter.active){
					break main;
				}
				++x1;
			}
			x1 = tx;
			++y1;
		}
		return filter;
	}
	/*
		Iterate points in a area and calls fx(x,y), can't go out of bounds
	*/
	point(x1,y1,x2,y2,filter){
		++x2;
		++y2;
		filter = BiomeUtils.scanner(filter);
		if(x1 < this.#_area.left){
			x1 = this.#_area.left;
		}
		if(x2 > this.#_area.right){
			x2 = this.#_area.right;
		}
		if(y1 < this.#_area.top){
			y1 = this.#_area.top;
		}
		if(y2 > this.#_area.bottom){
			y2 = this.#_area.bottom;
		}
		let tx = x1;
		main: while(y1<y2){
			while(x1<x2 && filter.active){
				filter.call(x1, y1);
				if(!filter.active){
					break main;
				}
				++x1;
			}
			x1 = tx;
			++y1;
		}
		return filter;
	}
	/*
		If tile point exists
	*/
	exists(x,y){
		return this.#_tiles[y] != null && this.#_tiles[y][x] != null;
	}
	/*
		Force a tile creation, if not exists
	*/
	fill(x, y){
		let c = this.#_tiles[y];
		if(c == null){
			c = [];
			this.#_tiles[y] = c;
		}
		let r = c[x];
		let t;
		if(r == null){
			t = new BiomeTile(x, y, this.#_biome);
			this.#_tiles[y][x] = t;
			this.#_biome.heart.call(BiomeConstants.EVT_TILE_CREATED, t);
			return t;
		} else {
			return r[x];
		}
	}
	/*
		Get a single tile in a location
	*/
	tile(x,y){
		return this.#_tiles[y][x];
	}
	/*
		Get all tiles in a location
	*/
	tiles(x1,y1,x2,y2,filter){
		return this.map(x1,y1,x2,y2,filter).result;
	}
	/* 
		Cast a line to any direction from source tiles and apply a movement path on each interaction, then calls fx(tile)
	*/
	raycast(source, movement, distance, scanner){
		scanner = BiomeUtils.scanner(scanner);
		let moved = 0;
		let found = 0;
		let current;
		let scanned = {};
		let cMov = 0;
		let mMov = movement.length;
		let direction;
		main: while(distance == null || moved < distance){
			for(var tile in source){
				found = 0;
				current = source[tile];
				if(current != null){
					direction = movement[cMov];
					current = source[tile].next(direction.x, direction.y);
					if(current && !scanned[current.id]){
						scanned[current.id] = true;
						scanner.add(current);
						if(!scanner.active){
							break main;
						}
						++found;
					}else{
						break;
					}
					source[tile] = current;
				}
				if(found == 0){
					break main;
				}
			}
			if(mMov > 1){
				if(++cMov >= mMov){
					cMov = 0;
				}
			}
			++moved;
		}
		return scanner;
	}
	/*
		Use A* algorithm to find a path between two locations, can be limited by a room area
	*/
	find(x1,y1,x2,y2,room,scanner){
		scanner = BiomeUtils.scanner(scanner);
		let pathfinder = new AStar(this.tile(x1,y1),this.tile(x2,y2),room,scanner);
		scanner.data.pathfinder = pathfinder;
		scanner.data.success = pathfinder.exec();
		return scanner;
	}
}
class AStar {
	open;
	closed;
	start;
	end;
	room;
	scanner;
	#_proxy;
	constructor(start,end,room,scanner){
		this.start = start;
		this.end = end;
		this.room = room;
		this.scanner = scanner;
		this.open = [];
		this.closed = [];
		scanner.result.push(start);
	}
	#_limit(tile){
		return this.room.inside(tile.x, tile.y);
	}
	#_neighbors(tile){
		if(tile.astar.neighbors == null){
			if(this.room == null){
				tile.astar.neighbors = tile.neighbors();
			}else{
				if(this.#_proxy == null){
					this.#_proxy = this.#_limit.bind(this);
				}
				tile.astar.neighbors = tile.neighbors(this.#_proxy);
			}
		}
		return tile.astar.neighbors;
	}
	resolve(current){
		let temp = current;
		this.scanner.result.push(temp);
		while (temp.parent) {
			this.scanner.result.push(temp);
			temp = temp.parent;
		}
	}
	exec(){
		let lower;
		let current;
		let neighbors;
		let neighbor;
		while(this.open.length > 0){
			for (let i = 0; i < this.open.length; i++) {
				if (open[i].astar.f < this.open[lower].astar.f) {
					lower = i;
				}
			}
			current = this.open[lower];
			if (current.id == this.end.id) {
				resolve(current);
				return true;
			}
			this.open.splice(lower, 1);
			this.closed.push(current);
			neighbors = this.#_neighbors(current).result;
			for (let i = 0; i < neighbors.length; i++) {
				neighbor = neighbors[i];
				if(!neighbor.locked && !this.closed.includes(neighbor)){
					let g = current.astar.g + 1;
					if (!this.open.includes(neighbor)) {
						if(this.scanner.test(neighbor)){
							this.open.push(neighbor);
						}else{
							continue;
						}
					} else if (g >= neighbor.astar.g) {
						continue;
					}
					neighbor.astar.g = g;
					neighbor.astar.h = BiomeMath.heuristic(neighbor.x, neighbor.y, this.target.x, this.target.y);
					neighbor.astar.f = neighbor.astar.g + neighbor.astar.h;
					neighbor.astar.parent = current;
				}
			}
		}
		this.#_proxy = null;
		this.open = null;
		this.closed = null;
		this.start = null;
		this.end = null;
		this.room = null;
		return false;
	}
}
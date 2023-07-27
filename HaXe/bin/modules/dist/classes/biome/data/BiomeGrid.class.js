/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeArea} from './BiomeArea.class.js';
import {BiomeConstants} from './BiomeConstants.class.js';
import {BiomeScan} from './BiomeScan.class.js';
import {BiomeTile} from '../objects/BiomeTile.class.js';
export class BiomeGrid {
	#_tiles;
	#_area; 
	#_biome; 
	get tiles(){
		return this.#_tiles;
	}
	get area(){
		return this.#_area;
	}
	constructor(biome, tw, th){
		this.#_tiles = [];
		this.#_biome = biome;
		this.#_area = new BiomeArea(tw, th);
	}
	create(x1,y1,x2,y2){
		let tx = x1;
		let ty = null;
		let t;
		this.#_area.fit(x1,y1,x2,y2);
		while(y1<=y2){
			if(this.#_tiles[y1] == null){
				this.#_tiles[y1] = [];
			}
			ty = this.#_tiles[y1];
			while(x1<=x2){
				t = new BiomeTile(x1,y1,this.#_biome);
				ty[x1] = t;
				this.#_biome.heart.call(BiomeConstants.EVT_TILE_CREATED, t);
				++x1;
			}
			x1 = tx;
			++y1;
		}
	}
	map(x1,y1,x2,y2,filter){
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
		var scanner = new BiomeScan(filter);
		let tx = x1;
		let ty = null;
		let tz = null;
		main: while(y1<=y2){
			ty = this.#_tiles[y1];
			while(x1<=x2){
				scanner.add(ty[x1]);
				if(!scanner.active){
					break main;
				}
				++x1;
			}
			x1 = tx;
			++y1;
		}
		return scanner;
	}
	point(x1,y1,x2,y2,filter){
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
		var scanner = new BiomeScan(filter);
		let tx = x1;
		main: while(y1<=y2){
			while(x1<=x2 && result.active){
				scanner.call(x1, y1);
				if(!scanner.active){
					break main;
				}
				++x1;
			}
			x1 = tx;
			++y1;
		}
		return scanner;
	}
	exists(x,y){
		return this.#_tiles[y] != null && this.#_tiles[y][x] != null;
	}
	tile(x,y){
		return this.#_tiles[y][x];
	}
	tiles(x1,y1,x2,y2){
		return this.map(x1,y1,x2,y2,null).result;
	}
	raycast(source, movement, distance, filter){
		let moved = 0;
		let found = 0;
		let current;
		let scanner = new BiomeScan(filter);
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
}
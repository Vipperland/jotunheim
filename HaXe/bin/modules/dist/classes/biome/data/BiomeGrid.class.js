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
		while(y1<y2){
			if(this.#_tiles[y1] == null){
				this.#_tiles[y1] = [];
			}
			ty = this.#_tiles[y1];
			while(x1<x2){
				t = new BiomeTile(x1,y1,this.#_biome);
				ty[x1] = t;
				this.#_biome.heart.call(BiomeConstants.EVT_TILE_CREATED, t);
				++x1;
			}
			x1 = tx;
			++y1;
		}
	}
	map(x1,y1,x2,y2,scanner){
		++x2;
		++y2;
		scanner = BiomeUtils.scanner(scanner);
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
	point(x1,y1,x2,y2,scanner){
		++x2;
		++y2;
		scanner = BiomeUtils.scanner(scanner);
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
			while(x1<x2 && result.active){
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
	tiles(x1,y1,x2,y2,filter){
		return this.map(x1,y1,x2,y2,filter).result;
	}
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
	find(x1,y1,x2,y2,scanner){
		scanner = BiomeUtils.scanner(scanner);
		scanner.data = new AStar(this.tile(x1,y1),this.tile(x2,y2),scanner);
		scanner.data.exec();
		return scanner;
	}
}
class AStar {
	open;
	closed;
	start;
	end;
	scanner;
	constructor(start,end,scanner){
		this.start = start;
		this.end = end;
		this.scanner = scanner;
		this.open = [];
		this.closed = [];
		scanner.result.push(start);
	}
	#_neighbors(tile){
		if(tile.astar.neighbors == null){
			tile.astar.neighbors = tile.neighbors();
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
		return false;
		
	}
}
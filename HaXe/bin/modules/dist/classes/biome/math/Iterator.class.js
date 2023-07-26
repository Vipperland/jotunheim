/**
 * ...
 * @author Rafael Moreira
 */
export class Iterator {
	static map(grid,x1,y1,x2,y2,fn){
		let tx = x1;
		let ty = null;
		let tz = null;
		while(y1<=y2){
			ty = grid[y1];
			while(x1<=x2){
				fn(ty[x1]);
				++x1;
			}
			x1 = tx;
			++y1;
		}
	}
	/* x++, y++ */
	static point(x1,y1,x2,y2,fn){
		let tx = x1;
		while(y1<=y2){
			while(x1<=x2){
				fn(x1,y1);
				++x1;
			}
			x1 = tx;
			++y1;
		}
	}
}
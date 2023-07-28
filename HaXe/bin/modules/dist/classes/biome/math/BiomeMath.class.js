export class BiomeMath {
	static movement(angle){
		return [{}];
	}
	static heuristic(x1,y1,x2,y2){
		x1 = x2 - x1;
		if(x1 < 0) {
			x1 = -x1;
		}
		y1 = y2 - y1;
		if(y1 < 0) {
			y1 = -y1;
		}
		return x1 + y1;
	}
}
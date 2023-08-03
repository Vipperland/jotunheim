/**
 * ...
 * @author Rafael Moreira
 */
export default class Designer {
	/* 
		Fill {tiles} into {target} 
		The target can be a Room or Biome.
		If a Room, tile positions will be shifted to match Room tiles
		If a Biome, tile positions start from {0,0} to {tiles[0].length, tiles.length}
	*/
	static landfill(tiles, target){
		var tinfo;
		var filter = {
			deep: false, 
			filter: function(t){
				tinfo = tiles[target.y - t.y];
				if(tinfo){
					t.data.layout = tinfo[target.x - t.x];
				}
			}
		}
		if(target instanceof biome.objects.room){
			target.map(filter);
			return;
		}
		if(target instanceof biome.objects.Biome){
			var ty = tiles.length;
			var tx = tiles[0].length;
			biome.map(0, 0, tx, ty, filter);
			return;
		}
	}
}
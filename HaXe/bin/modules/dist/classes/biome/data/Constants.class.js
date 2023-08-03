/**
 * ...
 * @author Rafael Moreira
 */
const BIT_0 = 1 << 0;
const BIT_1 = 1 << 1;
const BIT_2 = 1 << 2;
const BIT_3 = 1 << 3;

export default class Constants {
	
	static TOP = BIT_0;
	static RIGHT = BIT_1;
	static BOTTOM = BIT_2;
	static LEFT =  BIT_3;
	static TOP_RIGHT =  BIT_0 | BIT_2;
	static TOP_LEFT =  BIT_0 | BIT_3;
	static BOTTOM_RIGHT =  BIT_1 | BIT_2;
	static BOTTOM_LEFT =  BIT_1 | BIT_3;
	
	static WALL_TOP = BIT_0;
	static WALL_RIGHT = BIT_2;
	static WALL_BOTTOM = BIT_1;
	static WALL_LEFT = BIT_3;
	static WALL_HORIZONTAL = BIT_3 | BIT_2;
	static WALL_VERTICAL = BIT_0 | BIT_1;
	static WALL_ALL = BIT_0 | BIT_2 | BIT_1 | BIT_3;
	static WALL_OPEN_TOP = BIT_2 | BIT_1 | BIT_3;
	static WALL_OPEN_RIGHT = BIT_1 | BIT_3 | BIT_0;
	static WALL_OPEN_BOTTOM =  BIT_3 | BIT_0 | BIT_2;
	static WALL_OPEN_LEFT =  BIT_0 | BIT_2 | BIT_3;
	static WALL_TOP_RIGHT =  Constants.TOP_RIGHT;
	static WALL_TOP_LEFT =  Constants.TOP_LEFT;
	static WALL_BOTTOM_RIGHT =  Constants.BOTTOM_RIGHT;
	static WALL_BOTTOM_LEFT = Constants.BOTTOM_LEFT;
	
	static TILE_WALKABLE =  BIT_0;
	static TILE_SOLID =  BIT_1;
	static TILE_ACTIVE =  BIT_2;
	
	static EVT_TILE_CREATED = 'tilecreated';
	static EVT_TILE_UPDATE = 'tileupdated';
	static EVT_ROOM_ADDED = 'roomadded';
	static EVT_ROOM_LOADED = 'roomloaded';
	static EVT_ROOM_UNLOADED = 'roomunloaded';
	static EVT_ROOM_UPDATED = 'roomupdated';
	static EVT_OBJECT_LOADED = 'objectloaded';
	static EVT_OBJECT_UNLOADED = 'objectunloaded';
	static EVT_OBJECT_UPDATED = 'objectupdated';
	
}

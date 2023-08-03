/**
 * ...
 * @author Rafael Moreira
 */
class BehavioursPackage {
	constructor(classes){
	}
	get CoreBehaviour(){
		return Lib.CoreBehaviour;
	}
	get SampleBehaviour(){
		return Lib.SampleBehaviour;
	}
}
class CorePackage {
	constructor(classes){
	}
	get Brain(){
		return Lib.Brain;
	}
	get Heart(){
		return Lib.Heart;
	}
	get Scanner(){
		return Lib.Scanner;
	}
	get AdvScanner(){
		return Lib.AdvScanner;
	}
}
class DataPackage {
	constructor(classes){
	}
	get Area(){
		return Lib.Area;
	}
	get Constants(){
		return Lib.Constants;
	}
	get Grid(){
		return Lib.Grid;
	}
	get Location(){
		return Lib.Location;
	}
	get Tile(){
		return Lib.Tile;
	}
	get Utils(){
		return Lib.Utils;
	}
}
class ObjectPackage {
	constructor(classes){
	}
	get Room(){
		return Lib.Room;
	}
	get StaticObject(){
		return Lib.StaticObject;
	}
	get LiveObject(){
		return Lib.LiveObject;
	}
}
class LayoutPackage {
	constructor(classes){
	}
	get Designer(){
		return Lib.Designer;
	}
}
class MathPackage {
	constructor(classes){
	}
	get Math(){
		return Lib.Math;
	}
}
class BiomePackage {
	constructor(){ }
	/*
		Main Biome Class
	*/
	get Biome(){
		return Lib.Biome;
	}
	/*
		LiveMatter and Room behaviours collection
	*/
	get behaviours(){
		return Lib._behaviours;
	}
	/*
		Biome events and signals
	*/
	get cores(){
		return Lib._cores;
	}
	/*
		Tile and Object data
	*/
	get data(){
		return Lib._data;
	}
	/*
		Help creates visual for Rooms and Objects
	*/
	get layout(){
		return Lib._layout;
	}
	/*
		Biome math methods
	*/
	get math(){
		return Lib._math;
	}
	/*
		Tile Objects and Room
	*/
	get objects(){
		return Lib._objects;
	}
	/*
		Expose all Biome classes for direct access by Biome prefix (like BiomeRoom or BiomeStaticObject)
	*/
	glimpse(){
		for (let name in Lib) {
			window[(name != 'Biome' ? 'Biome' : '') + name] = Lib[name];
		}
	}
}
const Lib = new (function(){
	this._behaviours = new BehavioursPackage();
	this._objects = new ObjectPackage();
	this._cores = new CorePackage();
	this._data = new DataPackage();
	this._layout = new LayoutPackage();
	this._math = new MathPackage();
	this.add = function(p, v){
		this[p] = v.default;
	}
})();
window.biome = new BiomePackage();
Lib.add('Constants', await import('./data/Constants.class.js'));
Lib.add('Area', await import('./data/Area.class.js'));
Lib.add('Tile', await import('./data/Tile.class.js'));
Lib.add('Grid', await import('./data/Grid.class.js'));
Lib.add('Utils', await import('./data/Utils.class.js'));
Lib.add('Brain', await import('./cores/Brain.class.js'));
Lib.add('Heart', await import('./cores/Heart.class.js'));
Lib.add('Scanner', await import('./cores/Scanner.class.js'));
Lib.add('AdvScanner', await import('./cores/AdvScanner.class.js'));
Lib.add('Location', await import('./data/Location.class.js'));
Lib.add('Math', await import('./math/Math.class.js'));
Lib.add('Room', await import('./objects/Room.class.js'));
Lib.add('StaticObject', await import('./objects/StaticObject.class.js'));
Lib.add('LiveObject', await import('./objects/LiveObject.class.js'));
Lib.add('CoreBehaviour', await import('./behaviours/CoreBehaviour.class.js'));
Lib.add('SampleBehaviour', await import('./behaviours/SampleBehaviour.class.js'));
Lib.add('Designer', await import('./layout/Designer.class.js'));
Lib.add('Biome', await import('./objects/Biome.class.js'));
export const {biome} = window.biome;
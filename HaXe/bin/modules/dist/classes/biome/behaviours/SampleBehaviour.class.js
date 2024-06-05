/**
 * ...
 * @author Rafael Moreira
 */
let CoreBehaviour = biome.behaviours.CoreBehaviour;
export default class SampleBehaviour extends CoreBehaviour {
	constructor(){
		super();
	}
	update(object){
		let data = this.data(object);
		data.direction = (Math.random() > .5) ? 1 : -1;
		data.axys = Math.random() > .5 ? 'x' : 'y';
		switch(data.axys){
			case 'x' : {
				object.move(object.localX + data.direction, 0);
				break;
			}
			case 'y' : {
				object.move(0, object.localX + data.direction);
				break;
			}
		}
		object.update();
		trace(object.localX, object.localY);
	}
}
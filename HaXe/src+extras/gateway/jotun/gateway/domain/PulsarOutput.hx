package jotun.gateway.domain;
import haxe.Json;
import jotun.gaming.dataform.Pulsar;
import jotun.gaming.dataform.PulsarLink;
import jotun.gaming.dataform.Spark;
import jotun.gaming.dataform.SparkCore;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.utils.Omnitools;
import jotun.utils.Dice;
import php.Lib;

/**
 * ...
 * @author Rafael Moreira
 */
class PulsarOutput extends OutputCore {

	public function new() {
		super(new Pulsar());
	}
	
	override public function object(name:String):SparkCore {
		if (!cast (_data, Pulsar).exists(name)){
			cast (_data, Pulsar).insert(new Spark(name));
		}
		return cast (_data, Pulsar).link(name);
	}
	
	override public function list(name:String):Spark {
		return object(name).get(0);
	}
	
	override public function log(message:Dynamic, ?list:String = 'trace'):Void {
		if (_log){
			this.list('_logs').insert(new Spark('q').set('r', message));
		}
	}
	
	override public function error(code:Int, check:Bool = false):Void {
		this.list('errors').insert(new Spark('q').set('r', code));
	}
	
	override public function flush():Void {
		Pulsar.map("q", ['r'], Spark, false, false);
		Pulsar.map("time", ['value'], Spark, false, false);
		//Lib.dump(Input.getInstance().params);
		if (_log){
			Pulsar.map("_input", ['s','o'], Spark, false, false);
			_data.insert(new Spark('_input').set('s', InputCore.getInstance().params).set('o', InputCore.getInstance().object));
		}
		_data.insert(new Spark('time').set('value', Omnitools.timeNow()));
		Jotun.header.setPulsar(_data, false);
	}
	
	
}
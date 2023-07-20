package jotun.gateway.domain;
import haxe.Json;
import jotun.gaming.dataform.Pulsar;
import jotun.gaming.dataform.PulsarLink;
import jotun.gaming.dataform.Spark;
import jotun.gaming.dataform.SparkCore;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.flags.GatewayOptions;
import jotun.logical.Flag;
import jotun.utils.Omnitools;
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
	
	override public function setOptions(value:Int):Void {
		if (Flag.FTest(value, GatewayOptions.DEBUG)){
			// _logp > input params
			Pulsar.map("_logp", ['name', 'value'], Spark, false, false);
			// _logo > input object (json input:/)
			Pulsar.map("_logo", ['value'], Spark, false, false);
			Dice.All(input.params, function(p:String, v:String){
				this.list('_input').insert(new Spark('_logp').set('name', p).set('value', v));
			});
			if (input.object != null){
				this.list('_input').insert(new Spark('_logo').set('value', input.object));
			}
		}
		super.setOptions(value);
		if (_log){
			Pulsar.map("_logq", ['*'], Spark, false, false);
		}
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
			this.list('_logs').insert(new Spark('_logq').set('*', message));
		}
	}
	
	override public function error(code:Int, check:Bool = false):Void {
		this.list('errors').insert(new Spark('error').set('code', code));
	}
	
	override public function flush():Void {
		Pulsar.map("error", ['code'], Spark, false, false);
		Pulsar.map("time", ['*'], Spark, false, false);
		Pulsar.map("status", ['*'], Spark, false, false);
		_data.insert(new Spark('status').set('*', _status));
		_data.insert(new Spark('time').set('*', Omnitools.timeNow()));
		Jotun.header.setPulsar(_data, _encode_out, _chunk_size);
	}
	
	
}
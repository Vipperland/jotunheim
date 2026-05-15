package jotun.php.db.tools;
import haxe.DynamicAccess;
import haxe.Json;
import jotun.php.db.tools.Command;
import jotun.php.db.tools.IExtCommand;
import php.Lib;
import php.NativeArray;
import jotun.php.db.pdo.Connection;
import jotun.php.db.pdo.Statement;
import jotun.errors.Error;
import jotun.errors.ErrorDescriptior;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class ExtCommand extends CommandCore implements IExtCommand {

	public function execute(?handler:Dynamic->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>, ?contructArgs:Array<Dynamic>):IExtCommand {
		if (statement != null){
			var p:NativeArray = null;
			if (parameters != null)	{
				p = Lib.toPhpArray(parameters);
			}else if (_parameters != null){
				p = Lib.toPhpArray(_parameters);
			}
			try {
				if (type != null){
					if (!Std.isOfType(type, Float) && !Std.isOfType(type, String)){
						type = Type.getClassName(type).split('.').join('\\');
					}
				}else {
					type = '\\stdClass';
				}
				success = statement.execute(p);
				if (success) {
					var obj:Dynamic;
					result = [];
					while ((obj = statement.fetchObject(type))){
						result.push(obj);
						if (handler != null){
							handler(obj);
						}
					}
				}else {
					errors.push(new Error(statement.errorCode(), Lib.toHaxeArray(statement.errorInfo())));
				}
				this.statement = null;
			}catch (e:Dynamic) {
				if (Std.isOfType(e, String)) {
					errors.push(new Error(0, e));
				}else {
					errors.push(new Error(e.getCode(), e.getMessage()));
				}
			}
			if (_log != null) {
				_log((success ? "[1]" : "[0]") + " " + log());
			}
		}else {
			errors.push(new Error(0, "A connection with database is required."));
		}
		return this;
	}

	public function fetch(handler:Dynamic->Bool):IExtCommand {
		Dice.Values(result, handler);
		return this;
	}

	public function find(param:String, values:Array<Dynamic>, ?limit:UInt = 0):Array<Dynamic> {
		var filter:Array<Dynamic> = [];
		Dice.Values(result, function(v:Dynamic) {
			if (Dice.Match([(v:DynamicAccess<Dynamic>).get(param)], values, 1) > 0) {
				filter.push(v);
				return limit > 0 && --limit == 0;
			}
			return false;
		});
		return filter;
	}

	public function length(?prop:String = 'COUNT(*)'):UInt {
		if (result != null && result.length > 0){
			var r0:DynamicAccess<Dynamic> = cast result[0];
			if (r0.exists(prop)){
				return Std.parseInt(r0.get(prop));
			}else{
				return result.length;
			}
		}
		return 0;
	}

}

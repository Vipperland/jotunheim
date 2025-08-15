package jotun.php.file;
import jotun.php.file.FileInfo;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class FileCollection {
	
	public var list:Array<FileInfo> = [];
	
	public var named:Dynamic = {};
	
	public function new() {
		list = [];
		named = [];
	}
	
	/**
	 * Add a file to collection
	 * @param	part
	 * @param	file
	 */
	public function add(part:String, file:FileInfo):Void {
		list[list.length] = file;
		if (part != null){
			Reflect.setField(named, part, file);
		}
	}
	
	/**
	 * Get file by form name
	 * @param	name
	 * @return
	 */
	public function getByName(name:String):FileInfo {
		return Reflect.field(named, name);
	}
	
	/**
	 * Get a file by index
	 * @param	index
	 * @return
	 */
	public function getByIndex(index:UInt):FileInfo {
		return (list.length > index) ? list[index] : null;
	}
	
	/**
	 * Get the output list of file names
	 * @return
	 */
	public function getFileNames():Array<String> {
		var r:Array<String> = [];
		Dice.Values(list, function(v:FileInfo){
			if (v.type == 'image'){
				r[r.length] = v.output;
			}
		});
		return r;
	}
	
	/**
	 * Get files by type
	 * @param	type If not specified, will return a categorized object as result
	 * @return
	 */
	public function getByType(?type:String='*'):Dynamic {
		var r:Dynamic = type == '*' ? {} : [];
		Dice.Values(list, function(v:FileInfo){
			if (type == '*'){
				//<files>
				if(v.type == type){
					r[r.length] = v;
				}
			}else{
				// collection[type]=<files>
				if (!Reflect.hasField(r, v.type)) 
					Reflect.setField(r, v.type, []); 
				Reflect.field(r, v.type).push(v);
			}
		});
		return r;
	}
	
	public function each(method:FileInfo->Void):Void {
		Dice.Values(list, method);
	}
	
	public function extract(nametag:String):Array<String> {
		var paths:Array<String> = [];
		each(function (file:FileInfo){
			var size:IFileSizeInfo = file.get(nametag);
			if (size != null){
				paths.push(size.url);
			}
		});
		return paths;
	}
	
}
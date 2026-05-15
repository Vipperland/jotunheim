package jotun.php.file;
import haxe.DynamicAccess;
import jotun.php.file.FileInfo;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class FileCollection {

	public var list:Array<FileInfo> = [];

	public var named:DynamicAccess<FileInfo> = {};

	public function new() {
		list = [];
		named = {};
	}

	/**
	 * Add a file to collection
	 * @param	part
	 * @param	file
	 */
	public function add(part:String, file:FileInfo):Void {
		list.push(file);
		if (part != null){
			named.set(part, file);
		}
	}

	/**
	 * Get file by form name
	 * @param	name
	 * @return
	 */
	public function getByName(name:String):FileInfo {
		return named.get(name);
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
			if (v.image){
				r.push(v.output);
			}
		});
		return r;
	}

	/**
	 * Get files by type
	 * @param	type If not specified, will return a categorized object as result
	 * @return
	 */
	public function getByType(?type:String = '*'):Dynamic {
		if (type == '*') {
			var r:DynamicAccess<Array<FileInfo>> = {};
			Dice.Values(list, function(v:FileInfo){
				if (!r.exists(v.type)) r.set(v.type, []);
				r.get(v.type).push(v);
			});
			return r;
		} else {
			var r:Array<FileInfo> = [];
			Dice.Values(list, function(v:FileInfo){
				if (v.type == type) r.push(v);
			});
			return r;
		}
	}

	public function each(method:FileInfo->Void):Void {
		Dice.Values(list, method);
	}

	public function extract(nametag:String):Array<String> {
		var paths:Array<String> = [];
		each(function(file:FileInfo){
			var size:IFileSizeInfo = file.get(nametag);
			if (size != null){
				paths.push(size.url);
			}
		});
		return paths;
	}

}

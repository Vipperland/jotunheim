package jotun.php.file;
import haxe.DynamicAccess;
import haxe.io.Bytes;
import jotun.Jotun;
import php.Global;
import php.Lib;
import php.SuperGlobal;
import php.Web;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.Dice;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Uploader {

	public static var files:FileCollection = new FileCollection();

	private static var _callbacks:DynamicAccess<Dynamic>;

	private static var _sizes:Array<Dynamic>;

	private static var _path:String = '';

	private static var _autoRename:Bool;

	private static var _log_method:String->Dynamic->Void;

	public static function onLog(method:String->Dynamic->Void):Void {
		_log_method = method;
	}

	private static function _webPath(path:String):String {
		var root:String = php.SuperGlobal._SERVER['DOCUMENT_ROOT'];
		while (root.length > 0 && root.charAt(root.length - 1) == '/') root = root.substr(0, root.length - 1);
		if (path.indexOf(root) == 0) path = path.substr(root.length);
		return path;
	}

	private static function _resolvePath(path:String):String {
		var root:String = php.SuperGlobal._SERVER['DOCUMENT_ROOT'];
		while (root.length > 0 && root.charAt(root.length - 1) == '/') root = root.substr(0, root.length - 1);
		while (path.length > 0 && path.charAt(0) == '/') path = path.substr(1);
		if (path.length > 0 && path.charAt(path.length - 1) != '/') path += '/';
		return root + '/' + path;
	}

	public static function createPath(q:String):Void {
		var p:String = _resolvePath(q);
		var cur:String = '/';
		Dice.Values(p.split('/'), function(v:String){
			if (v.length > 0){
				cur += v + '/';
				if (!FileSystem.exists(cur) || !FileSystem.isDirectory(cur)){
					php.Syntax.codeDeref("mkdir({0},{1})", cur, php.Syntax.codeDeref('0777'));
					_log('path:created', cur);
				}
			}
		});
	}

	static function _log(action:String, message:Dynamic):Void {
		if(_log_method != null){
			_log_method(action, message);
		}
	}

	public static function save(path:String, ?rules:Array<Dynamic>, ?rename:Bool = true):FileCollection {

		_autoRename = rename;

		files = new FileCollection();

		var resolved:String = _resolvePath(path);
		if (_path != resolved){
			createPath(path);
			_path = resolved;
		}

		if (rules != null){
			_callbacks = { };
			_sizes = [];
			Dice.Values(rules, function(q:Dynamic){
				if (q.path != null){
					createPath(q.path);
				}
				if(q.resize) {
					_sizes.push(q);
				}
				if(q.filter != null && q.callback != null){
					_callbacks.set(q.filter, q.callback);
				}
			});
			_log('upload:rules', rules);
		}

		var _exc:Dynamic = null;
		try {
			_verify();
		} catch (e:Dynamic) {
			_exc = e;
		}
		_callbacks = null;
		_sizes = null;
		if (_exc != null) throw _exc;

		return files;
	}

	static private function _verify() {

		var partName:String = null;
		var lastFile:String = null;
		var fileStream:FileOutput = null;

		// Get all form data
		try {
			Jotun.domain.parseFiles(
				function(part:String, name:String):Void {
					// Save only specified files to disk and skip form params
					if (Utils.isValid(name)) {
						if (lastFile != name) {
							partName = part;
							lastFile = name;
							// Close current stream
							if (fileStream != null){
								fileStream.close();
							}
							// Generate new filename
							var ext:String = name.split(".").pop();
							var nName:String = null;
							if(_callbacks != null && _callbacks.exists(ext)){
								nName = _callbacks.get(ext)(part, name);
							}else{
								nName = _autoRename ? Jotun.time + '_' + Key.GEN(8) + '.' + ext : name;
							}
							// save file to disk
							fileStream = File.write(_path + nName, true);
							var file:FileInfo = new FileInfo(ext, name, nName);
							files.add(part, file);
							_log('uploaded', file);
						}
					}else {
						if (fileStream != null){
							fileStream.close();
							fileStream = null;
						}
					}
				},
				function(bytes:Bytes, pos:Int, len:Int):Void {
					// Write current file bytes
					if (fileStream != null){
						fileStream.writeBytes(bytes, pos, len);
					}
				}
			);
		} catch (e:Dynamic) {
			if (fileStream != null){
				fileStream.close();
				fileStream = null;
			}
			throw e;
		}
		if (fileStream != null){
			fileStream.close();
			fileStream = null;
		}

		// Iterate all "image" type files
		if (_sizes != null){
			var image:Image = new Image();
			Dice.Values(files.list, function(v:FileInfo) {
				if (v.image) {
					v.sizes = [];
					var shouldDelete = false;
					// size.type = EXTENSION
					// v.type = EXTENSION
					// image.type = INT
					Dice.Values(_sizes, function(resizeRule:Dynamic):Void {

						var o:String = _path + v.output;

						image.open(o);

						var create:Bool = resizeRule.create == true;
						var resize:Bool = resizeRule.width != null && resizeRule.height != null && image.isOutBounds(resizeRule.width, resizeRule.height);
						var convert:Bool = resizeRule.type != null && v.type != resizeRule.type;
						var rename:Bool = resizeRule.callback != null;

						if (resizeRule.path != null){
							o = _resolvePath(resizeRule.path) + v.output;
						}

						if (rename){
							o = resizeRule.callback(o);
						}else {
							o = _rename(o, resizeRule.sufix, resizeRule.type);
						}

						if(convert){
							o = o.split('.' + v.type).join('.' + resizeRule.type);
						}

						if(resize){
							image.fit(resizeRule.width, resizeRule.height);
						}

						if (create || rename || resize || convert){
							image.save(o, resizeRule.type, resizeRule.quality);
							_log('saving', { name: o, type: resizeRule.type });
							if(resizeRule.id == null){
								resizeRule.id = image.width + 'x' + image.height;
							}
							v.sizes.push(cast { width: image.width, height: image.height, url: _webPath(o), id: resizeRule.id });
							_log('changed', { file: v, size: resizeRule, created: create, rename: rename, resize: resize, convert: convert });
						}

						if (!shouldDelete && resizeRule.shouldDelete){
							shouldDelete = true;
						}

					});
					if (shouldDelete && image.isValid()){
						image.open(_path + v.output);
						_shouldDelete(image);
					}
				}
			});
		}

	}

	private static function _shouldDelete(image:Image):Void {
		image.destroy();
		image.dispose();
		_log('shouldDeleted', { file: image });
	}

	private static function _rename(o:String, p:String, t:String):String {
		var n:Array<String> = o.split('.');
		var e:String = n.pop();
		if (p != null){
			n.push(p);
		}
		n.push(t == null ? e : t);
		return n.join('.');
	}

}

package gate.sirius.modloader.data {
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import gate.sirius.modloader.data.LoadOrder;
	import gate.sirius.modloader.ModLoader;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class StartupData {
		
		private var _properties:Object;
		
		private var _loadorder:LoadOrder;
		
		public var loaderscreen:String;
		
		
		public function StartupData(resources:ModLoader) {
			_properties = {};
			_loadorder = new LoadOrder(resources);
		}
		
		
		public function get properties():Object {
			return _properties;
		}
		
		
		public function get loadorder():LoadOrder {
			return _loadorder;
		}
		
		
		public function checkFile(config:File):String {
			var data:String;
			var stream:FileStream = new FileStream();
			if (!config.exists) {
				data = "//SIRIUS CONFIG FILE\nloadorder{\n\t@add loader 0\n\t@add core 1\n}\nproperties{\n\t//statup properties\n}";
				stream.open(config, FileMode.WRITE);
				stream.writeUTFBytes(data);
			} else {
				stream.open(config, FileMode.READ);
				data = stream.readUTFBytes(stream.bytesAvailable);
			}
			stream.close();
			stream = null;
			return data;
		}
		
		
		public function createInfoFile(file:File, name:String, version:String, author:String, description:String, preinit:String):void {
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			var content:String = "mod{\n\t@name " + name.split(" ").join("_") + " " + version + "\n\t@author " + author + "\n\t@description " + description + "\n\t@onload " + preinit + "\n}\n";
			stream.writeUTFBytes(content);
			stream.close();
			stream = null;
		}
	
	}

}


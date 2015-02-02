package gate.sirius.file {
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class FileInfo implements IFileInfo {
		
		private var _extra:Object;
		
		private var _name:String;
		
		private var _uri:*;
		
		private var _type:String;
		
		private var _content:*;
		
		private var _error:*;
		
		private var _time:int;
		
		private var _extension:String;
		
		
		public function FileInfo(name:String, uri:*, type:String, extra:Object) {
			
			_extra = extra;
			
			_uri = uri;
			
			_name = name;
			
			if (_name.indexOf("."))
				_extension = _name.split(".").pop();
			
			_type = type;
		
		}
		
		
		public function dispose():void {
			_content = null;
			_error = null;
			_type = null;
			_extra = null;
			_uri = null;
			_name = null;
		}
		
		
		public function get name():String {
			return _name;
		}
		
		
		public function get extension():String {
			return _extension;
		}
		
		
		public function get uri():* {
			return _uri;
		}
		
		
		public function get type():String {
			return _type;
		}
		
		
		public function get content():* {
			return _content;
		}
		
		
		public function set content(value:*):void {
			_content = value;
		}
		
		
		public function get extra():Object {
			return _extra;
		}
		
		
		public function get error():* {
			return _error;
		}
		
		
		public function set error(value:*):void {
			_error = value;
		}
		
		
		public function get time():int {
			return _time;
		}
		
		
		public function set time(value:int):void {
			_time = value;
		}
	
	}

}
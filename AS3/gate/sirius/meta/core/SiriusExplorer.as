package gate.sirius.meta.core {
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SiriusExplorer {
		
		private static const NOT_COMPRESSED:int = 0x46;
		
		private static const COMPRESSED:int = 0x43;
		
		private static const FULL:int = 0x3F;
		
		private static const SYMBOLCLASS:int = 0x4C;
		
		public static const CLASSES:String = "classes";
		
		public static const ACCELERATION:String = "acceleration";
		
		private var _stream:ByteArray;
		
		private var _compressed:int;
		
		private var _nBits:int;
		
		private var _version:int;
		
		private var _length:int;
		
		private var _swf:ByteArray;
		
		private var _frameRate:int;
		
		private var _frameCount:int;
		
		private var _dictionary:Array;
		
		private var _arrayClasses:Array;
		
		private var _accelerationType:int;
		
		private var _criteria:int;
		
		private var _currentByte:int;
		
		private var _bitPosition:int;
		
		private var _buffer:uint = 0;
		
		private var _pointer:uint = 0;
		
		private var _source:uint;
		
		
		public function SiriusExplorer(bytes:ByteArray = null) {
		
		}
		
		
		public function search(bytes:ByteArray):Array {
			
			_arrayClasses = new Array();
			
			_stream = bytes;
			
			_stream.position = 0;
			
			_compressed = _stream.readUnsignedByte();
			
			_stream.position += 2;
			
			_version = _stream.readUnsignedByte();
			
			_stream.endian = Endian.LITTLE_ENDIAN;
			
			_length = _stream.readUnsignedInt();
			
			_stream.endian = Endian.BIG_ENDIAN;
			
			_swf = new ByteArray();
			
			_stream.readBytes(_swf, 0);
			
			if (_compressed == SiriusExplorer.COMPRESSED) {
				_swf.uncompress();
			}
			
			var firstBRect:uint = _swf.readUnsignedByte();
			
			var size:uint = firstBRect >> 3;
			var offset:uint = (size - 3);
			
			var threeBits:uint = firstBRect & 0x7;
			
			_source = _swf.readUnsignedByte();
			
			var xMin:uint = _readBits(offset) | (threeBits << offset) / 20;
			var yMin:uint = _readBits(size) / 20;
			var wMin:uint = _readBits(size) / 20;
			var hMin:uint = _readBits(size) / 20;
			
			var frameRate:uint = _swf.readShort() & 0xFF;
			
			var numFrames:uint = _swf.readShort();
			
			var frameCount:uint = (numFrames >> 8) & 0xFF | ((numFrames & 0xFF) << 8);
			
			_swf.endian = Endian.LITTLE_ENDIAN;
			
			_dictionary = _browseTables();
			
			_criteria = SYMBOLCLASS;
			
			var symbolClasses:Array = _dictionary.filter(_filter);
			
			var i:int;
			var count:int;
			var char:int;
			var name:String;
			
			if (symbolClasses.length > 0) {
				_swf.position = symbolClasses[0].offset;
				
				count = _swf.readUnsignedShort();
				
				for (i = 0; i < count; i++) {
					_swf.readUnsignedShort();
					
					char = _swf.readByte();
					name = new String();
					
					while (char != 0) {
						name += String.fromCharCode(char);
						char = _swf.readByte();
					}
					_arrayClasses[_arrayClasses.length] = name;
				}
				
			}
			
			_stream = null;
			_swf = null;
			
			return _arrayClasses;
		
		}
		
		
		private function _readBits(numBits:uint):uint {
			_buffer = 0;
			var currentMask:uint;
			var bitState:uint;
			for (var i:uint = 0; i < numBits; i++) {
				currentMask = (1 << 7) >> _pointer++;
				bitState = uint((_source & currentMask) != 0);
				_buffer |= bitState << ((numBits - 1) - i);
				if (_pointer == 8) {
					_source = _swf.readUnsignedByte();
					_pointer = 0;
				}
			}
			return _buffer;
		}
		
		
		private function _filter(element:TagInfos, index:int, array:Array):Boolean {
			return element.tag == _criteria;
		}
		
		
		private function _browseTables():Array {
			var currentTag:int;
			var step:int;
			var dictionary:Array = new Array();
			var infos:TagInfos;
			
			while (_swf.bytesAvailable && (currentTag = ((_swf.readShort() >> 6) & 0x3FF))) {
				infos = new TagInfos();
				
				infos.tag = currentTag;
				infos.offset = _swf.position;
				_swf.position -= 2;
				step = _swf.readShort() & 0x3F;
				
				if (step < SiriusExplorer.FULL)
					_swf.position += step;
				else {
					step = _swf.readUnsignedInt();
					infos.offset = _swf.position;
					_swf.position += step;
				}
				infos.endOffset = _swf.position;
				dictionary[dictionary.length] = infos;
			}
			return dictionary;
		}
	
	}
}

class TagInfos {
	
	public var offset:int;
	
	public var endOffset:int;
	
	public var tag:int;
	
	
	public function TagInfos() {
	
	}

}
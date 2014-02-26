package gate.sirius.serializer.signals
{
	import gate.sirius.serializer.SruDecoder;
	import gate.sirius.signals.Signal;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruDecoderSignal extends Signal
	{
		
		static public const COMPLETE:String = "COMPLETE";
		
		static public const START:String = "START";
		
		static public const PAUSE:String = "PAUSE";
		
		static public const ERROR:String = "ERROR";
		
		private var _decoder:SruDecoder;
		
		public function SruDecoderSignal(name:String, decoder:SruDecoder)
		{
			super(name);
			_decoder = decoder;
		
		}
		
		public function get decoder():SruDecoder
		{
			return _decoder;
		}
		
		public function extractOne(type:Class):*
		{
			for each (var t:*in _decoder.content)
			{
				if (t is type)
				{
					break;
				}
			}
			return t;
		}
		
		public function extractAll(type:Class):Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			var len:int = 0;
			for each (var t:*in _decoder.content)
			{
				if (t is type)
				{
					result[len] = t;
					++len;
				}
			}
			return result;
		}
	
	}

}
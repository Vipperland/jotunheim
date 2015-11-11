package iam.rim.data;
import sirius.data.DataCache;
import sirius.data.DataSet;
import sirius.data.IDataCache;
import sirius.data.IDataSet;
import sirius.errors.IError;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira
 */
class Output{
	
	static private var _stream:IDataCache = new DataCache();
	
	static public var errors(get, null):Array<IError>;
	static private function get_errors():Array<IError> {
		if (!_stream.exists("errors")) _stream.set("errors", Sirius.gate.errors);
		return _stream.get('errors');
	}
	
	static public var result(get, null):Dynamic;
	static private function get_result():Dynamic {
		if (!_stream.exists("result")) _stream.set("result", {});
		return _stream.get('result');
	}
	
	static public function write() {
		result.success = errors.length == 0;
		Sirius.header.setJSON(_stream.data);
	}
	
}
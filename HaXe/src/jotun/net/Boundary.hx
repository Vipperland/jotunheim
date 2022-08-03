package jotun.net;
import js.html.File;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Boundary {
	
	static public var header:String = "multipart/form-data; boundary=AJAX-----------------------";

	static public function create(data:Dynamic):String {
		
		var bounds:String = "AJAX-----------------------";
		var CRLF = "\r\n";
		var parts = [];
		
		Dice.All(data, function(p:String, v:Dynamic) {
			
			var part:String = "";
			
			if (Std.isOfType(v, File)) {
				
				part += 'Content-Disposition: form-data; ';
				part += 'name="' + p + '"; ';
				part += 'filename="'+ v.fileName + '"' + CRLF;
				part += "Content-Type: application/octet-stream";
				part += CRLF + CRLF;
				part += v.fileBits() + CRLF;
				
			} else {
				
				part += 'Content-Disposition: form-data; ';
				part += 'name="' + p + '"' + CRLF + CRLF;
				part += Std.string(v) + CRLF;
				
			}   
			parts.push(part);
		});

		var request = "--" + bounds + CRLF;
		request+= parts.join("--" + bounds + CRLF);
		request+= "--" + bounds + "--" + CRLF;

		return request;
		
	}
	
}
package;
import php.Lib;
import sirius.Sirius;
import sirius.db.Clause;
import sirius.db.Token;
import sirius.db.objects.IDataTable;
import sirius.db.objects.ITableObject;
import sirius.php.file.ImageLib;
import sirius.php.file.Uploader;
import sirius.tools.Key;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		//var img:Image = new Image('../assets/img/image.jpg');
		//img.fit(300,300).save('../assets/img/test.jpg');
		trace('===================================================== Headers');
		Dice.All(Sirius.domain.data, function(p:String, v:String){
			trace(p + ': ' + v);
		});
		trace('===================================================== Parameters: GET/POST');
		Dice.All(Sirius.domain.params, function(p:String, v:String){
			trace(p + ': ' + v);
		});
		trace('===================================================== APPLICATION/JSON Content-Type');
		trace(Utils.sruString(Sirius.domain.input));
		
		trace('===================================================== Files');
		trace(Uploader.save([[1280, 720], [720, 480], [480, 360]]).list);
		
		Sirius.gate.open(Token.localhost('rimproject'), true);
		if (Sirius.gate.isOpen()){
			trace('HANDSHAKE OK');
			var t:IDataTable = Sirius.gate.table('test');
			t.add({mystring:Key.GEN(32), mybool:Math.random() > .5, myint2:Std.int(Math.random() * 100)});
			t.findAll(Clause.AND([Clause.NOT_NULL('mystring')])).each(cast function(o:Dynamic){
				trace(o.data.mystring);
			});
		}else{
			trace(Sirius.gate.errors);
		}
		
	}
	
}
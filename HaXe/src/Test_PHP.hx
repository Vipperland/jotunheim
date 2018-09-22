package;
import sirius.Sirius;
import sirius.db.Token;
import sirius.db.objects.IDataTable;
import sirius.php.file.Uploader;
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
		
		Sirius.gate.open(Token.localhost('decorador'), true);
		if (Sirius.gate.isOpen()){
			trace('HANDSHAKE OK');
			var t:IDataTable = Sirius.gate.table('project_review');
			t.add({project_id:1, content:'test', content_alt:'another test', active:true, created_at:0, updated_at:0});
			t.findAll().each(cast function(o:Dynamic){
				trace(o.id);
			});
		}else{
			trace(Sirius.gate.errors);
		}
		
	}
	
}
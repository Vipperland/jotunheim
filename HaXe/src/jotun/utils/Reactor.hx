package jotun.utils;
import jotun.dom.Displayable;
import jotun.dom.Input;
import jotun.tools.Utils;
import js.Syntax;
import js.html.Element;

/**
 * ...
 * @author 
 */
class Reactor {
	
	static private var _listeners:Array<Displayable->Void> = [];
	
	static private function _dispatch(o:Displayable):Void {
		for(i in 0..._listeners.length){
			_listeners[i](o);
		}
	}
	
	static private function _react_clear(o:Displayable, attr:String, prop:String){
		if (o.hasAttribute(attr)){
			o.clearAttribute(prop);
		}
	}
	
	static private function _react_commit_up(o:Displayable){
		if (o.data.__co == null){
			o.data.__co = true;
			o.attribute('o-commit', 'true');
		}
	}
	
	static private function _strip(q:String):String {
		var result:Array<String> = q.split('{{');
		if(result.length > 0){
			Dice.All(result, function(q:Int, v:String):Void {
				result[q] = v.split('}}')[1];
			});
		}
		return result.join('');
	}
	
	static private function _commit(data:Dynamic, o:Displayable){
		if(o.data.__qa){
			Dice.Values(o.data.__qa.split(';'), function(v:Dynamic){
				if(v.length > 3){
					v = v.split(":");
					o.attribute(v.shift(), v.join(":"));
				}
			});
			Reflect.deleteField(o.data, '__qa');
			_react_clear(o, 'o-single', 'o-attr');
		}
		if(o.data.__qc != null){
			o.css(_strip(o.data.__qc));
			Reflect.deleteField(o.data, '__qc');
			_react_clear(o, 'o-single', 'o-class');
		}
		if(o.data.__qd != null){
			o.data.__qd = Std.isOfType(o.data.__qd, String) ? Utils.rnToBr(o.data.__qd) : o.data.__qd;
			if (Std.isOfType(o, Input)){
				o.value(o.data.__qd);
			}else{
				o.writeHtml(o.data.__qd);
			}
			Reflect.deleteField(o.data, '__qd');
			_react_clear(o, 'o-single', 'o-data');
		}
		if(o.data.__qs != null){
			Dice.Values(o.data.__qs.split(';'), function(v:Dynamic){
				v = v.split(":");
				o.style(v.shift(), v.join(":"));
			});
			Reflect.deleteField(o.data, '__qs');
			_react_clear(o, 'o-single', 'o-style');
		}
	}
	
	static private function _commit_visibility(data:Dynamic, o:Displayable, attr:String, foo:Dynamic){
		if (o.data.__qv != null &&  o.data.__qv == attr){
			if (o.data.__qvs >= o.data.__qvt){
				if (attr == 'o-show-if'){
					o.show();
				}else{
					o.hide();
				}
			}else{
				if (attr == 'o-show-if'){
					o.hide();
				}else{
					o.show();
				}
			}
			Reflect.deleteField(o.data, '__qv');
			Reflect.deleteField(o.data, '__qvt');
			Reflect.deleteField(o.data, '__qvs');
		}
	}
	
	static private function _react_fill_after(to:Displayable, data:Dynamic):Void {
		to.all('[o-commit]').add(to).each(function(o:Displayable){
			_commit(to.data, o);
			_commit(to.data, o);
			_commit(to.data, o);
			_commit(to.data, o);
			_commit_visibility(to.data, o, 'o-show-if', data);
			_commit_visibility(to.data, o, 'o-hide-if', data);
			Reflect.deleteField(o.data, '__co');
			o.clearAttribute('o-commit');
		});
	}
	
	/**
	 * pipadata="{{a}} {{b}} {{c}} ..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_data(data:Dynamic, path:String, o:Displayable){
		if (o.hasAttribute('o-data')){
			if(path != null){
				if (o.data.__qd == null){
					o.data.__qd = o.attribute('o-data');
					_react_commit_up(o);
				}
				o.data.__qd = o.data.__qd.split('{{' + path + '}}').join(data);
			}
			
		}
	}
	
	/**
	 * 
	 * @param	data
	 * @param	path
	 * @param	o
	 * @param	attr
	 */
	static private function _react_fill_visibility(data:Bool, path:String, o:Displayable, attr:String){
		if (o.hasAttribute(attr)){
			if(path != null){
				if (o.data.__qv == null){
					o.data.__qv = attr;
					o.data.__qvt = o.hasAttribute('o-score') ? o.attribute('o-score') : o.attribute(attr).split(',').length;
					o.data.__qvs = 0;
					_react_commit_up(o);
				}
				if (data){
					o.data.__qvs += 1;
				}
			}
		}
	}
	
	/**
	 * pipaclass="{{a}} {{b}} {{c}} ..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_class(data:Dynamic, path:String, o:Displayable){
		if (o.hasAttribute('o-class')){
			if(path != null){
				if (o.data.__qc == null){
					o.data.__qc = o.attribute('o-class');
					_react_commit_up(o);
				}
				o.data.__qc = o.data.__qc.split('{{' + path + '}}').join(data);
			}
			
		}
	}
	
	/**
	 * pipaattr="attrA:{{a}},attrB:{{b}},attrC:{{c}},..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_attr(data:Dynamic, path:String, o:Displayable){
		if (o.hasAttribute('o-attr')){
			if(path != null){
				if (o.data.__qa == null){
					o.data.__qa = o.attribute('o-attr');
					_react_commit_up(o);
				}
				o.data.__qa = o.data.__qa.split('{{' + path + '}}').join(data);
			}
		}
	}
	
	/**
	 * pipastyle="paramA:{{a}},paramB:{{b}},paramC:{{c}},..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_style(data:Dynamic, path:String, o:Displayable){
		if (o.hasAttribute('o-style')){
			if(path != null){
				if (o.data.__qs == null){
					o.data.__qs = o.attribute('o-style');
					_react_commit_up(o);
				}
				o.data.__qs = o.data.__qs.split('{{' + path + '}}').join(data);
			}
		}
	}
	
	static private function _react_fill(to:Displayable, data:Dynamic, path:String){
		if (Std.isOfType(data, String) || Std.isOfType(data, Float) || Std.isOfType(data, Bool)){
			// Simple write content
			to.all('[o-data*="{{' + path + '}}"]').add(to).each(function(o:Displayable){
				_react_fill_data(data, path, o);
			});
			// Write object attributes
			to.all('[o-attr*="{{' + path + '}}"]').add(to).each(function(o:Displayable){
				_react_fill_attr(data, path, o);
			});
			// Write object styles
			to.all('[o-style*="{{' + path + '}}"]').add(to).each(function(o:Displayable){
				_react_fill_style(data, path, o);
			});
			// Write object classes
			to.all('[o-class*="{{' + path + '}}"]').add(to).each(function(o:Displayable){
				_react_fill_class(data, path, o);
			});
			data = data != "" && data != false && data != 0 && data != "0" ? 1 : 0;
			to.all('[o-show-if*="{{' + path + '}}"]').add(to).each(function(o:Displayable){
				_react_fill_visibility(data, path, o, 'o-show-if');
			});
			to.all('[o-hide-if*="{{' + path + '}}"]').add(to).each(function(o:Displayable){
				_react_fill_visibility(data, path, o, 'o-hide-if');
			});
		}else {
			path = path == '' ? '' : path + '.';
			Dice.All(data, function(p:String, v:Dynamic):Void {
				p = '' + p;
				if (p.substr(0, 1) != '_'){
					_react_fill(to, v, path + p);
				}
			});
		}
	}
	
	/**
	 * o-single, remove attribute on apply, usage: o-[cmd]="{{a}} {{b}} ..."
	 * o-data*={{prop}}
	 * o-attr*={{prop}}
	 * o-style*={{prop}}
	 * o-class*={{prop}}
	 * o-show-if*={{prop}}
	 * o-show-if-score
	 * o-hide-if*={{prop}}
	 * o-hide-if-score
	 * 
	 * @param	to
	 * @param	data
	 */
	static public function apply(to:Displayable, data:Dynamic):Void{
		_react_fill(to, data, '');
		_react_fill_after(to);
		_dispatch(to);
	}
	
	static public function listen(handler:Displayable->Void):Void {
		if(!_listeners.contains(handler)){
			_listeners.push(handler);
		}
	}
	
	static public function unlisten(handler:Displayable->Void):Void {
		_listeners.remove(handler);
	}
	
}
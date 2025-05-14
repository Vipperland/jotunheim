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
			o.data.__co = 0;
			o.attribute('o-commit', 'true');
		}
		++o.data.__co;
	}
	
	static private function _react_commit_down(o:Displayable){
		--o.data.__co;
		if (o.data.__co == 0){
			Reflect.deleteField(o.data, '__co');
			o.clearAttribute('o-commit');
		}
	}
	
	static private function _react_fill_after(to:Displayable):Void {
		to.all('[o-commit]').add(to).each(function(o:Displayable){
			o.data.__cf = true;
			_react_fill_data(to.data, null, o);
			_react_fill_attr(to.data, null, o);
			_react_fill_style(to.data, null, o);
			_react_fill_class(to.data, null, o);
			_react_fill_visibility(to.data, null, o, 'o-show-if');
			_react_fill_visibility(to.data, null, o, 'o-hide-if');
			o.data.__cf = false;
		});
	}
	
	/**
	 * o-data="{{a}} {{b}} {{c}} ..."
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
			if(o.data.__qd != null){
				if (o.data.__cf || o.data.__qd.indexOf('{{') == -1){
					o.data.__qd = Std.isOfType(o.data.__qd, String) ? Utils.rnToBr(o.data.__qd) : o.data.__qd;
					if (Std.isOfType(o, Input)){
						o.value(o.data.__qd);
					}else{
						o.writeHtml(o.data.__qd);
					}
					Reflect.deleteField(o.data, '__qd');
					_react_commit_down(o);
					_react_clear(o, 'o-single', 'o-data');
				}
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
	static private function _react_fill_visibility(data:Dynamic, path:String, o:Displayable, attr:String){
		if (o.hasAttribute(attr)){
			if(path != null){
				if (o.data.__qv == null){
					o.data.__qv = o.attribute(attr);
					o.data.__qvt = o.hasAttribute(attr + '-score') ? o.attribute(attr + '-score') : o.data.__qv.split(',').length;
					o.data.__qvs = 0;
					_react_commit_up(o);
				}
				o.data.__qv = o.data.__qv.split('{{' + path + '}}').join(data);
				if (data){
					o.data.__qvs += 1;
				}
			}
			if(o.data.__qv != null){
				if (o.data.__cf || o.data.__qv.indexOf('{{') == -1){
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
					_react_commit_down(o);
					_react_clear(o, 'o-single', attr);
				}
			}
		}
	}
	
	/**
	 * o-class="{{a}} {{b}} {{c}} ..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_class(data:Dynamic, path:String, o:Displayable){
		if (o.hasAttribute('o-class')){
			if(path != null){
				if (o.data.__qc == null){
					if(!o.data.__qcs){
						o.data.__qcs = true;
						if(o.hasAttribute('class')){
							var cf:String = o.attribute('class');
							if (cf.length > 0){
								o.attribute('o-class', o.attribute('class') + ' ' + o.attribute('o-class'));
							}
						}
					}
					o.data.__qc = o.attribute('o-class');
					_react_commit_up(o);
				}
				o.data.__qc = o.data.__qc.split('{{' + path + '}}').join(data);
			}
			if(o.data.__qc){
				if (o.data.__cf || o.data.__qc.indexOf('{{') == -1){
					o.attribute('class', o.data.__qc);
					Reflect.deleteField(o.data, '__qc');
					_react_commit_down(o);
					_react_clear(o, 'o-single', 'o-class');
				}
			}
		}
	}
	
	/**
	 * o-attr="attrA:{{a}},attrB:{{b}},attrC:{{c}},..."
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
			if(o.data.__qa){
				if (o.data.__cf || o.data.__qa.indexOf('{{') == -1){
					Dice.Values(o.data.__qa.split(';'), function(v:Dynamic){
						v = v.split(":");
						if (v.length > 1){
							o.attribute(v.shift(), v.join(":"));
						}
					});
					Reflect.deleteField(o.data, '__qa');
					_react_commit_down(o);
					_react_clear(o, 'o-single', 'o-attr');
				}
			}
		}
	}
	
	/**
	 * o-style="paramA:{{a}},paramB:{{b}},paramC:{{c}},..."
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
			if(o.data.__qs != null){
				if(o.data.__cf || o.data.__qs.indexOf('{{') == -1){
					Dice.Values(o.data.__qs.split(';'), function(v:Dynamic){
						v = v.split(":");
						if (v.length > 1){
							o.style(v.shift(), v.join(":"));
						}
					});
					Reflect.deleteField(o.data, '__qs');
					_react_commit_down(o);
					_react_clear(o, 'o-single', 'o-style');
				}
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
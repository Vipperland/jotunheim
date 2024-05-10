package jotun.utils;
import jotun.dom.IDisplay;
import jotun.dom.Input;
import jotun.tools.Utils;
import js.Syntax;
import js.html.Element;

/**
 * ...
 * @author 
 */
class Reactor {
	
	static private var _listeners:Array<IDisplay->Void> = [];
	
	static private function _dispatch(o:IDisplay):Void {
		for(i in 0..._listeners.length){
			_listeners[i](o);
		}
	}
	
	static private function _react_clear(o:IDisplay, attr:String, prop:String){
		if (o.hasAttribute(attr)){
			o.clearAttribute(prop);
		}
	}
	
	static private function _react_commit_up(o:IDisplay){
		if (o.data.__co == null){
			o.data.__co = 0;
			o.attribute('jtn-commit', 'true');
		}
		++o.data.__co;
	}
	
	static private function _react_commit_down(o:IDisplay){
		--o.data.__co;
		if (o.data.__co == 0){
			Reflect.deleteField(o.data, '__co');
			o.clearAttribute('jtn-commit');
		}
	}
	
	static private function _react_fill_after(to:IDisplay):Void {
		to.all('[jtn-commit]').add(to).each(function(o:IDisplay){
			o.data.__cf = true;
			_react_fill_data(to.data, null, o);
			_react_fill_attr(to.data, null, o);
			_react_fill_style(to.data, null, o);
			_react_fill_class(to.data, null, o);
			_react_fill_visibility(to.data, null, o, 'jtn-show-if');
			_react_fill_visibility(to.data, null, o, 'jtn-hide-if');
			o.data.__cf = false;
		});
	}
	
	/**
	 * jtn-data="{{a}} {{b}} {{c}} ..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_data(data:Dynamic, path:String, o:IDisplay){
		if (o.hasAttribute('jtn-data')){
			if(path != null){
				if (o.data.__qd == null){
					o.data.__qd = o.attribute('jtn-data');
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
					_react_clear(o, 'jtn-single', 'jtn-data');
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
	static private function _react_fill_visibility(data:Dynamic, path:String, o:IDisplay, attr:String){
		if (o.hasAttribute(attr)){
			if(path != null){
				if (o.data.__qv == null){
					o.data.__qv = o.attribute(attr);
					o.data.__qvt = o.hasAttribute(attr + '-score') ? o.hasAttribute(attr + '-score') : o.data.__qv.split(',').length;
					o.data.__qvs = 0;
					_react_commit_up(o);
				}
				o.data.__qv = o.data.__qv.split('{{' + path + '}}').join(data);
				o.data.__qvs += 1;
			}
			if(o.data.__qv != null){
				if (o.data.__cf || o.data.__qv.indexOf('{{') == -1){
					if (o.data.__qvs >= o.data.__qvt){
						if (attr == 'jtn-show-if'){
							o.show();
						}else{
							o.hide();
						}
					}else{
						if (attr == 'jtn-show-if'){
							o.hide();
						}else{
							o.show();
						}
					}
					Reflect.deleteField(o.data, '__qv');
					Reflect.deleteField(o.data, '__qvt');
					Reflect.deleteField(o.data, '__qvs');
					_react_commit_down(o);
					_react_clear(o, 'jtn-single', attr);
				}
			}
		}
	}
	
	/**
	 * jtn-class="{{a}} {{b}} {{c}} ..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_class(data:Dynamic, path:String, o:IDisplay){
		if (o.hasAttribute('jtn-class')){
			if(path != null){
				if (o.data.__qc == null){
					if(!o.data.__qcs){
						o.data.__qcs = true;
						if(o.hasAttribute('class')){
							var cf:String = o.attribute('class');
							if (cf.length > 0){
								o.attribute('jtn-class', o.attribute('class') + ' ' + o.attribute('jtn-class'));
							}
						}
					}
					o.data.__qc = o.attribute('jtn-class');
					_react_commit_up(o);
				}
				o.data.__qc = o.data.__qc.split('{{' + path + '}}').join(data);
			}
			if(o.data.__qc){
				if (o.data.__cf || o.data.__qc.indexOf('{{') == -1){
					o.attribute('class', o.data.__qc);
					Reflect.deleteField(o.data, '__qc');
					_react_commit_down(o);
					_react_clear(o, 'jtn-single', 'jtn-class');
				}
			}
		}
	}
	
	/**
	 * jtn-attr="attrA:{{a}},attrB:{{b}},attrC:{{c}},..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_attr(data:Dynamic, path:String, o:IDisplay){
		if (o.hasAttribute('jtn-attr')){
			if(path != null){
				if (o.data.__qa == null){
					o.data.__qa = o.attribute('jtn-attr');
					_react_commit_up(o);
				}
				o.data.__qa = o.data.__qa.split('{{' + path + '}}').join(data);
			}
			if(o.data.__qa){
				if (o.data.__cf || o.data.__qa.indexOf('{{') == -1){
					Dice.Values(o.data.__qa.split(';'), function(v:Dynamic){
						v = v.split(":");
						o.attribute(v.shift(), v.join(":"));
					});
					Reflect.deleteField(o.data, '__qa');
					_react_commit_down(o);
					_react_clear(o, 'jtn-single', 'jtn-attr');
				}
			}
		}
	}
	
	/**
	 * jtn-style="paramA:{{a}},paramB:{{b}},paramC:{{c}},..."
	 * @param	data
	 * @param	path
	 * @param	o
	 */
	static private function _react_fill_style(data:Dynamic, path:String, o:IDisplay){
		if (o.hasAttribute('jtn-style')){
			if(path != null){
				if (o.data.__qs == null){
					o.data.__qs = o.attribute('jtn-style');
					_react_commit_up(o);
				}
				o.data.__qs = o.data.__qs.split('{{' + path + '}}').join(data);
			}
			if(o.data.__qs != null){
				if(o.data.__cf || o.data.__qs.indexOf('{{') == -1){
					Dice.Values(o.data.__qs.split(';'), function(v:Dynamic){
						v = v.split(":");
						o.style(v.shift(), v.join(":"));
					});
					Reflect.deleteField(o.data, '__qs');
					_react_commit_down(o);
					_react_clear(o, 'jtn-single', 'jtn-style');
				}
			}
		}
	}
	
	static private function _react_fill(to:IDisplay, data:Dynamic, path:String){
		if (Std.isOfType(data, String) || Std.isOfType(data, Float) || Std.isOfType(data, Bool)){
			// Simple write content
			to.all('[jtn-data*="{{' + path + '}}"]').add(to).each(function(o:IDisplay){
				_react_fill_data(data, path, o);
			});
			// Write object attributes
			to.all('[jtn-attr*="{{' + path + '}}"]').add(to).each(function(o:IDisplay){
				_react_fill_attr(data, path, o);
			});
			// Write object styles
			to.all('[jtn-style*="{{' + path + '}}"]').add(to).each(function(o:IDisplay){
				_react_fill_style(data, path, o);
			});
			// Write object classes
			to.all('[jtn-class*="{{' + path + '}}"]').add(to).each(function(o:IDisplay){
				_react_fill_class(data, path, o);
			});
			to.all('[jtn-show-if*="{{' + path + '}}"]').add(to).each(function(o:IDisplay){
				_react_fill_visibility(data, path, o, 'jtn-show-if');
			});
			to.all('[jtn-hide-if*="{{' + path + '}}"]').add(to).each(function(o:IDisplay){
				_react_fill_visibility(data, path, o, 'jtn-hide-if');
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
	 * jtn-single, remove attribute on apply, usage: jtn-[cmd]="{{a}} {{b}} ..."
	 * jtn-data*={{prop}}
	 * jtn-attr*={{prop}}
	 * jtn-style*={{prop}}
	 * jtn-class*={{prop}}
	 * jtn-show-if*={{prop}}
	 * jtn-show-if-score
	 * jtn-hide-if*={{prop}}
	 * jtn-hide-if-score
	 * 
	 * @param	to
	 * @param	data
	 */
	static public function apply(to:IDisplay, data:Dynamic):Void{
		_react_fill(to, data, '');
		_react_fill_after(to);
		_dispatch(to);
	}
	
	static public function listen(handler:IDisplay->Void):Void {
		if(!_listeners.contains(handler)){
			_listeners.push(handler);
		}
	}
	
	static public function unlisten(handler:IDisplay->Void):Void {
		_listeners.remove(handler);
	}
	
}
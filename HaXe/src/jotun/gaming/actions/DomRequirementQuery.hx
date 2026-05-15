package jotun.gaming.actions;
import jotun.Jotun;

/**
 * DOM state-checking sub-module for RequirementQuery.
 * Add as a named field on a project's CustomRequirementQuery:
 *
 *   public var dom:DomRequirementQuery = new DomRequirementQuery();
 *
 * Then in behavior JSON:
 *   {"*": ["dom.one .card", "dom.exists", "dom.hasclass active", "dom.count .items > 3"]}
 *
 * Methods with no selector argument operate on the element set by dom.one.
 * Methods with a selector argument resolve it directly.
 *
 * @author Rafael Moreira
 */
class DomRequirementQuery extends RequirementQuery {

	public var current:Dynamic;

	private function _el(query:Array<String>):Dynamic {
		return query.length == 0 ? current : Jotun.one(query.join(' '));
	}

	public function one(...query:String):Bool {
		current = Jotun.one(query.toArray().join(' '));
		return current != null;
	}

	public function exists(...query:String):Bool {
		return _el(query.toArray()) != null;
	}

	public function visible(...query:String):Bool {
		var el:Dynamic = _el(query.toArray());
		return el != null && el.isVisible();
	}

	public function fullvisible(...query:String):Bool {
		var el:Dynamic = _el(query.toArray());
		return el != null && el.isFullyVisible();
	}

	public function hidden(...query:String):Bool {
		var el:Dynamic = _el(query.toArray());
		return el == null || !el.isVisible();
	}

	// one arg: operate on current  →  dom.hasclass active
	// two+ args: first is selector →  dom.hasclass .card active
	public function hasclass(...args:String):Bool {
		var a:Array<String> = args.toArray();
		if (a.length == 0) return false;
		var el:Dynamic = a.length == 1 ? current : Jotun.one(a.shift());
		return el != null && el.hasCss(a[0]);
	}

	public function hasattr(...args:String):Bool {
		var a:Array<String> = args.toArray();
		if (a.length == 0) return false;
		var el:Dynamic = a.length == 1 ? current : Jotun.one(a.shift());
		return el != null && el.hasAttribute(a[0]);
	}

	public function hastag(...args:String):Bool {
		var a:Array<String> = args.toArray();
		if (a.length == 0) return false;
		var el:Dynamic = a.length == 1 ? current : Jotun.one(a.shift());
		return el != null && el.is(a[0]);
	}

	public function count(query:String, rule:String, value:Int):Bool {
		return _resolve(Jotun.all(query).length(), rule, _INT(value, 0));
	}

	public function isenabled(...query:String):Bool {
		var el:Dynamic = _el(query.toArray());
		return el != null && el.isEnabled();
	}

	override public function flush():Void {
		current = null;
		super.flush();
	}

}

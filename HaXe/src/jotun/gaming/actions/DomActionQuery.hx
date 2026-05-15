package jotun.gaming.actions;
import jotun.Jotun;
import jotun.utils.Filler;

/**
 * DOM manipulation sub-module for ActionQuery.
 * Add as a named field on a project's CustomActionQuery:
 *
 *   public var dom:DomActionQuery = new DomActionQuery();
 *
 * Then in behavior JSON:
 *   {"@": ["dom.one .card", "dom.css active", "dom.all .score", "dom.hide"]}
 *
 * @author Rafael Moreira
 */
class DomActionQuery extends ActionQuery {

	public var current:Dynamic;

	public function one(...query:String):DomActionQuery {
		current = Jotun.one(_JOIN(query.toArray()));
		return this;
	}

	public function all(...query:String):DomActionQuery {
		current = Jotun.all(_JOIN(query.toArray()));
		return this;
	}

	public function css(...classes:String):DomActionQuery {
		if (current != null) current.css(_JOIN(classes.toArray()));
		return this;
	}

	public function show():DomActionQuery {
		if (current != null) current.show();
		return this;
	}

	public function hide():DomActionQuery {
		if (current != null) current.hide();
		return this;
	}

	public function mount(module:String, ?params:String):DomActionQuery {
		if (current != null) current.mount(module, params != null ? _PARAMS(params) : invocation.origin);
		return this;
	}

	public function writeText(...values:String):DomActionQuery {
		if (current != null) current.writeText(Filler.to(_JOIN(values.toArray()), invocation.origin));
		return this;
	}

	public function writeHtml(...values:String):DomActionQuery {
		if (current != null) current.writeHtml(Filler.to(_JOIN(values.toArray()), invocation.origin));
		return this;
	}

	public function appendText(...values:String):DomActionQuery {
		if (current != null) current.appendText(Filler.to(_JOIN(values.toArray()), invocation.origin));
		return this;
	}

	public function appendHtml(...values:String):DomActionQuery {
		if (current != null) current.appendHtml(Filler.to(_JOIN(values.toArray()), invocation.origin));
		return this;
	}

	public function react(...values:String):DomActionQuery {
		if (current != null) {
			current.react(values.length == 0 ? invocation.origin : haxe.Json.parse(values.toArray().join(' ')));
		}
		return this;
	}

	public function attribute(...values:String):DomActionQuery {
		if (current != null && values.length > 0) current.attribute(haxe.Json.parse(values.toArray().join(' ')));
		return this;
	}

	public function style(...values:String):DomActionQuery {
		if (current != null && values.length > 0) current.style(haxe.Json.parse(values.toArray().join(' ')));
		return this;
	}

	public function readattr(attr:String, name:String):DomActionQuery {
		if (current != null) {
			var v:Dynamic = current.attribute(attr);
			if (v != null) getDataProvider().setVar(name, v);
		}
		return this;
	}

	public function readvalue(name:String):DomActionQuery {
		if (current != null) {
			var v:Dynamic = current.value();
			if (v != null) getDataProvider().setVar(name, v);
		}
		return this;
	}

	public function readcount(query:String, name:String):DomActionQuery {
		getDataProvider().setVar(name, Jotun.all(query).length());
		return this;
	}

	public function remove():DomActionQuery {
		if (current != null) current.remove();
		return this;
	}

	override public function flush():Void {
		current = null;
		super.flush();
	}

}

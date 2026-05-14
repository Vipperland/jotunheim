package jotun.gaming.actions;

/**
 * Built-in ActionQuery bundle. Register once at startup to enable
 * DOM behavior commands natively across all behavior JSON.
 *
 *   CommonsActionQuery.register();
 *
 * Then in behavior JSON:
 *   {"@": ["dom.one .card", "dom.css active", "dom.react"]}
 *
 * @author Rafael Moreira
 */
class CommonsActionQuery extends ActionQuery {

	public static function register():Void {
		Action.codex.add(new CommonsActionQuery());
	}

	public var dom:DomActionQuery = new DomActionQuery();

}

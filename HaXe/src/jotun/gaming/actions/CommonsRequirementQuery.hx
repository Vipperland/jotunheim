package jotun.gaming.actions;

/**
 * Built-in RequirementQuery bundle. Register once at startup to enable
 * DOM state checks natively across all behavior JSON.
 *
 *   CommonsRequirementQuery.register();
 *
 * Then in behavior JSON:
 *   {"*": ["dom.exists .card", "dom.hasclass .card active", "dom.count .items > 3"]}
 *
 * @author Rafael Moreira
 */
class CommonsRequirementQuery extends RequirementQuery {

	public static function register():Void {
		Requirement.codex.add(new CommonsRequirementQuery());
	}

	public var dom:DomRequirementQuery = new DomRequirementQuery();

}

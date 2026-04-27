package jotun.gaming.actions;

/**
 * Fluent API builder for constructing Action objects.
 *
 * Usage:
 *   var action = ActionBuilder.create()
 *     .withId("attack_action")
 *     .withTarget(1)
 *     .build();
 */
class ActionBuilder {
	private var id:String;
	private var requirements:Array<Dynamic>;
	private var target:Int;
	private var reverse:Bool;
	private var breakOn:Dynamic;
	private var thenChain:Array<Dynamic>;
	private var failChain:Array<Dynamic>;

	public static function create():ActionBuilder {
		return new ActionBuilder();
	}

	private function new() {
		id = null;
		requirements = [];
		target = -1;
		reverse = false;
		breakOn = null;
		thenChain = [];
		failChain = [];
	}

	public function withId(id:String):ActionBuilder {
		if (id == null) throw "Action ID cannot be null";
		this.id = id;
		return this;
	}

	public function withRequirements(requirements:Array<Dynamic>):ActionBuilder {
		this.requirements = requirements != null ? requirements : [];
		return this;
	}

	public function withTarget(target:Int):ActionBuilder {
		this.target = target;
		return this;
	}

	public function withReverse(reverse:Bool):ActionBuilder {
		this.reverse = reverse;
		return this;
	}

	public function withBreakOn(breakOn:Dynamic):ActionBuilder {
		this.breakOn = breakOn;
		return this;
	}

	public function withThenChain(actions:Array<Dynamic>):ActionBuilder {
		thenChain = actions != null ? actions : [];
		return this;
	}

	public function withFailChain(actions:Array<Dynamic>):ActionBuilder {
		failChain = actions != null ? actions : [];
		return this;
	}

	public function validate():Bool {
		if (id == null || id.length == 0)
			throw "ActionBuilder: ID is required and cannot be empty";
		if (target < 0)
			throw "ActionBuilder: Target must be >= 0 (current: " + target + ")";
		return true;
	}

	public function build():Dynamic {
		validate();
		var action:Dynamic = {};
		action.id = id;
		action.requirements = requirements;
		action.target = target;
		action.reverse = reverse;
		action.breakOn = breakOn;
		action.thenChain = thenChain;
		action.failChain = failChain;
		return action;
	}

	public function toString():String {
		return "ActionBuilder{id:'" + (id != null ? id : "null") + "',target:" + target + ",reverse:" + reverse + ",requirements:[" + requirements.length + "],thenChain:[" + thenChain.length + "],failChain:[" + failChain.length + "],breakOn:" + (breakOn != null ? "set" : "null") + "}";
	}
}

/**
 * Fluent API builder for constructing Requirement objects.
 *
 * Usage:
 *   var requirement = RequirementBuilder.create()
 *     .withId("health_check")
 *     .withTarget(1)
 *     .withQueries(["has_health"])
 *     .build();
 */
class RequirementBuilder {
	private var id:String;
	private var queries:Array<String>;
	private var target:Int;
	private var breakOn:Dynamic;
	private var thenChain:Array<Dynamic>;
	private var failChain:Array<Dynamic>;

	public static function create():RequirementBuilder {
		return new RequirementBuilder();
	}

	private function new() {
		id = null;
		queries = [];
		target = -1;
		breakOn = null;
		thenChain = [];
		failChain = [];
	}

	public function withId(id:String):RequirementBuilder {
		if (id == null) throw "Requirement ID cannot be null";
		this.id = id;
		return this;
	}

	public function withQueries(queries:Array<String>):RequirementBuilder {
		this.queries = queries != null ? queries : [];
		return this;
	}

	public function withTarget(target:Int):RequirementBuilder {
		this.target = target;
		return this;
	}

	public function withBreakOn(breakOn:Dynamic):RequirementBuilder {
		this.breakOn = breakOn;
		return this;
	}

	public function withThenChain(actions:Array<Dynamic>):RequirementBuilder {
		thenChain = actions != null ? actions : [];
		return this;
	}

	public function withFailChain(actions:Array<Dynamic>):RequirementBuilder {
		failChain = actions != null ? actions : [];
		return this;
	}

	public function validate():Bool {
		if (id == null || id.length == 0)
			throw "RequirementBuilder: ID is required and cannot be empty";
		if (queries.length == 0)
			throw "RequirementBuilder: At least one query is required";
		if (target < 0)
			throw "RequirementBuilder: Target must be >= 0 (current: " + target + ")";
		return true;
	}

	public function build():Dynamic {
		validate();
		var requirement:Dynamic = {};
		requirement.id = id;
		requirement.queries = queries;
		requirement.target = target;
		requirement.breakOn = breakOn;
		requirement.thenChain = thenChain;
		requirement.failChain = failChain;
		return requirement;
	}

	public function toString():String {
		return "RequirementBuilder{id:'" + (id != null ? id : "null") + "',target:" + target + ",queries:[" + queries.length + "],thenChain:[" + thenChain.length + "],failChain:[" + failChain.length + "],breakOn:" + (breakOn != null ? "set" : "null") + "}";
	}
}

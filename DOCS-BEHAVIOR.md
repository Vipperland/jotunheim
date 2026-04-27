# Jotun Behavior System

## Architecture

The behavior system is a data-driven, composable rule engine for game logic (and beyond). Execution flows through a stack of objects:

```
SpellCodex  ──invoke(name)──►  SpellGroup  (ordered list of Actions)
                                    │
                               Action  ──verify──►  [Requirement, ...]
                                    │                      │
                               ActionQuery          RequirementQuery
                               (mutations)          (comparisons)
                                    │
                               SpellCasting  (shared context object)
                                    │
                               IDataProvider  (variable storage)
```

**Key principle**: everything is driven by plain data objects (Dynamic/JSON). You define your spells as data; the engine compiles and executes them.

---

## SpellCodex — Entry Point

`SpellCodex` owns a named dictionary of `SpellGroup`s. Call `invoke` to run a named spell.

```haxe
// Define spell data as a plain object or parsed JSON
var spellData:Dynamic = {
    "on_attack": [
        {
            "require": ["req_has_stamina"],
            "target": 1,
            "@": ["setint stamina - 10", "setint health = 100"],
        }
    ],
    "req_has_stamina": [  // this key is a named requirement (handled by SpellCodex)
        {
            "id": "req_has_stamina",
            "*": ["isvar stamina > 0"],
        }
    ],
};

var codex:SpellCodex = new SpellCodex(spellData);

// Trigger the "on_attack" spell with some context data and a data provider
var provider:IDataProvider = new BasicDataProvider({ stamina: 50, health: 100 });
codex.invoke('on_attack', { origin: 'player' }, provider);

// Enable debug logging
codex.setDebug(true);
```

### Custom Cache

You can redirect where actions and requirements are stored (e.g. into a database or singleton):

```haxe
SpellCodex.cacheController(
    function(a:Action) { myStore.set(a.id, a); },
    function(id:String):Action { return myStore.get(id); },
    function(r:Requirement) { myStore.set(r.id, r); },
    function(id:String):Requirement { return myStore.get(id); }
);
```

---

## Data Format

Every spell is a **named array of action objects**. The key is the event name; the value is the action list.

```json
{
  "event_name": [
    {
      "id":      "optional_unique_id",
      "require": ["req_id_1", { inline requirement }],
      "target":  1,
      "reverse": false,
      "breakon": null,
      "@":       ["setint hp - 10", "setswitch alive true"],
      "then":    [{ ...action }],
      "fail":    [{ ...action }]
    }
  ]
}
```

| Field | Description |
|-------|-------------|
| `id` | Optional. Names the action so it can be referenced by string elsewhere. |
| `require` | Array of requirement IDs (strings) or inline requirement objects. |
| `target` | Minimum number of requirements that must pass. Defaults to `require.length` (all). `0` always succeeds regardless of requirements. Negative = pass if score ≤ target. |
| `reverse` | Invert the action's success/failure result before `then`/`fail` chain. |
| `breakon` | When to stop iterating the parent SpellGroup after this action (see below). |
| `@` | Queries executed by `ActionQuery` on success. |
| `then` | Actions executed on success. |
| `fail` | Actions executed on failure. |

**Requirement object** (`"*"` instead of `"@"`):

```json
{
  "id":      "req_has_stamina",
  "target":  1,
  "reverse": false,
  "breakon": "never",
  "*":       ["isvar stamina > 0", "isswitch alive true"]
}
```

---

## Resolution — Break Conditions

Both `Action` and `Requirement` extend `Resolution`, which controls iteration flow.

| `breakon` value | Effect |
|-----------------|--------|
| `null` *(default for Action)* | Break on success, continue on failure |
| `true` | Break on success only |
| `false` | Break on failure only |
| `"always"` | Always break (stop iteration regardless of result) |
| `"never"` *(default for Requirement)* | Never break (always continue) |

The score accumulates `+1` per passing requirement and `-1` per failing one. `target` is the minimum score to be considered a success.

---

## SpellGroup — Ordered Action List

A `SpellGroup` is the compiled form of one named entry in the codex. You can also build and mutate groups at runtime.

```haxe
var group:SpellGroup = codex.index.get('on_attack');

// Append an action at the end (or at a specific index)
group.learn(myAction);
group.learn(myAction, 2);

// Insert relative to an existing action
group.learnAfter(myAction, 'existing_action_id');
group.learnBefore(myAction, 'existing_action_id');

// Async execution (JS only)
group.wait(5.0);   // pause for up to 5 seconds
group.release();   // resume immediately
```

---

## Action — Execution Unit

```haxe
// Build from a plain object (preferred — data-driven)
var data:Dynamic = {
    id: "deal_damage",
    require: ["req_is_alive"],
    target: 1,
    "@": ["setint hp - 10"],
};
var action:Action = new Action("context_label", data);

// Or use the fluent builder
var data:Dynamic = ActionBuilder.create()
    .withId("deal_damage")
    .withRequirements(["req_is_alive"])
    .withTarget(1)
    .withReverse(false)
    .build();

// Reference by id
var loaded:Action = SpellCodex.loadAction("deal_damage");
Action.clear(); // reset cache
```

**Scoring example** — `target: 2` means at least 2 requirements must pass:

```json
{
  "require": ["req_alive", "req_has_mana", "req_in_range"],
  "target":  2
}
```

---

## Requirement — Condition Unit

```haxe
var data:Dynamic = {
    id: "req_has_stamina",
    "*": ["isvar stamina > 0"],
    target: 1,
};
var req:Requirement = new Requirement("context_label", data);

// Or use the builder
var data:Dynamic = RequirementBuilder.create()
    .withId("req_has_stamina")
    .withTarget(1)
    .withQueries(["isvar stamina > 0"])
    .build();

var loaded:Requirement = SpellCodex.loadRequirement("req_has_stamina");
```

---

## ActionQuery — Mutation DSL

`ActionQuery` executes when an `Action` succeeds. Queries are strings parsed and dispatched by method name. They mutate the `IDataProvider`.

### Arithmetic / Assignment

```
setvar  name  rule  value    — auto-detect type (int, string, bool)
setint  name  rule  value    — integer
setfloat name  rule  value   — float
setstr  name  rule  value    — string
```

| `rule` | Meaning |
|--------|---------|
| `=` or `eq` | assign |
| `+` or `add` | add |
| `-` or `sub` | subtract |
| `++` or `increment` | +1 |
| `--` or `decrement` | -1 |
| `*` or `multiply` | multiply |
| `/` or `divided` | divide |
| `%` or `mod` | modulo |
| `<<` or `lshift` | bitshift left |
| `>>` or `rshift` | bitshift right |
| `~` or `not` | bit-clear (a & ~v) |
| `\|` or `or` | bitwise OR |
| `&` or `and` | bitwise AND |
| `!` or `xor` | bitwise XOR |
| `^` or `pow` | power |
| `#` or `random` | `(rng() * v) + a` |

```
setswitch  name  value         — set Bool (true/false/1/0/yes/no)
toggleswitch  name             — flip Bool
setrng  name  rule  min  max   — random value in [min, max]
define  name  a  rule  b       — name = (a rule b), where a and b are variable names
call  id                       — invoke another named Action
```

**Examples:**

```
setint hp - 10              → hp -= 10
setfloat speed * 0.5        → speed *= 0.5
setstr name = hero          → name = "hero"
setswitch alive false       → alive = false
toggleswitch stunned        → stunned = !stunned
setrng roll = 1 6           → roll = random int in [1, 6]
setrng crit = 0 1 true      → crit = random float in [0, 1]
define damage hp - armor    → damage = hp - armor
call on_damage_effect
```

### HTTP (JS only)

```
preparerequest  /api/turn  POST  {}    — async HTTP request; pauses execution
resetcontext                           — switch back to main data provider
setrequestcontext                      — switch to request response as provider
```

```haxe
// Inside an ActionQuery subclass or via codex:
// The query string "preparerequest /api/data GET" triggers an HTTP call,
// pauses the spell for up to 30 seconds, then resumes with response data.
```

### Debug

```
tracer  Some {{variable}} message    — trace with Filler interpolation
```

---

## RequirementQuery — Verification DSL

`RequirementQuery` returns `Bool` per query; scores are aggregated against `target`.

### Numeric Comparisons

```
isvar  name  rule  value
```

| `rule` | Meaning |
|--------|---------|
| `=` or `equal` | == |
| `!=` or `diff` | != |
| `<` or `less` | < |
| `<=` or `less-or` | <= |
| `>` or `great` | > |
| `>=` or `great-or` | >= |
| `&` or `test` | bit test: `(a & v) == v` |
| `!&` or `not` | bit clear test: `(~a & v) == v` |
| `*=` or `contain` | `a.indexOf(v) != -1` |
| `~=` or `inside` | `v.indexOf(a) != -1` |
| `#=` or `rand` | `int(rng()*a) == v` |
| `#!` or `rand-diff` | `int(rng()*a) != v` |
| `#>` or `rand-great-or` | `rng()*a >= v` |
| `#<` or `rand-less-or` | `rng()*a <= v` |

### String Comparisons

```
isstr  name  rule  value    — rules: =, !=, *=, ~=
```

### Boolean

```
isswitch  name  value       — value is optional; omit for "must be true"
```

### Variable vs Variable

```
compare  name1  rule  name2    — resolves both from provider, then applies rule
```

### Parity / Chance

```
isodd   name         — true if value is odd
iseven  name         — true if value is even
coinflip             — 50% chance (no arguments)
isrng   name  rule  min  max   — isvar against a random value
```

### Context Checks

```
iseventtype    type1  type2 ...   — true if context event matches any type
isactionid     id1  id2 ...       — true if current action's id matches any
isactionchain  hits  id1  id2 ... — true if last N actions matched ids in order
isafteranyaction  id1  id2 ...    — true if any id appeared in history
isdebug                           — true if debug mode is on
```

**Examples:**

```
isvar hp > 0
isvar stamina >= 10
isvar flags & 4             → flag bit 4 is set
isstr status = alive
isstr name *= hero          → name contains "hero"
isswitch can_act
isswitch dead false
compare attack >= defense
coinflip
isrng luck >= 0 100         → random 0-100 must be >= luck
iseventtype click keydown
isactionid deal_damage
isactionchain 2 move attack → "move" then "attack" in recent history
isafteranyaction stun blind → either stun or blind appeared in history
```

---

## SpellCasting — Context Object

A `SpellCasting` is created per `invoke()` call and passed through the entire execution chain. You rarely need to instantiate it directly; it's accessible inside `ActionQuery` and `RequirementQuery` via `this.invocation`.

```haxe
invocation.name            // spell name that triggered this context
invocation.origin          // raw data passed to invoke()
invocation.debug           // Bool
invocation.log             // Array<String> of debug messages
invocation.history         // Array<Action> of all Actions that succeeded
invocation.dataProvider    // main IDataProvider
invocation.currentProvider // active provider (may be requestProvider)
invocation.requestProvider // populated by preparerequest

invocation.action.target   // last successful Action
invocation.action.count    // number of successful actions so far
invocation.requirement.target // last verified Requirement
invocation.parent          // parent SpellCasting (nested invocations)
invocation.chain           // nesting depth
```

---

## IDataProvider / BasicDataProvider — Variable Storage

All variable reads and writes go through `IDataProvider`. The built-in implementation is `BasicDataProvider`.

```haxe
// Create with initial data
var provider:IDataProvider = new BasicDataProvider({
    hp:      100,
    stamina: 50,
    name:    "Hero",
    alive:   true,
});

// Typed reads
provider.getVar('hp');        // Dynamic
provider.getInt('hp');        // Int
provider.getFloat('stamina'); // Float
provider.getStr('name');      // String
provider.getSwitch('alive');  // Bool

// Typed writes
provider.setVar('hp', 80);
provider.setInt('hp', 80);
provider.setFloat('speed', 1.5);
provider.setStr('name', 'Warrior');
provider.setSwitch('alive', false);

// Merge another object into this provider
provider.merge({ level: 5, xp: 200 });

// Named instance cache
var shared:BasicDataProvider = BasicDataProvider.instance('player');
```

### Custom Provider

Implement `IDataProvider` to integrate with any data backend:

```haxe
class MyProvider implements IDataProvider {
    public function getVar(name:String):Dynamic  { return db.get(name); }
    public function getStr(name:String):String   { return db.getStr(name); }
    public function getInt(name:String):Int      { return db.getInt(name); }
    public function getFloat(name:String):Float  { return db.getFloat(name); }
    public function getSwitch(name:String):Bool  { return db.getBool(name); }
    public function setVar(name:String, v:Dynamic):Void  { db.set(name, v); }
    public function setStr(name:String, v:String):Void   { db.setStr(name, v); }
    public function setInt(name:String, v:Int):Void      { db.setInt(name, v); }
    public function setFloat(name:String, v:Float):Void  { db.setFloat(name, v); }
    public function setSwitch(name:String, v:Bool):Void  { db.setBool(name, v); }
}
```

---

## Complete Example

```haxe
// 1. Define the spell data
var data:Dynamic = {

    "on_attack": [
        {
            "id":      "try_attack",
            "require": ["req_alive", "req_has_stamina"],
            "target":  2,
            "@":       ["setint stamina - 10", "setint hp - 0"],
            "then":    [{ "@": ["setint enemy_hp - 25"], "breakon": "always" }],
            "fail":    [{ "@": ["setstr last_fail = not_enough_stamina"] }],
        }
    ],

    "req_alive": [
        {
            "id": "req_alive",
            "*":  ["isswitch alive"],
        }
    ],

    "req_has_stamina": [
        {
            "id": "req_has_stamina",
            "*":  ["isvar stamina >= 10"],
        }
    ],

};

// 2. Create the codex
var codex:SpellCodex = new SpellCodex(data, true /* debug */);

// 3. Create a data provider
var provider:IDataProvider = new BasicDataProvider({
    hp:        100,
    stamina:   30,
    enemy_hp:  200,
    alive:     true,
    last_fail: "",
});

// 4. Invoke
codex.invoke('on_attack', null, provider);

// Inspect result
trace(provider.getInt('enemy_hp'));  // 175 if stamina >= 10, else 200
trace(provider.getInt('stamina'));   // 20  if stamina >= 10
```

---

## Extending ActionQuery / RequirementQuery

Add custom query methods by extending the base classes and registering them with the codex.

```haxe
class MyActionQuery extends ActionQuery {
    public function heal(name:String, amount:Int):MyActionQuery {
        var current:Int = getDataProvider().getInt(name);
        getDataProvider().setInt(name, current + amount);
        return this;
    }
    public function log(message:String):MyActionQuery {
        trace('[Spell] ' + message);
        return this;
    }
}

class MyRequirementQuery extends RequirementQuery {
    public function isalive(name:String):Bool {
        return getDataProvider().getSwitch(name);
    }
}
```

Register the custom units with the codex's query groups:

```haxe
Action.codex.units.push(new MyActionQuery());
Requirement.codex.units.push(new MyRequirementQuery());
```

Then use them in spell data strings as you would the built-in methods:

```
"@": ["heal hp 50", "log attack complete"]
"*": ["isalive player"]
```

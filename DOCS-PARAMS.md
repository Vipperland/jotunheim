# Jotun Params — URL Query Parameters

## Overview

`Jotun.params` is a `DataSource` instance that wraps the current page's URL query string as a typed, readable object. It provides safe, typed access to query parameters with optional defaults and batch operations.

---

## Architecture

```
URL: /page?level=5&name=hero&flags=2,4,8&config=%7B%22debug%22%3Atrue%7D

Jotun.params
  └─ DataSource
       └─ DynamicAccess<Dynamic>
            ├─ "level"  → "5"
            ├─ "name"   → "hero"
            ├─ "flags"  → "2,4,8"
            └─ "config" → "{\"debug\":true}"
```

All values are stored as strings (as the browser delivers them). Typed accessors parse on read.

---

## Accessing Parameters

### Raw / Dynamic

```haxe
var val:Dynamic = Jotun.params.get('level');       // "5" (String)
var val:Dynamic = Jotun.params.get('missing');     // null
var val:Dynamic = Jotun.params.get('missing', 0); // 0  (alt fallback)
```

### Typed Accessors

```haxe
var level:Int     = Jotun.params.int('level');           // 5
var speed:Float   = Jotun.params.float('speed');         // 1.5
var name:String   = Jotun.params.string('name');         // "hero"
var debug:Bool    = Jotun.params.bool('debug');          // true / false

// With defaults
var level:Int     = Jotun.params.int('level', 1);        // 1 if missing
var name:String   = Jotun.params.string('name', 'anon'); // "anon" if missing
```

### Array

Splits a comma-delimited (or custom-delimited) parameter into an array:

```haxe
// URL: ?flags=2,4,8
var flags:Array<Dynamic> = Jotun.params.array('flags');        // ["2","4","8"]
var flags:Array<Dynamic> = Jotun.params.array('flags', ',');   // same, explicit delimiter

// URL: ?tags=a|b|c
var tags:Array<Dynamic> = Jotun.params.array('tags', '|');     // ["a","b","c"]
```

### JSON Parsing

```haxe
// URL: ?config={"debug":true,"level":3}
var cfg:Dynamic = Jotun.params.parse('config');
trace(cfg.debug);   // true
trace(cfg.level);   // 3
```

If the parameter is missing, `parse()` returns `{}` (an empty object, not null).

---

## Checking Presence

```haxe
Jotun.params.exists('level');     // true if the key is in the query string
Jotun.params.isEmpty();           // true if no parameters at all
```

---

## Batch — `list()`

Fetch multiple parameters at once and know immediately if any are missing:

```haxe
typedef ListResult = {
    var values:DynamicAccess<Dynamic>;   // present keys → their values
    var missing:Array<String>;           // keys that were absent
    var success:Bool;                    // true if missing.length == 0
}

var r:ListResult = Jotun.params.list(['level', 'name', 'token']);

if (r.success) {
    trace(r.values.get('level'));   // use the values
} else {
    trace('Missing params: ' + r.missing.join(', '));
}
```

---

## Merging Extra Data

Add or override keys programmatically (does not change the browser URL):

```haxe
Jotun.params.merge({ extra: 'injected', level: 99 });
trace(Jotun.params.int('level'));   // 99
```

---

## Removing a Key

```haxe
Jotun.params.remove('token');
trace(Jotun.params.exists('token'));  // false
```

---

## Serializing

```haxe
trace(Jotun.params.toString());   // JSON representation of the current data
```

---

## Complete Example

```haxe
// URL: /game?level=3&mode=hard&debug=true&items=sword,shield,potion

Jotun.run(function() {

    var level:Int    = Jotun.params.int('level', 1);
    var mode:String  = Jotun.params.string('mode', 'normal');
    var debug:Bool   = Jotun.params.bool('debug');
    var items:Array<Dynamic> = Jotun.params.array('items');

    trace(level);   // 3
    trace(mode);    // "hard"
    trace(debug);   // true
    trace(items);   // ["sword","shield","potion"]

    // Guard against required params
    var check:ListResult = Jotun.params.list(['level', 'mode', 'session']);
    if (!check.success) {
        trace('Required params missing: ' + check.missing.join(', '));
        // → "Required params missing: session"
        return;
    }

});
```

---

## Custom DataSource

`DataSource` is not limited to URL params. You can instantiate it with any `DynamicAccess<Dynamic>`:

```haxe
var source:DataSource = new DataSource({
    level: '5',
    name:  'hero',
});

trace(source.int('level'));        // 5
trace(source.string('name'));      // "hero"
trace(source.bool('active', true)); // true (alt fallback)
```

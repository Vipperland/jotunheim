# Jotun Module System

## Architecture

The module system separates HTML structure, CSS, scripts, and data into named blocks that live in plain `.html` files. A single file can hold many modules. At runtime, `ModLib` parses the file, stores each block by name, and later serves it on demand — optionally filled with dynamic data or mounted directly into the DOM.

```
.html file  ──register()──►  ModLib (CACHE)
                                 │
              ┌──────────────────┼──────────────────┐
              ▼                  ▼                   ▼
           get(name, data)   object(name)       image(name)
              │                  │
           Filler.to()       Json.parse()
              │
           Display.mount()  ──►  DOM
           Display.react()  ──►  o-* data binding
```

`ModLib` is a singleton — always use `Jotun.resources`, never `new ModLib()`.

---

## Module File Format

A module file is a plain HTML file. Blocks are delimited by a JSON header comment:

```
[Module:{<JSON config>}]
<content>
```

The content ends at the next `[Module:{…}]` header, or earlier at a `/EOF;` marker (everything after `/EOF;` up to the next header is discarded — useful for inline comments).

A single file may contain as many blocks as needed.

```html
[Module:{"type":"css"}]
  body { font-family: Arial; }

[Module:{"name":"card"}]
  <div class="card">
    <h2>{{title}}</h2>
    <p>{{body}}</p>
  </div>

[Module:{"name":"card-footer","type":"//"}]
  This block is a comment and will be skipped entirely.

[Module:{"name":"card-data","type":"data"}]
  { "items": [] }
```

---

## Module Header Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | String | Unique ID used to retrieve the block. Omit for anonymous. `[]` pushes data blocks into the buffer array. |
| `type` | String | Controls how the content is treated (see table below). |
| `require` | Array\<String\> | Names of other modules to include into this one via `{{@include:name}}` placeholders. |
| `data` | String (JSON) | Static data object used to pre-fill `{{tokens}}` during parsing. |
| `replace` | Array\<[from, to]\> | String substitutions applied to content during parsing. |
| `target` | Array\<{query, index}\> | Auto-mount this module to matching DOM elements once loaded. |

### Type Values

| `type` | Behaviour |
|--------|-----------|
| *(absent)* or `html` | Stored as HTML string in the cache. |
| `data` | Content is parsed as JSON. Named blocks go to `resources.object(name)`; unnamed (`[]`) are pushed to `resources.buffer()`. |
| `css` or `style` | Injected into `<head>` as a `<style>` element. Not stored in cache. |
| `script` or `javascript` | Injected into `<head>` as a `<script>` element. Not stored in cache. |
| `image` | Content stored as a data URL string, retrievable via `resources.image(name)`. |
| `//` | Comment block — skipped entirely. |

---

## Registering Modules

```haxe
// Load a file and parse all its module blocks
Jotun.loader.module('/modules/ui.html', null, function(r:IRequest) {
    Jotun.resources.register('/modules/ui.html', r.data);
});

// Or inline (useful for PHP server-side rendering)
Jotun.resources.register('inline', '<div>{{msg}}</div>'); // no [Module:] header → stored under 'inline'
```

When no `[Module:{…}]` headers are found, the whole file content is stored under the file path as a single unnamed module. If the file extension is `.css` or `.js`, it is injected into the document head instead.

---

## Retrieving Modules

```haxe
// Check existence
Jotun.resources.exists('card');       // Bool

// Get HTML string (no data substitution)
var html:String = Jotun.resources.get('card');

// Get HTML string with Filler data applied
var html:String = Jotun.resources.get('card', { title: 'Hello', body: 'World' });

// Get as parsed JSON object
var obj:Dynamic = Jotun.resources.object('card-data');

// Get image data-URL
var src:String = Jotun.resources.image('logo');

// Get data buffer (all [] blocks)
var list:Array<Dynamic> = Jotun.resources.buffer();

// Get named data block
var cfg:Dynamic = Jotun.resources.buffer('settings');

// Iterate all registered names
Jotun.resources.list(function(name:String) { trace(name); });

// Remove a module
Jotun.resources.remove('card');
```

---

## Filler — Token Substitution

`Filler.to(template, data)` replaces `{{key}}` tokens in a string with values from a data object. Keys are **case-insensitive** and support **dot-notation** for nested objects.

```haxe
var html:String = Filler.to(
    '<b>{{name}}</b> is {{age}} years old in {{address.city}}.',
    { name: 'Ana', age: 30, address: { city: 'Lisbon' } }
);
// → <b>Ana</b> is 30 years old in Lisbon.
```

When `data` is an **Array**, the template is repeated for each item and concatenated. The index is available as `{{%0}}`:

```haxe
var html:String = Filler.to(
    '<li data-index="{{%0}}">{{label}}</li>',
    [
        { label: 'First' },
        { label: 'Second' },
        { label: 'Third' },
    ]
);
// → <li data-index="0">First</li><li data-index="1">Second</li><li data-index="2">Third</li>
```

Properties starting with `_` are skipped. Unknown `{{tokens}}` that remain after substitution are erased (no output). Optional tokens can be written as `{{?field}}` — the `?` is stripped before matching, giving the same erasure behaviour but signalling intent in the template.

### `Filler.splitter`

Splits a string at a separator and inserts glue values between the pieces:

```haxe
var result:String = Filler.splitter(
    'Hello % how are % today?',
    '%',
    ['Ana,', 'you'],
);
// → 'Hello Ana, how are you today?'
```

An optional `each` function transforms each glue value before insertion.

### `Filler.splitterTo`

Combines `Filler.to` and `Filler.splitter` in one call:

```haxe
var result:String = Filler.splitterTo(template, data, split, glue, each);
```

### `Filler.extractNumber`

Strips all non-digit characters and returns the result as a number:

```haxe
Filler.extractNumber('v12.3-rc4');  // → 1234
```

---

## Module Composition — `require` and `{{@include:…}}`

A module can pull in the rendered content of other modules at parse time using `require` in the header and `{{@include:name}}` placeholders in the body.

```html
[Module:{"name":"badge"}]
  <span class="badge">{{label}}</span>

[Module:{"name":"player-row","require":["badge"]}]
  <div class="player">
    <b>{{name}}</b>
    {{@include:badge}}
  </div>
```

Custom data can be passed to the included module inline:

```html
[Module:{"name":"player-row","require":["badge"]}]
  <div class="player">
    <b>{{name}}</b>
    {{@include:badge,data:{"label":"MVP"}}}
  </div>
```

The included module must already be registered before the including module is parsed. Register dependencies first (or use `priority` in `SpellGroup.patch`).

---

## Auto-mount — `target`

The `target` field mounts a module into DOM elements automatically once the file is registered, without any HaXe code:

```html
[Module:{"name":"toolbar","target":[{"query":"#app","index":0}]}]
  <nav class="toolbar">…</nav>
```

This is equivalent to calling `Jotun.one('#app').mount('toolbar', null, 0)` after registration.

Multiple targets are supported:

```html
[Module:{"name":"footer","target":[
    {"query":"#main", "index":-1},
    {"query":"#modal"}
]}]
  <footer>…</footer>
```

---

## Mobile Variants

If a module named `foo::mobile` exists and `Jotun.agent.mobile` is `true`, `resources.build('foo', data)` automatically picks `foo::mobile` instead of `foo`:

```html
[Module:{"name":"hero"}]
  <section class="hero desktop">Big layout</section>

[Module:{"name":"hero::mobile"}]
  <section class="hero mobile">Compact layout</section>
```

```haxe
// On mobile this will use hero::mobile automatically
container.mount('hero');
```

---

## `Display.mount` — Mounting into the DOM

```haxe
// Signature
public function mount(q:String, ?data:Dynamic, ?at:Int = -1):Displayable
```

`mount` takes a **module name** or a **raw HTML string**, parses it into children, and inserts them into the caller element. It returns the last child inserted.

```haxe
var card:Displayable = container.mount('card', { title: 'Hello', body: 'World' });
// Equivalent to:
//   var html = Jotun.resources.get('card', data);
//   container.writeHtml(html);  // but non-destructive — appends children
```

**Insertion index:**

```haxe
container.mount('header');        // append (default)
container.mount('header', null, 0); // prepend (insert at index 0)
container.mount('header', null, 2); // insert at position 2
```

**Raw HTML (no registered module):**

```haxe
// When the name is not in resources, the string is treated as HTML directly
container.mount('<p class="note">{{text}}</p>', { text: 'Hi' });
```

**After mounting**, if `data` is provided, `react(data)` is called automatically on the result, activating all `o-*` bindings.

**`onMount` hook** — fires after every `build` call, useful for post-processing:

```haxe
Jotun.resources.onMount(function(display:Displayable, module:String) {
    trace('mounted: ' + module);
    display.all('[data-tooltip]').each(initTooltip);
});
```

---

## `Display.react` — Data Binding

```haxe
display.react({ name: 'Ana', score: 42, active: true });
display.react('{"name":"Ana","score":42}'); // JSON string also accepted
```

`react` walks the subtree looking for `o-*` attributes and fills them from the data object. All tokens use `{{dot.path}}` notation. Multiple tokens can appear in one attribute value.

### Binding Attributes

| Attribute on element | Effect |
|----------------------|--------|
| `o-data="{{field}}"` | Sets innerHTML (or `.value()` on `Input`) to the field value. Line breaks are converted to `<br/>`. |
| `o-attr="name:{{field}}"` | Sets the named attribute to the field value. |
| `o-style="prop:{{field}}"` | Sets the named CSS property to the field value. |
| `o-class="{{field}}"` | Adds the class(es) returned by the field. |
| `o-show-if="{{a}},{{b}}"` | Shows the element when **all** listed fields are truthy (non-empty, non-zero, non-false). |
| `o-hide-if="{{a}},{{b}}"` | Hides the element when **all** listed fields are truthy. |
| `o-score="N"` | Override: require only N truthy fields instead of all. |
| `o-single` | (Flag) Remove the `o-*` attribute after the first apply — one-shot binding. |

Multiple tokens per attribute are combined before writing:

```html
<span o-data="{{firstName}} {{lastName}}"></span>
<div o-style="color:{{textColor}};background:{{bgColor}}"></div>
<div o-attr="href:{{url}};target:{{linkTarget}}"></div>
```

Nested data paths use dot notation:

```html
<img o-attr="src:{{avatar.url}}" o-style="width:{{avatar.size}}px" />
```

### Full Template Example

```html
[Module:{"name":"player-card"}]
<div class="card" o-class="{{statusClass}}">
    <img o-attr="src:{{avatar}}" />
    <h3 o-data="{{name}}"></h3>
    <span o-data="{{score}} pts"></span>
    <div class="badge" o-show-if="{{isVip}}">VIP</div>
    <div class="warning" o-show-if="{{isBanned}}">BANNED</div>
    <footer o-data="{{meta.lastSeen}}"></footer>
</div>
```

```haxe
container.mount('player-card', {
    name: 'Ana',
    score: 1500,
    avatar: '/img/ana.png',
    statusClass: 'active',
    isVip: true,
    isBanned: false,
    meta: { lastSeen: '2026-04-27' },
});
```

Result:

```html
<div class="card active">
    <img src="/img/ana.png" />
    <h3>Ana</h3>
    <span>1500 pts</span>
    <div class="badge">VIP</div>
    <!-- .warning is hidden -->
    <footer>2026-04-27</footer>
</div>
```

### Global Reactor listener

```haxe
// Called after every react() application, on any element
Reactor.listen(function(display:Displayable) {
    display.all('[data-lazy-img]').each(loadLazyImage);
});

Reactor.unlisten(handler);
```

---

## `ModLib.onDataRequest` — Pre-filter Data

Register a function that intercepts and transforms the data object before every `get()` call. Useful for injecting globals (locale strings, user info) without passing them explicitly each time:

```haxe
Jotun.resources.onDataRequest(function(name:String, data:Dynamic):Dynamic {
    if (data == null) data = {};
    Reflect.setField(data, 'lang', currentLang);
    Reflect.setField(data, 'userName', session.name);
    return data;
});
```

---

## Complete Workflow Example

### 1. Define modules in `ui.html`

```html
[Module:{"type":"css"}]
  .tag { display: inline-block; padding: 2px 8px; border-radius: 4px; }
  .tag.gold  { background: gold; }
  .tag.silver{ background: silver; }

[Module:{"name":"tag"}]
  <span class="tag {{tier}}">{{label}}</span>

[Module:{"name":"leaderboard-row","require":["tag"]}]
  <div class="row shelf">
    <span class="rank">{{rank}}</span>
    <span class="name cel" o-data="{{name}}"></span>
    <span class="score" o-data="{{score}} pts"></span>
    {{@include:tag}}
  </div>

[Module:{"name":"leaderboard"}]
  <div class="leaderboard drawer">
    <h2>{{title}}</h2>
    <div class="rows"></div>
  </div>

[Module:{"name":"empty-state"}]
  <p class="empty">No entries yet.</p>
```

### 2. Load and register

```haxe
Jotun.run(function() {
    Jotun.loader.module('/modules/ui.html', null, function(r:IRequest) {
        Jotun.resources.register('/modules/ui.html', r.data);
        buildLeaderboard();
    });
});
```

### 3. Build and mount

```haxe
function buildLeaderboard():Void {
    var root:Displayable = Jotun.one('#app').mount('leaderboard', { title: 'Top Players' });
    var rows:Displayable = root.one('.rows');

    var entries:Array<Dynamic> = [
        { rank: 1, name: 'Ana',  score: 9800, tier: 'gold',   label: 'Gold'   },
        { rank: 2, name: 'Beto', score: 7500, tier: 'silver', label: 'Silver' },
        { rank: 3, name: 'Cara', score: 5200, tier: '',       label: ''        },
    ];

    if (entries.length == 0) {
        rows.mount('empty-state');
    } else {
        Dice.Values(entries, function(entry:Dynamic) {
            rows.mount('leaderboard-row', entry);
        });
    }
}
```

### 4. Update a mounted element with new data

```haxe
// Later — update score without re-mounting
var row:Displayable = Jotun.one('.row:nth-child(1)');
row.react({ score: 10200, tier: 'gold', label: 'Gold' });
```

---

## Data-only Modules

Modules with `"type":"data"` store JSON instead of HTML. Use them to ship configuration alongside templates in the same file.

```html
[Module:{"name":"config","type":"data"}]
  {
    "pageSize": 20,
    "currency": "USD",
    "features": ["banners", "seasons"]
  }

[Module:{"name":"[]","type":"data"}]
  { "id": 1, "label": "First item" }

[Module:{"name":"[]","type":"data"}]
  { "id": 2, "label": "Second item" }
```

```haxe
var config:Dynamic = Jotun.resources.object('config');
trace(config.pageSize);   // 20

var items:Array<Dynamic> = Jotun.resources.buffer();
trace(items.length);      // 2
```

---

## PHP Server-Side Rendering

On PHP, `ModLib` exposes `prepare()` and `print()` to render modules server-side and optionally export them for the JS client to consume:

```haxe
// PHP side
Jotun.resources.prepare('/modules/ui.html');   // reads and registers the file
Jotun.resources.print('leaderboard', { title: 'Top' }); // echo filled HTML
Jotun.resources.export('leaderboard', data);   // wrap in <noscript jtn-module> for JS pickup
```

The `<noscript jtn-module>` wrapper is transparent to browsers with JS enabled, but the JS client can parse it on load to pre-populate `Jotun.resources` without an extra HTTP request.

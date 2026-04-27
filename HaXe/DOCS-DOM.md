# Jotun DOM Manipulation

## Architecture

Every DOM node is wrapped by a typed **`Displayable`** object. The framework keeps a global identity cache (`_DATA`) keyed by a per-element `_uid`, so the same underlying element always returns the same wrapper instance.

Concrete wrapper classes (`Div`, `Input`, `Button`, `Canvas`, …) extend `Display`. The global factory `Utils.displayFrom(element)` dispatches to the right class using the element's tag name.

```
Jotun (static entry)
  ├─ one(q)  →  Displayable
  └─ all(q)  →  ITable
                  └─ [Displayable, Displayable, ...]

Display (extends Query, implements Displayable)
  ├─ one(q)        scoped querySelector
  ├─ all(q)        scoped querySelectorAll
  └─ Input / Div / Button / … (typed subclasses)
```

---

## Global Selectors — `Jotun.one` / `Jotun.all`

```haxe
// querySelector – returns a typed Displayable (or null)
var hero:Displayable = Jotun.one('.hero');

// querySelector scoped to an element
var btn:Displayable = Jotun.one('button', panel.element);

// querySelectorAll – returns a recyclable ITable collection
var cards:ITable = Jotun.all('.card');

// scoped querySelectorAll
var inputs:ITable = Jotun.all('input', form.element);
```

Both accept an optional second argument (a raw `Element` or a container) that scopes the query. `one()` logs a warning when nothing matches; `all()` returns an empty collection.

---

## Display — Core Methods

### CSS Classes

`css()` reads or writes the class list. Prefixes control the operation:

| Prefix | Effect |
|--------|--------|
| *(none)* | Add the class (no-op if already present) |
| `/foo` | Remove `foo` |
| `*foo` | Toggle `foo` |

Multiple classes can be space-separated in one call.

```haxe
var d:Displayable = Jotun.one('.card');

d.css('active');             // add
d.css('/active');            // remove
d.css('*active');            // toggle
d.css('highlighted /faded'); // add + remove in one call

var classes:String = d.css(); // read current className

d.hasCss('active');          // Bool
d.toggle('active faded');    // toggle each class individually
```

### Inline Style

```haxe
// Set a single property
d.style('backgroundColor', '#ff0');

// Get a computed property
var color:String = d.style('color');

// Set multiple properties at once
d.style({
    opacity: '0.5',
    transform: 'scale(1.1)',
});

// Full computed style declaration
var decl:CSSStyleDeclaration = d.style(); // or d.trueStyle()
```

### Visibility

```haxe
d.show();                      // element.hidden = false, display = null
d.hide();                      // element.hidden = true,  display = 'none'

d.alpha(0.5);                  // set opacity (0=transparent, 1=opaque)
var a:Float = d.alpha();       // read current opacity

// Viewport visibility (call on scroll/resize)
var level:UInt = d.getVisibility();   // 0=hidden, 1=partial, 2=fully visible
d.isVisible();                 // true if level > 0
d.isFullyVisible();            // true if level == 2
// getVisibility() fires a "visibility" event whenever the level changes
```

### Content

```haxe
// HTML
d.writeHtml('<b>Hello</b>');   // replace innerHTML
d.appendHtml('<i>world</i>');  // append to innerHTML

// Text (safe — no HTML parsing)
d.writeText('Hello world');
d.appendText('!');

// value() works on inputs, content-editable, and generic attributes
var v:String = d.value();
d.value('new text');

// Remove all children
d.empty();          // walks childNodes (safe)
d.empty(true);      // innerHTML = "" (fast)
```

### Attributes

```haxe
// Read / write a single attribute
var src:String = img.attribute('src');
img.attribute('src', '/new.png');

// Read / write multiple attributes
d.attributes({ role: 'button', tabindex: '0' });
var all:Dynamic = d.attributes();   // returns an object of all attrs

d.hasAttribute('data-id');          // Bool
d.clearAttribute('data-id');        // remove and return old value

// The ref() convenience method targets element.id
d.ref('my-id');
var id:String = d.ref();
```

### Child Management

```haxe
d.length();                         // childNodes.length

// Add children
d.addChild(other);                  // append
d.addChild(other, 0);               // insert at index
d.addChildren(table);               // add ITable batch

// Query children
var first:Displayable = d.getChild(0);
var kids:ITable        = d.children();  // all direct children

// Remove
d.removeChild(other);
d.removeChildAt(2);
d.removeChildren();                 // all children
d.removeChildren(2);                // keep first 2

// Navigate siblings
var prev:Displayable = d.previous();
var next:Displayable = d.next();

// Index within parent
var i:Int = d.index();
d.setIndex(2);                      // reorder
```

### Scoped Queries

Every `Display` instance carries its own `one()` and `all()`, scoped to that element:

```haxe
var panel:Displayable = Jotun.one('#panel');
var title:Displayable = panel.one('h2');
var btns:ITable       = panel.all('button');
```

### Parent Traversal

```haxe
var p:Displayable = d.parent();     // immediate parent
var p2:Displayable = d.parent(2);   // grandparent (n levels up)

// Walk upward until a selector matches
var section:Displayable = d.parentQuery('section');
```

### Position and Geometry

```haxe
// Absolute page position (accounts for document scroll)
var pt:Point   = d.position();
var rect:DOMRect = d.getBounds(); // getBoundingClientRect()
var r:Dynamic  = d.rectangle();  // {width, height, x1, y1, x2, y2}

// Scroll
var scroll:Point = d.getScroll();      // {x: scrollLeft, y: scrollTop}
d.addScroll(0, 200);                   // smooth scroll by delta
d.setScroll(0, 0);                     // smooth scroll to absolute

// Left / top (inline style)
d.x(100);       d.y(50);
var x:Int = d.x();

// Dimensions
d.width(300);   d.height(200);
var w:Int = d.width();  // clientWidth

// Fit to intrinsic or explicit size
d.fit(640, 480);
```

### Events

```haxe
// Low-level: d.on(type, handler)
d.on('click', function(a:Activation) {
    trace('clicked', a.target);
});

// Via EventDispatcher (strongly typed convenience methods):
d.events.click(function(a:Activation) { ... });
d.events.keyDown(function(a:Activation) { ... });
d.events.mouseMove(function(a:Activation) { ... });
d.events.scroll(function(a:Activation) { ... });

// Activation carries:
//   a.target    – the Displayable that owns the dispatcher
//   a.event     – the raw DOM Event
//   a.cancel()  – preventDefault + stopPropagation
```

### 3D Transforms

Transforms are composed and written to `transform: matrix3d(…)` in a single call to `transform()`.

```haxe
d.rotateX(45)
 .rotateY(30)
 .rotateZ(0)
 .translate(0, 0, -200)
 .scale(1.2, 1.2, 1)
 .transform(); // flushes the matrix3d
```

Shorthand for all three rotations:

```haxe
d.rotate(45, 30, 0).transform();
```

### Animations (MotionStep)

```haxe
d.motion([
    { css: 'enter',   delay: 0   },
    { css: 'visible', delay: 300 },
    { css: '/enter',  delay: 800, callback: function(d) { trace('done'); } },
]);
d.stopMotion(); // cancel in-flight animation
```

### Visual Filters (SVG)

```haxe
// Color matrix (r/g/b/a as multipliers 0-1)
d.colorTransform(1, 0.5, 0.5, 1.0);

// Turbulence displacement
d.displacement(0.02, 4, 20, 0);

// Named SVG filter
d.filters('my-filter-id');
```

### Cloning

```haxe
var copy:Displayable = d.clone();        // shallow – no events
var deep:Displayable = d.clone(true);    // also copies event listeners

copy.isClone();                          // true
copy.getOriginal();                      // reference back to d
```

### Lifecycle

```haxe
d.addTo(parent);    // append to a target element
d.addToBody();      // append to document.body
d.remove();         // detach from DOM (keeps wrapper alive)
d.dispose();        // detach + clear events + remove from cache

// Deferred: runs after DOMContentLoaded if DOM isn't ready yet
d.addTo(null);
```

### Mounting Templates

```haxe
// Parse and append HTML, optionally filling Filler tokens
var last:Displayable = container.mount('<div class="card">{{title}}</div>', { title: 'Hello' });

// From a registered resource key
container.mount('card-template', { title: 'Hello' }, 2); // insert at index 2
```

### Reactive Data

```haxe
// Reactor applies data fields as attribute writes, text, or class toggles
// depending on the jtn-* attributes on child elements
d.react({ title: 'New Title', active: true });
d.react('{"title":"JSON works too"}');
```

### ID Cache

```haxe
Display.clearCache();   // dispose all wrappers whose element is disconnected
Display.clearIdles();   // dispose wrappers idle for > 15 minutes
```

---

## Input

`Input` extends `Display` and adds form-specific helpers.

```haxe
// Typed selector
var field:Input = Input.get('#username');

// Also constructable and queryable as Displayable
var field:Input = cast Jotun.one('#username');
```

### Type, Placeholder, Pattern

```haxe
field.type('email');
field.placeholder('you@example.com');
field.pattern('[a-z]+');
field.required(true);
```

### Reading the Value

```haxe
var v:String = field.value();    // respects maxLength and filter strip
field.value('new value');        // programmatic write

field.isEmpty();                 // true if value == ""
field.clear();                   // sets value to ""
```

### Checkbox

```haxe
field.type('checkbox');
field.check(true);        // check
field.check(false);       // uncheck
field.check(null);        // toggle
field.isChecked();        // Bool
```

### Validation

```haxe
// Restrict accepted characters via EReg or string pattern
field.restrict('/^[0-9]+$/');

// Validate current value
field.isValid();   // respects type, pattern, and mime for files

// Accept only specific MIME types on file inputs
field.acceptOnly(['image/jpeg', 'image/png']);
```

### File Input

```haxe
// Activate as file picker and register callback
field.control(function(input:Input) {
    var f:File = input.file(0);
    var url:String = input.readFile(0);   // object URL for preview
}, ['image/jpeg', 'image/png']);

field.hasFile();            // Bool
field.files();              // raw FileList
field.file(0);              // first File
field.filesToArray();       // Array<Blob>
field.filesToObject();      // { file_0: Blob, file_1: Blob, ... }
```

---

## ITable — Batch Operations

`Jotun.all()` and `Display.all()` return an `ITable`. Every method returns `this` for chaining.

```haxe
var cards:ITable = Jotun.all('.card');

// Apply to all
cards.css('active');
cards.style('color', 'red');
cards.attribute('aria-selected', 'true');
cards.show();
cards.hide();
cards.remove();
cards.clear();           // empty() each element

// Iterate
cards.each(function(d:Displayable) { trace(d.ref()); });
cards.each(function(d:Displayable) { ... }, function() { trace('empty'); });

// Events on all
cards.onClick(function(a:Activation) { ... });
cards.onMouseEnter(function(a:Activation) { ... });

// Filter
var inner:ITable = cards.contains('Hello');  // by innerHTML substring
var subset:ITable = cards.not(oneCard);      // exclude element(s)

// Access
var first:Displayable = cards.first();
var last:Displayable  = cards.last();
var n:Displayable     = cards.obj(2);
var count:Int         = cards.length();

// Merge multiple tables
var all:ITable = cards.merge([others, moreOthers]);

// Lifecycle
cards.dispose();   // dispose all elements and return table to pool
```

---

## Jotun — Other Static Utilities

```haxe
// Run handler only after DOM is ready
Jotun.run(function() {
    trace('DOM ready');
});

// Parse HTML string + optional template data, append to body
var el:Displayable = Jotun.create('<section>{{name}}</section>', { name: 'World' });

// Inject a JS script (inline or by URL)
Jotun.inject('console.log("hi")');
Jotun.inject('/lib/chart.js', null, function(s:Script) { ... });

// Inject CSS (inline or by URL)
Jotun.stylish('body { margin: 0; }');
Jotun.stylish('/theme.css', null, function(s:Style) { ... });

// HTTP request
Jotun.request('/api/data', { id: 1 }, 'POST', function(r:IRequest) {
    if (r.success) trace(r.object());
});

// Logging
Jotun.log('Something happened', 1);
```

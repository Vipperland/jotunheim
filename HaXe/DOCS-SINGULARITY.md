# Jotun Singularity — Multi-Tab Coordination

## Overview

`Singularity` synchronizes state and identity across browser tabs sharing the same origin. It builds on `Broadcast` to elect a "main" tab, track every open tab, propagate visibility changes, and deliver arbitrary data to specific tabs.

Access it as `Jotun.singularity` or use the static API directly.

---

## Architecture

```
Tab A                     Tab B                     Tab C
  │                         │                         │
  ├─ connect()              ├─ connect()              ├─ connect()
  │    sends "connect" ────►│    replies "update" ───►│    ...
  │    ◄─ "update" ─────────│                         │
  │                         │  (elected main after 1s if no existing main)
  │                         │
Broadcast channel: "jotumhein"  (default)
```

Each tab holds a `TabInstance` struct describing itself. The registry (`_engines`) is updated in real time as tabs join and leave.

---

## TabInstance

```haxe
typedef TabInstance = {
    var id:String;       // unique ID (same as Broadcast UID)
    var main:Bool;       // whether this tab is the elected main
    var name:String;     // optional label set in connect()
    var time:Float;      // timestamp of connection (Date.now().getTime())
    var url:String;      // location.href at connection time
    var visible:Bool;    // document.visibilityState == 'visible'
    var ?current:Bool;   // true only for the local tab's own record
}
```

---

## Connecting

Call `connect()` once, as early as possible. Calling it again is a no-op.

```haxe
Singularity.connect();

// With options
Singularity.connect({
    name: 'dashboard',       // optional label for this tab
    channel: 'my-app',       // override the default channel name
});
```

After connecting:
- The tab broadcasts a `connect` action to all other tabs.
- All other tabs reply with an `update` action (so the new tab learns the existing registry).
- A 1-second timer fires; if no other tab has claimed `main`, this tab self-elects.

---

## Signals

Register handlers before or after `connect()`. All signal callbacks receive a `TabInstance` (or a compound object for `onSync`).

```haxe
// One-shot registration via fetch()
Singularity.fetch({
    onMain:       function(tab:TabInstance) { trace('new main: ' + tab.id); },
    onConnect:    function(tab:TabInstance) { trace('joined: '  + tab.id); },
    onDisconnect: function(tab:TabInstance) { trace('left: '    + tab.id); },
    onUpdate:     function(tab:TabInstance) { trace('updated: ' + tab.id); },
    onVisibility: function(tab:TabInstance) { trace('visibility changed: ' + tab.visible); },
    onSync:       function(e:Dynamic)       { trace('sync data', e.syncedData); },
    onInstance:   function(tab:TabInstance) { trace('connect or update: ' + tab.id); },
});

// Or register individually
Singularity.signals.add('onMain', function(tab:TabInstance) { ... });
```

| Signal | Fires when |
|--------|-----------|
| `onMain` | A tab becomes the main tab (includes the local tab self-electing) |
| `onConnect` | A new tab joins |
| `onDisconnect` | A tab closes or navigates away |
| `onUpdate` | A tab replies with its current state |
| `onVisibility` | A tab's `document.visibilityState` changes |
| `onSync` | A `sync()` message is received and passes the filter |
| `onInstance` | Fires on both `connect` and `update` |

---

## Querying Tab State

```haxe
Singularity.id();            // String — this tab's unique ID
Singularity.isMain();        // Bool   — is this tab the current main?
Singularity.isActive();      // Bool   — is this tab visible?
Singularity.count();         // Int    — total known tabs (including self)
Singularity.instances();     // Array<TabInstance> — all tabs, sorted oldest first

// Debug summary
trace(Singularity.toString());
// → [Singularity{id=...,main=true,connections=3,channel=jotumhein,instances=[id2,id3]}]
```

---

## Syncing Data

`sync()` broadcasts arbitrary data to all tabs (or a subset). Receiving tabs fire `onSync`.

```haxe
// Broadcast to all tabs
Singularity.sync({ event: 'user_logged_out' });

// Send to a specific tab by ID
Singularity.sync({ reload: true }, targetTabId);

// Send to multiple specific tabs
Singularity.sync({ theme: 'dark' }, [tabId1, tabId2]);
```

The `onSync` handler receives:

```haxe
{
    engine:     TabInstance,   // the tab that sent the sync
    syncedData: Dynamic,       // the payload passed to sync()
}
```

---

## Channel

```haxe
// Read current channel name
var name:String = Singularity.channel();

// Set a custom channel (prefixed with "singularity.")
Singularity.channel('my-app');  // uses "singularity.my-app"
```

---

## Main Election

- When a tab connects, it waits 1 second.
- If no existing tab has announced itself as `main`, the connecting tab self-elects by broadcasting a `main` action and calling `signals.call('onMain', _data)`.
- When the main tab closes, it nominates an heir (any other known tab). If the heir matches the local tab's ID, that tab self-elects immediately.
- If two tabs claim `main` simultaneously (race), the one receiving the `update` from the other yields.

---

## Lifecycle Events

`Singularity` automatically listens to:

- `visibilitychange` on `document` — broadcasts a `visibility` action to all tabs.
- `beforeunload` on `window` — broadcasts a `disconnect` action (with heir nomination if this was main) and stops the self-activate timer.

---

## Complete Example

```haxe
// main.hx or entry point
Singularity.connect({ name: 'player-dashboard' });

Singularity.fetch({
    onMain: function(tab) {
        if (tab.current) {
            trace('This tab is now the coordinator');
            startBackgroundPolling();
        }
    },
    onSync: function(e) {
        switch(e.syncedData.event) {
            case 'invalidate_cache': refreshLocalCache();
            case 'theme_change':     applyTheme(e.syncedData.theme);
        }
    },
    onDisconnect: function(tab) {
        trace('Tab closed: ' + tab.name + ' (' + tab.id + ')');
    },
});

// From anywhere, push data to all other tabs
function notifyAll(event:String, payload:Dynamic) {
    Singularity.sync({ event: event, data: payload });
}
```

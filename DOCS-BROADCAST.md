# Jotun Broadcast — Cross-Tab Messaging

## Overview

`Broadcast` is a **singleton** that enables pub/sub messaging between browser tabs on the same origin. It wraps the native `BroadcastChannel` API and falls back to `localStorage` events for older browsers.

Access it via `Jotun.broadcast` or `Broadcast.ME()`.

---

## Architecture

```
Tab A                                Tab B
  │                                    │
  Broadcast.ME()                       Broadcast.ME()
       │                                    │
  _channels["my-channel"]           _channels["my-channel"]
       │ ◄── BroadcastChannel ──────────── │
       │     (or localStorage fallback)
       │
  handlers["my-channel"] = [fn1, fn2, ...]
```

Each unique channel name maps to one `BroadcastChannel` instance. When a channel's last listener is removed, the channel is closed.

---

## Singleton

```haxe
var bc:Broadcast = Broadcast.ME();     // returns existing or creates new
var bc:Broadcast = Jotun.broadcast;    // same instance via Jotun
```

Calling `new Broadcast()` a second time throws an error — always use `ME()`.

---

## UID

Each `Broadcast` instance has a 24-character random UID generated at startup. This is the identity used by `Singularity` and other coordination layers.

```haxe
var uid:String = Jotun.broadcast.getUID();   // e.g. "a4f7c2b1e9d38..."
```

---

## Listening

```haxe
// Register a handler for a channel
Jotun.broadcast.listen('chat', function(data:Dynamic) {
    trace('Received on chat:', data.message);
});

// Register multiple handlers on the same channel
Jotun.broadcast.listen('events', onGameEvent);
Jotun.broadcast.listen('events', onLogEvent);
```

Each call to `listen()` appends a handler to that channel's array. The `BroadcastChannel` is opened lazily on the first listener.

---

## Sending

```haxe
// Send any Dynamic payload to a channel
Jotun.broadcast.send('chat', { user: 'Alice', message: 'Hello' });

// The sender does NOT receive its own message (BroadcastChannel behavior)
// localStorage fallback: writes then immediately removes the key
```

---

## Unlistening

```haxe
// Remove a specific handler
Jotun.broadcast.unlisten('chat', myHandler);

// When the last handler is removed, the BroadcastChannel is closed automatically
```

---

## Muting / Unmuting Debug Logs

`Broadcast` logs all channel activity through `Jotun.log`. Singularity's internal channels (`singularity.*`) are always suppressed from logs regardless of mute state.

```haxe
Jotun.broadcast.mute();    // suppress all Broadcast log output
Jotun.broadcast.unmute();  // restore log output
```

---

## Disconnecting

```haxe
// Remove all listeners on all channels and close all BroadcastChannels
Jotun.broadcast.disconnect();
```

---

## Browser Compatibility Fallback

When `window.BroadcastChannel` is not available (older browsers), `Broadcast` falls back to `localStorage`:

- **Send**: `localStorage.setItem(channel, JSON.stringify(data))` then `removeItem(channel)`.
- **Receive**: `window.addEventListener('storage', ...)` — fires in other tabs when a key changes.

The API is identical from the caller's perspective.

---

## Complete Example

```haxe
// Tab A — subscribe to a channel
Jotun.broadcast.listen('game-state', function(data:Dynamic) {
    if (data.action == 'start') {
        beginGame(data.level);
    }
});

// Tab B — publish an event
Jotun.broadcast.send('game-state', {
    action: 'start',
    level: 3,
});

// Tab A — remove listener when done
Jotun.broadcast.unlisten('game-state', myHandler);
```

---

## Relationship with Singularity

`Singularity` is built entirely on top of `Broadcast`. It uses a single internal channel (default: `"jotumhein"`, or `"singularity.<name>"` if customized) for all tab coordination messages. That channel is intentionally excluded from debug logs.

```haxe
// Singularity internally calls:
Jotun.broadcast.listen(_channel, _onEngine);
Jotun.broadcast.send(_channel, { action: 'connect', id: ..., ... });
```

You can use `Broadcast` directly for your own cross-tab messaging without going through `Singularity`.

# Jotun Gate — PHP Database Access

## Overview

`Gate` is a PHP PDO wrapper accessible as `Jotun.gate`. It manages a single database connection and exposes both a low-level `prepare`/`query` API and a higher-level `QueryBuilder` for safe, parameterized SQL. All queries use `?` placeholders; values are never interpolated into SQL strings.

---

## Architecture

```
Jotun.gate  (Gate instance)
  ├─ open(Token)         — establishes PDO connection
  ├─ prepare(sql, params) → ICommand    (INSERT / UPDATE / DELETE)
  ├─ query(sql, params)   → IExtCommand (SELECT — has .result)
  ├─ table(name)          → DataTable   (cached per-table helper)
  └─ builder              → QueryBuilder
        ├─ add / find / update / delete / copy
        ├─ join variants
        └─ Clause — composable WHERE conditions
```

---

## Connection — Token

```haxe
// From explicit host
var token:Token = Token.from('db.example.com', 3306, 'user', 'secret', 'mydb');

// Shortcut for localhost (defaults: user='root', pass='')
var token:Token = Token.localhost('mydb');
var token:Token = Token.localhost('mydb', 'admin', 'pass123');

// Open the connection
Jotun.gate.open(token);

if (!Jotun.gate.isOpen()) {
    trace(Jotun.gate.errors);   // Array<ErrorDescriptior>
}
```

`open()` is a no-op if already connected. PDO attributes default to: stringify=false, emulate=true, buffered=true.

---

## Low-Level Queries

### `prepare()` — INSERT / UPDATE / DELETE

Returns `ICommand` with a `.execute()` method.

```haxe
var cmd:ICommand = Jotun.gate.prepare(
    "INSERT INTO users (name, email) VALUES (?, ?)",
    ['Alice', 'alice@example.com']
);
var ok:Bool = cmd.execute().success;
```

### `query()` — SELECT

Returns `IExtCommand`, which has a `.result` array after `.execute()`.

```haxe
var cmd:IExtCommand = Jotun.gate.query(
    "SELECT * FROM users WHERE id = ?",
    [42]
);
var rows:Array<Dynamic> = cmd.execute().result;
trace(rows[0].name);
```

### Last Inserted ID

```haxe
var id:Dynamic = Jotun.gate.getInsertedID();           // raw
var id:Int     = Jotun.gate.getInsertedID(null, 'int'); // parsed as Int
```

---

## QueryBuilder

`Jotun.gate.builder` provides a fluent, safe API for common SQL operations. All values are bound as `?` parameters.

### INSERT — `add()`

```haxe
var cmd:ICommand = Jotun.gate.builder
    .add('users', { name: 'Bob', email: 'bob@example.com', active: true })
    .execute();

trace(cmd.success);
```

### SELECT — `find()`

```haxe
// find(fields, table, ?clause, ?order, ?limit, ?group)

// All rows
var cmd:IExtCommand = Jotun.gate.builder
    .find('*', 'users')
    .execute();
var rows:Array<Dynamic> = cmd.result;

// With clause and ordering
var cmd:IExtCommand = Jotun.gate.builder
    .find(['id', 'name', 'email'], 'users',
        Clause.EQUAL('active', true),
        { name: 'ASC' },
        '0,20'
    )
    .execute();
```

### UPDATE — `update()`

```haxe
Jotun.gate.builder
    .update('users',
        Clause.EQUAL('id', 5),
        { name: 'Robert', email: 'robert@example.com' }
    )
    .execute();
```

### DELETE — `delete()`

```haxe
Jotun.gate.builder
    .delete('users', Clause.EQUAL('id', 5))
    .execute();
```

### COPY — `copy()`

Reads rows from one table and inserts them into another. Accepts an optional transform function.

```haxe
var copied:Array<Dynamic> = Jotun.gate.builder.copy(
    'users_archive', 'users',
    Clause.LESS('created_at', cutoffDate),
    function(row:Dynamic) {
        Reflect.deleteField(row, 'id');  // strip PK before insert
        return row;
    }
);
```

### TRUNCATE / RENAME

```haxe
Jotun.gate.builder.truncate('sessions').execute();
Jotun.gate.builder.rename('old_name', 'new_name').execute();
```

### Foreign Keys

```haxe
// Add FK
Jotun.gate.builder.fKey('orders', 'fk_orders_user', 'user_id', 'users', 'id', 'CASCADE', 'CASCADE').execute();

// Drop FK (omit key onwards)
Jotun.gate.builder.fKey('orders', 'fk_orders_user').execute();
```

---

## Clause — WHERE Conditions

`Clause` objects compose into arbitrarily complex WHERE expressions. All values are passed as `?` bind parameters.

### Simple Conditions

```haxe
Clause.EQUAL('status', 'active')        // status=?
Clause.DIFFERENT('role', 'admin')       // role!=?
Clause.LESS('age', 18)                  // age<?
Clause.LESS_OR('age', 18)              // age<=?
Clause.GREATER('score', 100)            // score>?
Clause.GREATER_OR('score', 100)         // score>=?
Clause.LIKE('name', '%alice%')          // name LIKE ?
Clause.NOT_LIKE('name', '%bot%')        // name NOT LIKE ?
Clause.ID(42)                           // id=?
Clause.TRUE('verified')                 // verified=?  (true)
Clause.FALSE('deleted')                 // deleted=?   (false)
Clause.IS_NULL('deleted_at')            // deleted_at IS NULL
Clause.NOT_NULL('email')                // email != NULL
Clause.REGEXP('slug', '^[a-z]+$')       // slug REGEXP ?
Clause.BETWEEN('age', 18, 65)           // age BETWEEN ? AND ?
Clause.NOT_BETWEEN('score', 0, 10)      // score NOT BETWEEN ? AND ?
Clause.IN('role', ['admin', 'mod'])     // role IN (?,?)
Clause.NOT_IN('status', ['banned'])     // status NOT IN (?)
```

### Bitfield Conditions

```haxe
Clause.FLAG('permissions', 4)           // permissions & ?
Clause.FLAG_NOT('permissions', 4)       // ~permissions & ?
Clause.FLAGS('permissions', [2, 4])     // all flags (AND)
Clause.FLAGS('permissions', [2, 4], true) // any flag (OR)
```

### Custom / Raw

```haxe
Clause.CUSTOM('created_at > NOW() - INTERVAL 7 DAY')   // raw SQL, no binding
```

### Composing with AND / OR

```haxe
var where:Clause = Clause.AND([
    Clause.EQUAL('active', true),
    Clause.OR([
        Clause.EQUAL('role', 'admin'),
        Clause.EQUAL('role', 'mod'),
    ]),
]);
// → (active=? && (role=? || role=?))

Jotun.gate.builder.find('*', 'users', where).execute();
```

---

## DataTable — Per-Table Helper

`Jotun.gate.table(name)` returns a `DataTable` instance (cached per name). It provides a higher-level CRUD API that handles boilerplate.

```haxe
var users:DataTable = Jotun.gate.table('users');

// INSERT
users.add({ name: 'Alice', email: 'alice@example.com' });

// INSERT multiple
users.addAll([
    { name: 'Bob' },
    { name: 'Carol' },
]);

// SELECT all
var result:ExtQuery = users.find();
var rows:Array<Dynamic> = result.data;   // or result.first()

// SELECT with clause and ordering
var result:ExtQuery = users.find(
    ['id', 'name'],
    Clause.EQUAL('active', true),
    { name: 'ASC' },
    '0,10'
);

// SELECT one
var user:Dynamic = users.findOne(null, Clause.ID(42));

// UPDATE
users.update({ name: 'Alice B.' }, Clause.ID(1));
users.updateOne({ score: 0 }, Clause.EQUAL('role', 'bot'));

// DELETE
users.delete(Clause.FALSE('active'));
users.deleteOne(Clause.ID(99));

// COUNT / EXISTS / SUM
var count:UInt = users.length();
var count:UInt = users.length(Clause.EQUAL('role', 'admin'));
var found:Bool = users.exists(Clause.ID(42));
var total:UInt = users.sum('score', Clause.EQUAL('active', true));

// CLEAR (TRUNCATE)
users.clear();

// RENAME
users.rename('members');
```

---

## JOIN Queries

Pass JOIN strings as additional table entries in `find()`:

```haxe
var b = Jotun.gate.builder;

var rows = users.findJoin(
    ['users.id as UID', 'users.name as NAME', 'city.name as CITY'],
    [
        b.leftJoin('user_address', Clause.CUSTOM('address.user_id=users.id')),
        b.leftJoin('location_city', Clause.CUSTOM('city.id=address.city_id')),
    ],
    Clause.EQUAL('users.active', true)
).data;
```

Available join types: `join`, `innerJoin`, `outerJoin`, `leftJoin`, `leftOuterJoin`, `rightOuterJoin`, `fullOuterJoin`.

---

## Schema Inspection

```haxe
// Column info for one or more tables
var cols:Array<Dynamic> = Jotun.gate.schema('users');
var cols:Array<Dynamic> = Jotun.gate.schema(['users', 'orders']);

// All table names in the database
var names:Array<String> = Jotun.gate.getTableNames();

// All DataTable objects
var tables:Dynamic = Jotun.gate.getTables();

// Check existence
if (Jotun.gate.ifTableExists('migrations')) { ... }

// Column-level info via DataTable
var info:Dynamic = users.getInfo();              // { id: Column, name: Column, ... }
var has:Bool     = users.hasColumn('email');
var autoInc:Int  = users.getAutoIncrement();
```

---

## Query Logging

```haxe
Jotun.gate.listen(function(sql:String) {
    trace('[SQL] ' + sql);
});
```

---

## Complete Example

```haxe
// 1. Connect
Jotun.gate.open(Token.localhost('shop'));

if (!Jotun.gate.isOpen()) {
    php.Lib.print('DB error');
    return;
}

// 2. Grab table references
var products:DataTable = Jotun.gate.table('products');
var orders:DataTable   = Jotun.gate.table('orders');

// 3. Read active products sorted by price
var items:Array<Dynamic> = products.find(
    ['id', 'name', 'price'],
    Clause.AND([
        Clause.TRUE('active'),
        Clause.GREATER('stock', 0),
    ]),
    { price: 'ASC' },
    '0,50'
).data;

// 4. Insert a new order
orders.add({
    user_id:    12,
    product_id: items[0].id,
    quantity:   2,
});
var orderId:Int = cast Jotun.gate.getInsertedID(null, 'int');

// 5. Join query — orders with user names
var report:Array<Dynamic> = orders.findJoin(
    ['orders.id', 'users.name', 'orders.quantity'],
    [ Jotun.gate.builder.leftJoin('users', Clause.CUSTOM('users.id=orders.user_id')) ],
    Clause.GREATER('orders.quantity', 0)
).data;
```

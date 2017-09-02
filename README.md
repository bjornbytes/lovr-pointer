lovr-pointer
===

A [LÖVR](http://lovr.org) library for pointing at objects in VR.

Example
---

```lua
pointer = require 'pointer'

function lovr.load()
  pointer:init({ source = lovr.headset })
end

function lovr.update()
  pointer:update()
end

function lovr.draw()
  local hit = pointer:getHit()

  if hit then
    lovr.graphics.sphere(hit.x, hit.y, hit.z, .05)
  end
end
```

See `main.lua` for an example supporting controllers and physics.

Usage
---

A pointer needs to have a **source** object passed to it when it's initialized.  A source can be any
table with `getPosition` and `getOrientation` functions, and it is used to determine the path of the
pointer.  You can point with a controller by passing it in as the source or even use lovr.headset
for gaze-based pointing.

By default, the pointer will cast a line straight out from its source and stop once the line either
hits the floor or reaches its maximum range (controlled using the `range` option).  You can also
tell the pointer to check for physics objects along its path by passing a `world` in to initialize.

Calling `getPath` on the pointer returns a list of points along its path.  This list can be passed
directly to `lovr.graphics.line` to draw the pointer's path.

Use `getHit` to get information about what the pointer hit.  This is a table with the following
fields:

- `x`, `y`, `z` - The position of the hit.
- `nx`, `ny`, `nz` - The normal vector of the hit.
- `collider` - The Collider that was hit, if any.

The hit table isn't always guaranteed to be there and may be `nil` if nothing was hit.

Be sure to call `update` on the pointer whenever you want to recompute the path and hit information.

You can call all of these functions on the library for convenience, but you can also use `new` to
create a self contained pointer object if you need multiple instances.

API
---

##### `Pointer:init(options)` or `Pointer.new(options)`

Initialize the library or create a new pointer object.  The following optional options are available:

- `source` - A table with `getPosition` and `getOrientation` functions used to do the pointing.
- `range` - The range of the pointer in meters.
- `world` - A physics World.  If present, the pointer will check for colliders along its path.

##### `:update()`

Update the pointer's path and hit information.  Returns the computed hit information (see `:getHit`).

##### `:getPath()`

Returns a table of positions along the pointer's path.

##### `:getHit()`

Returns information about the closest object hit during the last call to update:

- `x`, `y`, `z` - The position of the intersection point.
- `nx`, `ny`, `nz` - The normal vector of the intersection point.
- `collider` - The Collider that was hit, if any.

If nothing was hit, returns `nil`.

##### `:getSource()` and `:setSource(source)`

Get or set the current source for the pointer.  Sources are tables with `getPosition` and
`getOrientation` functions used to determine the pointer's path.

License
---

MIT, see [`LICENSE`](LICENSE) for details.

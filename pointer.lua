local pointer = {}
pointer.__index = pointer

local unpack = unpack or table.unpack

function pointer.new(options)
  local self = setmetatable({}, pointer)
  self:init(options)
  return self
end

function pointer:init(options)
  self.source = options and options.source
  self.range = options and options.range or 10
  self.world = options and options.world
  self.path = nil
  self.hit = nil
end

function pointer:update()
  if not self.source then return end

  local r = self.range
  local x, y, z = self.source:getPosition()
  local dx, dy, dz = quat(self.source:getOrientation()):direction():unpack()
  local tx, ty, tz = x + dx * r, y + dy * r, z + dz * r

  if self.world then
    local closest = math.huge

    self.hit = nil

    self.world:raycast(x, y, z, tx, ty, tz, function(shape, hx, hy, hz, nx, ny, nz)
      local distance = (x - hx) ^ 2 + (y - hy) ^ 2 + (z - hz) ^ 2

      if distance < closest then
        closest = distance
        tx, ty, tz = hx, hy, hz
        self.hit = { x = hx, y = hy, z = hz, nx = nx, ny = ny, nz = nz, collider = shape:getCollider() }
      end
    end)
  else
    local length = -y / dy

    if length > 0 and length <= r then
      tx, ty, tz = x + dx * length, y + dy * length, z + dz * length
      self.hit = { x = tx, y = ty, z = tz, nx = 0, ny = 1, nz = 0 }
    else
      self.hit = nil
    end
  end

  self.path = { x, y, z, tx, ty, tz }

  return self.hit
end

function pointer:getPath()
  return self.path
end

function pointer:getHit()
  return self.hit
end

function pointer:getSource()
  return self.source
end

function pointer:setSource(source)
  assert(source.getPosition and source.getOrientation, 'Pointer source needs getPosition and getOrientation functions')
  self.source = source
end

return pointer

pointer = require 'pointer'

local function drawBox(box, color)
  local x, y, z = box:getPosition()
  local dx, dy, dz = box:getShapeList()[1]:getDimensions()
  lovr.graphics.setColor(color)
  lovr.graphics.box('fill', x, y, z, dx, dy, dz, box:getOrientation())
end

local function refreshSource()
  pointer:setSource(lovr.headset.getControllers()[1] or lovr.headset)
end

function lovr.load()
  -- Make a little physics scene
  world = lovr.physics.newWorld()
  ground = world:newBoxCollider(0, 0, 0, 5, .001, 5)
  ground:setKinematic(true)
  box = world:newBoxCollider(0, 1, 0, .5)

  -- Initialize the pointer
  pointer:init({ source = lovr.headset, world = world })
end

function lovr.update(dt)
  pointer:update()
  world:update(dt)
end

function lovr.draw()
  local hit = pointer:getHit()

  drawBox(ground, { 30, 30, 30 })

  -- Highlight that darn box if we're pointing at it
  local boxColor = (hit and hit.collider == box) and { 50, 100, 200 } or { 20, 70, 170 }
  drawBox(box, boxColor)

  lovr.graphics.setColor(255, 255, 255)

  -- If we're pointing with a controller, draw a line showing the path
  if pointer:getSource() ~= lovr.headset then
    lovr.graphics.line(pointer:getPath())
  end

  -- If we're pointing at something, draw the intersection point and normal vector
  if hit then
    lovr.graphics.cube('fill', hit.x, hit.y, hit.z, .04)
    lovr.graphics.setColor(0, 255, 0)
    lovr.graphics.line(hit.x, hit.y, hit.z, hit.x + hit.nx * .1, hit.y + hit.ny * .1, hit.z + hit.nz * .1)
  end
end

lovr.controlleradded = refreshSource
lovr.controllerremoved = refreshSource

pointer = require 'pointer'

cubeSize = 0.2

local function drawCube(box, color)
  local x, y, z = box:getPosition()
  lovr.graphics.setColor(color)
  lovr.graphics.cube('fill', x, y, z, cubeSize)
end


function lovr.load()
  -- Make a little physics scene
  world = lovr.physics.newWorld()
  box = world:newBoxCollider(0, 1.5, -1, cubeSize)
  box:setKinematic(true)

  -- Initialize the pointer
  pointer:init({ source = pointer.handWrapper.new("hand/left"), world = world })
end

function lovr.update(dt)
  pointer:update()
  world:update(dt)
end

function lovr.draw()
  local hit = pointer:getHit()

  -- Highlight that darn box if we're pointing at it
  local boxColor = (hit and hit.collider == box) and { 0.50, 0.100, 0.200 } or { 0.20, 0.70, 0.170 }
  drawCube(box, boxColor)

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

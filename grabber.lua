
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  -- NEW: we'll want to keep track of the object (ie. card) we're holding
  grabber.heldObject = nil
  grabber.nearestStack = nil
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end  
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
end

function GrabberClass:release()
  if self.heldObject == nil then 
    return
  end
  
  local isValidReleasePosition = true
  
  if self.nearestStack == nil then
    isValidReleasePosition = false
  end

  if not isValidReleasePosition then
    self.heldObject.position = self.grabPos + self.heldObject.grabOffset
  else
    self.heldObject.position = self.nearestStack.cardPos
    table.insert(self.nearestStack.cardsHeld, self.heldObject)
  end
  
  self.nearestStack = nil
  self.heldObject.state = 0 
  self.heldObject = nil
  self.grabPos = nil
end

require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
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

function GrabberClass:checkValid()
  local isValid = false
  
  if self.nearestStack == nil then
    isValid = false
  elseif self.nearestStack.vers == 1 and #self.nearestStack.cardsHeld == 0 then
    if tonumber(self.heldObject.rank) == 1 then
      isValid = true
    end
  elseif self.nearestStack.vers == 1 then
    local stackCheck = self.nearestStack.cardsHeld[#self.nearestStack.cardsHeld]
    if (stackCheck.suit == self.heldObject.suit) and (tonumber(stackCheck.rank) == tonumber(self.heldObject.rank) - 1) then
      isValid = true
    end
  elseif #self.nearestStack.cardsHeld == 0 then
    if tonumber(self.heldObject.rank) == 13 then
      isValid = true
    end
  else
    local stackCheck = self.nearestStack.cardsHeld[#self.nearestStack.cardsHeld]
    if (stackCheck.color ~= self.heldObject.color) and (tonumber(stackCheck.rank) == tonumber(self.heldObject.rank) + 1) then
      isValid = true
    end
  end
  
  return isValid
end

function GrabberClass:release()
  if self.heldObject == nil then 
    return
  end
  
  local isValidReleasePosition = self:checkValid()

  if not isValidReleasePosition then
    self.heldObject.position = self.grabPos + self.heldObject.grabOffset
  else
    self.heldObject.position = self.nearestStack.cardPos
    table.insert(self.nearestStack.cardsHeld, self.heldObject)
    self.heldObject.curStack = self.nearestStack
  end
  
  self.nearestStack = nil
  self.heldObject.state = 0 
  self.heldObject = nil
  self.grabPos = nil
end


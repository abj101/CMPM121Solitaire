
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
  
  self.heldObject = {}
  
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
  
  -- BUG FIX prevents weird card snapping if empty space is clicked
  if #self.heldObject == 0 and not love.mouse.isDown(1) then
    self.grabPos = nil
  end
  
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end  
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
end

-- performs checks to enforce standard solitaire rules
function GrabberClass:checkValid(object)
  local isValid = false
  
  if self.nearestStack == nil then
    isValid = false
  elseif self.nearestStack.vers == 1 and #self.nearestStack.cardsHeld == 0 then
    if tonumber(object.rank) == 1 then
      isValid = true
    end
  elseif self.nearestStack.vers == 1 then
    local stackCheck = self.nearestStack.cardsHeld[#self.nearestStack.cardsHeld]
    if (stackCheck.suit == object.suit) and (tonumber(stackCheck.rank) == tonumber(object.rank) - 1) then
      isValid = true
    end
  elseif #self.nearestStack.cardsHeld == 0 then
    if tonumber(object.rank) == 13 then
      isValid = true
    end
  else
    local stackCheck = self.nearestStack.cardsHeld[#self.nearestStack.cardsHeld]
    if (stackCheck.color ~= object.color) and (tonumber(stackCheck.rank) == tonumber(object.rank) + 1) then
      isValid = true
    end
  end
  
  return isValid
end

-- releases held card from mouse position based on validation
function GrabberClass:release()
  if #self.heldObject == 0 then 
    return
  end
    
  local isValidReleasePosition = self:checkValid(self.heldObject[1])
  
  local n = 0
  print(#self.heldObject)
  for i, heldObject in ipairs(self.heldObject) do
    if not isValidReleasePosition then
      heldObject.position = self.grabPos + heldObject.grabOffset
    else
      heldObject.position = self.nearestStack.cardPos
      table.insert(self.nearestStack.cardsHeld, heldObject)
      heldObject.curStack = self.nearestStack
    end
    heldObject.curStack:update()
    heldObject.state = 0
  end
  
  self.nearestStack = nil
  self.heldObject = {}
  self.grabPos = nil
  print(#self.heldObject)

end


require "vector"
require "card"

StackClass = {}

Suits = {"C", "H", "D", "S"}

function StackClass:new(xpos, ypos, vers)
  local stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.position = Vector(xpos, ypos)
  stack.size = Vector(71, 95) * 1.5
  stack.center = stack.position + stack.size * .5
  
  -- 0 == normal, 1 == foundation, 2 == drawPile
  stack.vers = vers
  
  stack.cardsHeld = {}
  stack.cardPos = stack.position
  
  stack.base = love.graphics.newImage("Sprites/Card/base50.png")

  return stack
end

function StackClass:update()
    -- sets proper offset value for cards
    if self.vers ~= 1 then
      local offset = #self.cardsHeld * 37
      self.cardPos = self.position + Vector(0, offset)
    end
    
    -- makes sure a card can exist in only one stack at a time
    if self.vers == 2 then
      for i, card in ipairs(self.cardsHeld) do
        if i == #self.cardsHeld then
          card.noGrab = false
        else 
          card.noGrab = true
        end
      end
    end
    
    -- flips the latest card in a stack
    for i, card in ipairs(self.cardsHeld) do
      if i == #self.cardsHeld then
        card.flipped = 0
      end
      
      if card.curStack ~= self then
        table.remove(self.cardsHeld, i)
      end
      
    end
end

function StackClass:draw()

  love.graphics.draw(self.base, self.position.x, self.position.y, 0, 1.5,1.5)
  
end

-- checks if a card is nearbyl and updates the nearest stack value for grabber release functionality
function StackClass:checkForCard(grabber)
  if grabber.heldObject[1] == nil  or self.vers == 2 then 
    return false 
  end
  
  local card = grabber.heldObject[1].position
  local cardCenter = card + self.size * .5
  if math.abs(cardCenter.x - self.center.x) < (self.size.x * .5 + 2.5) and math.abs(cardCenter.y - self.center.y) < (self.size.y * .5 + 2.5 + (#self.cardsHeld * 37)) then
    return true
  else
    return false
  end
  
end
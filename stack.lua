require "vector"
require "card"

StackClass = {}

Suits = {"C", "H", "D", "S"}

function StackClass:new(xpos, ypos)
    local stack = {}
    local metadata = {__index = StackClass}
    setmetatable(stack, metadata)

    stack.position = Vector(xpos, ypos)
    stack.size = Vector(71, 95) * 1.5
    stack.center = stack.position + stack.size * .5
    
    stack.isFoundation = 0
    stack.suit = Suits[1]
    
    stack.cardsHeld = {}
    stack.cardPos = stack.position


    return stack
end

function StackClass:update()
    local offset = #self.cardsHeld * 37
    self.cardPos = self.position + Vector(0, offset)
    
    for i, card in ipairs(self.cardsHeld) do
      local cardCenter = card.position + self.size * .5
      if math.abs(cardCenter.x - self.center.x) > 1 or math.abs(cardCenter.y - self.center.y) > 1 then
        table.remove(self.cardsHeld, i)
        offset = #self.cardsHeld * 37
        self.cardPos = self.position + Vector(0, offset)
      end
    end
    

end

function StackClass:draw()
  local base = love.graphics.newImage("Sprites/Card/base50.png")
  love.graphics.draw(base, self.position.x, self.position.y, 0, 1.5,1.5)
  
  love.graphics.print(tostring(self.cardPos.y), self.position.x + 40, self.position.y - 20)
end

function StackClass:checkForCard(grabber)
  if grabber.heldObject == nil then return false end
  
  local cardPos = grabber.heldObject.position
  local cardCenter = cardPos + self.size * .5
  if math.abs(cardCenter.x - self.center.x) < (self.size.x * .5 + 2.5) and math.abs(cardCenter.y - self.center.y) < (self.size.y * .5 + 2.5) then
    return true
  else
    return false
  end
  
end
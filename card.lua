
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

function CardClass:new(xPos, yPos, sprite)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.scale = 1.5
  card.size = Vector(71, 95) * 1.5
  card.state = CARD_STATE.IDLE
  card.flipped = 1
  card.grabOffset = Vector(0, 0)  
  card.back = love.graphics.newImage("Sprites/Card/Backs/redBack.png")
  card.base = love.graphics.newImage("Sprites/Card/CardBase.png")
  card.card = love.graphics.newImage("Sprites/Card/Faces/" .. sprite .. ".png")

  
  return card
end

function CardClass:update()
  
  currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
    
  if self.state == 2 then
    self.position = currentMousePos + self.grabOffset
  end
  
end

function CardClass:draw()
  -- NEW: drop shadow for non-idle cards
  if self.state ~= CARD_STATE.IDLE then
    love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  
  if self.flipped == 1 then
    love.graphics.draw(self.base, self.position.x, self.position.y, 0, 1.5,1.5)
    love.graphics.draw(self.card, self.position.x, self.position.y, 0, 1.5,1.5)  
  else
    love.graphics.draw(self.back, self.position.x, self.position.y, 0, 1.5,1.5)
  end
  
  
  love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED or grabber.heldObject ~= nil then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

function CardClass:checkGrabbed(grabber)
  if self.state ~= CARD_STATE.MOUSE_OVER or grabber.heldObject ~= nil then
    return
  end
  
  if grabber.grabPos ~= nil then
    self.state = 2
    self.grabOffset = self.position - grabber.grabPos
    print("grabbed")
  end
end
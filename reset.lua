require "vector"

ResetClass = {}

function ResetClass:new(xPos, yPos)
  local reset = {}
  local metadata = {__index = ResetClass}
  setmetatable(reset, metadata)
  
  reset.position = Vector(xPos, yPos)
  reset.size = Vector(95, 75)
  reset.hover = false
    
  return reset
end

function ResetClass:click(mx, my)
  local isOver =
    mx > self.position.x and
    mx < self.position.x + self.size.x and
    my > self.position.y and
    my < self.position.y + self.size.y

  if isOver then
    self:reset()
  end
end

function ResetClass:checkForMouseOver(grabber)
  if #grabber.heldObject ~= 0 then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  if isMouseOver then
    self.hover = true
  else
    self.hover = false
  end 

end

function ResetClass:reset()
  cardTable = {}
  deckTable = {}
  stackTable = {}
  
  counter = 1
  gameWon = false
  
  deckSetup()

  shuffle(deckTable)
  
  tableauSetup()
  
  foundationSetup()
  
  deckCards()
end

function ResetClass:draw()
  if self.hover then
    love.graphics.setColor(0, 0, 0, 0.8) 
    local offset = 4
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  love.graphics.setColor(1, 1, 1) 
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6) 
  love.graphics.setColor(0, 0, 0) 
  love.graphics.print("RESET", self.position.x + 23, self.position.y + 28, 0, 1.2, 1.2)
  love.graphics.setColor(1, 1, 1)
end

require "vector"
require "card"

DeckClass = {}

function DeckClass:new(xPos, yPos)
  local deck = {}
  local metadata = {__index = DeckClass}
  setmetatable(deck, metadata)
  
  deck.position = Vector(xPos, yPos)
  deck.scale = 1.5
  deck.size = Vector(71, 95) * deck.scale
  
  deck.sprite = love.graphics.newImage("Sprites/Card/Backs/redBack.png")
  deck.base = love.graphics.newImage("Sprites/Card/CardBase.png")
  deck.empty = love.graphics.newImage("Sprites/Card/base50.png")
  deck.refresh = love.graphics.newImage("Sprites/UI/refresh.png")
  
  deck.discardTable = {}

  return deck
end

function DeckClass:click(mx, my)
  local isOver =
    mx > self.position.x and
    mx < self.position.x + self.size.x and
    my > self.position.y and
    my < self.position.y + self.size.y

  if isOver then
    self:drawThree()
  end
end

-- Draws three cards when the deck is clicked
function DeckClass:drawThree()
  
  if #physDrawPile.cardsHeld > 0 then
    for i, card in ipairs(physDrawPile.cardsHeld) do
      table.insert(self.discardTable, card)
      card.curStack = self.discardTable
      card.position = Vector(-200, 200)
    end
    
    physDrawPile.cardsHeld = {}
  end
  
  if #deckTable == 0 then
    deckTable = self.discardTable
    self.discardTable = {}
  end
  
  local drawLen = math.min(3, #deckTable)
  
  for i = 1, drawLen do
    local card = table.remove(deckTable, 1)
    table.insert(cardTable, card)
    
    physDrawPile:update()
    
    card.position = physDrawPile.cardPos
    table.insert(physDrawPile.cardsHeld, card)
    card.curStack = physDrawPile
  end

end

function DeckClass:draw()
  if #deckTable == 0 then
    love.graphics.draw(self.empty, self.position.x, self.position.y, 0, 1.5,1.5)  
    love.graphics.draw(self.refresh, self.position.x + 78, self.position.y + 45, 0, -.2, .2)  
  else
    love.graphics.draw(self.base, self.position.x , self.position.y , 0, 1.5,1.5)
    love.graphics.draw(self.base, self.position.x - 3, self.position.y - 3, 0, 1.5,1.5)
    love.graphics.draw(self.sprite, self.position.x - 6, self.position.y - 6, 0, 1.5,1.5)  
  end
end
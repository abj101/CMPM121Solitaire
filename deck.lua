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
  
  
  deck.drawPile = {}
  deck.discardTable = {}

  return deck
end

function DeckClass:update()
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

function DeckClass:drawThree()
  
  if #self.drawPile > 0 then
    for _, card in ipairs(self.drawPile) do
      table.insert(self.discardTable, card)
    end
    self.drawPile = {}
    
    for i, card in ipairs(cardTable) do
      if card.curStack == physDrawPile then
        card.position = Vector(300 + i * 10, 300)
        card.curStack = nil
        table.remove(cardTable, i)
      end
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
    table.insert(self.drawPile, card)
    table.insert(cardTable, card)
    
    physDrawPile:update()
    
    card.position = physDrawPile.cardPos
    table.insert(physDrawPile.cardsHeld, card)
    card.curStack = physDrawPile
  end

end

function DeckClass:draw()
  love.graphics.draw(self.base, self.position.x + 3, self.position.y + 3, 0, 1.5,1.5)
  love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, 1.5,1.5)  
end
-- Ayush Bandopadhyay
-- CMPM 121
-- 4/16/2025
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"
require "deck"

math.randomseed(os.time())

function love.load()
  love.window.setTitle("Solitaire")
  screenWidth = 1280
  screenHeight = 720
  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  deckTable = {}
  stackTable = {}
  
  -- Setup Vars
  scale = 1.5
  cardWidth = 71 * scale
  cardHeight = 95 * scale
  gap = 5  
  yAlign = 100
  hoverCard = grabber.hoverObjects
  
  counter = 1
  
  physDeck = DeckClass:new(180 - cardWidth, yAlign)
  physDrawPile = StackClass:new(180 - cardWidth, yAlign + cardHeight + 30, 2)
  
  -- Table Setup Functions
  deckSetup()

  shuffle(deckTable)
  
  tableauSetup()
  
  foundationSetup()
  
  deckCards()

end

function deckSetup()
  -- enums
  local suits = {"C", "D", "H", "S"}
  for suit_i = 1, 4 do
    for rank = 1, 13 do
      table.insert(deckTable, tostring(suits[suit_i] .. tostring(rank)))
    end
  end
end

function shuffle()
  local count = #deckTable
  for i = 1, count do
    local rand = math.random(count)
    local temp = table.remove(deckTable, rand)
    table.insert(deckTable, temp)
    count = count - 1
  end
end

function deckCards()
  
  local temp = {}
  
  for i = 1, #deckTable do
    local card = table.remove(deckTable, 1)
    table.insert(temp, CardClass:new(-200, 0, card, 0))
  end
  
  deckTable = temp
  temp = {}
end

function tableauSetup()
  local totalWidth = 7 * cardWidth + 6 * gap
  
  local startX = (screenWidth - totalWidth) / 2
  
  for i = 1, 7 do
    local x = startX + (i - 1) * (cardWidth + gap)
    table.insert(stackTable, StackClass:new(x, yAlign, 0))
    for j = 1, i do
      local flipped = 0
      
-- uncomment after debug
      if j == i then 
        flipped = 0 
      else
        flipped = 1
      end
      
      drawnCard = table.remove(deckTable, 1)
      table.insert(cardTable, CardClass:new(x, yAlign + 37 * (j-1), drawnCard, flipped))
      
      table.insert(stackTable[i].cardsHeld, cardTable[#cardTable])
      cardTable[#cardTable].curStack = stackTable[i]
    end
  end
  
  table.insert(stackTable, physDrawPile)
end

function foundationSetup()

  for i = 1, 4 do
    local y = yAlign + (i - 1) * (cardHeight + gap)
    table.insert(stackTable, StackClass:new(1100, y, 1))
  end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then   -- 1 == left mouse button
        physDeck:click(x, y)
    end
end


function love.update()
  require("lovebird").update()
  grabber:update()
  physDeck:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
  
  for _, stack in ipairs(stackTable) do
    stack:update()
  end
  
end

function love.draw()
  
  physDeck:draw()
  
  for _, stack in ipairs(stackTable) do
    stack:draw()
  end
  
  for _,card in ipairs(cardTable) do
    card:draw()
  end
  
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for i, card in ipairs(cardTable) do    
    card:checkForMouseOver(grabber)
    if #hoverCard == 0 then
      table.insert(hoverCard, card)
    elseif card.state == 0 and hoverCard[1] == card then
      table.remove(hoverCard, 1)
    elseif card.state == 1 and hoverCard[1] ~= card then
      card.state = 0
    end
    
    card:checkGrabbed(grabber)
    if card.state == 2 then
      grabber.heldObject = card
      local temp = table.remove(cardTable, i)
      table.insert(cardTable, temp)
    end
  end
  
  for _, stack in ipairs(stackTable) do
    if stack:checkForCard(grabber) then
      grabber.nearestStack = stack
    end
  end
end
-- Ayush Bandopadhyay
-- CMPM 121
-- 4/16/2025
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"
require "deck"
require "reset"

math.randomseed(os.time())

function love.load()
  love.window.setTitle("Solitaire")
  screenWidth = 1280
  screenHeight = 720
  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  
  -- Setup Vars
  scale = 1.5
  cardWidth = 71 * scale
  cardHeight = 95 * scale
  gap = 5  
  yAlign = 100
  
  physDeck = DeckClass:new(180 - cardWidth, yAlign)
  physDrawPile = StackClass:new(180 - cardWidth, yAlign + cardHeight + 30, 2)
  resetButton = ResetClass:new(180 - cardWidth, screenHeight - 180)
  
  -- Table Setup 
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

-- Sets up deck by populating it with all the suits and ranks
function deckSetup()
  local suits = {"C", "D", "H", "S"}
  for suit_i = 1, 4 do
    for rank = 1, 13 do
      table.insert(deckTable, tostring(suits[suit_i] .. tostring(rank)))
    end
  end
end

-- Shuffles all the cards in deck 
function shuffle()
  local count = #deckTable
  for i = 1, count do
    local rand = math.random(count)
    local temp = table.remove(deckTable, rand)
    table.insert(deckTable, temp)
    count = count - 1
  end
end

-- Populates deck witha actual card objects
function deckCards()
  
  local temp = {}
  
  for i = 1, #deckTable do
    local card = table.remove(deckTable, 1)
    table.insert(temp, CardClass:new(-200, 0, card, 0))
  end
  
  deckTable = temp
  temp = {}
end

-- Sets up the tableaus and populates them with drawn cards
function tableauSetup()
  local totalWidth = 7 * cardWidth + 6 * gap
  
  local startX = (screenWidth - totalWidth) / 2
  
  for i = 1, 7 do
    local x = startX + (i - 1) * (cardWidth + gap)
    table.insert(stackTable, StackClass:new(x, yAlign, 0))
    for j = 1, i do
      local flipped = 0
      
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

-- sets up the 4 foundation on the right
function foundationSetup()

  for i = 1, 4 do
    local y = yAlign + (i - 1) * (cardHeight + gap)
    table.insert(stackTable, StackClass:new(1100, y, 1))
  end
end

-- Checks for clicks
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then   -- 1 == left mouse button
        physDeck:click(x, y)
        resetButton:click(x, y)
    end
end

-- Checks for win condition
function checkWin()
  if #deckTable == 0 and #physDrawPile.cardsHeld == 0 and #physDeck.discardTable == 0 then
    gameWon = true
  end
end

function love.update()
  require("lovebird").update()
  grabber:update()
  
  checkForMouseMoving()  
  
  checkWin()
  
  for i, card in ipairs(cardTable) do
    card:update()
  end
  
  for _, stack in ipairs(stackTable) do
    stack:update()
  end
  
end

function love.draw()
  
  physDeck:draw()
  resetButton:draw()
  
  for _, stack in ipairs(stackTable) do
    stack:draw()
  end
  
  for _,card in ipairs(cardTable) do
    card:draw()
  end
  
  if gameWon then
    print("Game Won!")
    love.graphics.print("GAME WON!", screenWidth/2, screenHeight/2)
  end
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  local buffer = cardTable
  
  for i, card in ipairs(cardTable) do    
    
    card:checkForMouseOver(grabber)
    resetButton:checkForMouseOver(grabber)
    
    -- checks for grabbing and grabbing entire stacks
    if #grabber.heldObject == 0 then
      card:checkGrabbed(grabber)
      if card.state == 2 then
        local found = 100
        for j, obj in ipairs(card.curStack.cardsHeld) do
          if obj == card then
            found = j
            table.insert(grabber.heldObject, obj)
          end
          if j > found then
            obj.state = 3
            obj.grabOffset = obj.position - grabber.grabPos
            table.insert(grabber.heldObject, obj)
          end
        end
      end
    end
  end
    
  -- New reordering functionality to fix flickering 
  for i, card in ipairs(cardTable) do
    for _, card2 in ipairs(grabber.heldObject) do
      if card == card2 then
        table.remove(cardTable, i)
      end
    end
  end
  for i, card in ipairs(grabber.heldObject) do
    table.insert(cardTable, card) 
  end
  
  
  for _, stack in ipairs(stackTable) do
    if stack:checkForCard(grabber) then
      grabber.nearestStack = stack
    end
  end
end
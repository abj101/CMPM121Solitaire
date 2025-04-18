-- Ayush Bandopadhyay
-- CMPM 121
-- 4/16/2025
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"

function love.load()
  love.window.setTitle("Solitaire")
  love.window.setMode(1280, 720)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  deck = {}
  stackTable = {}
  
  -- Setup Vars
  cardWidth = 71 * 1.5 
  cardHeight = 95 * 1.5
  gap = 5   
  yAlign = 100
  
  -- Table Setup Functions
  tableauSetup()
  
  foundationSetup()
  
  deckSetup()
  
  for i = 1, 13 do
    table.insert(cardTable, CardClass:new(100, 100 + 30 * (i-1), deck[i]))
  end

end

function tableauSetup()
  local totalWidth = 7 * cardWidth + 6 * gap
  
  local startX = (1280 - totalWidth) / 2
  
  for i = 1, 7 do
    local x = startX + (i - 1) * (cardWidth + gap)
    table.insert(stackTable, StackClass:new(x, yAlign))
  end
end

function foundationSetup()
  for i = 1, 4 do
    local y = yAlign + (i - 1) * (cardHeight + gap)
    table.insert(stackTable, StackClass:new(1100, y))
  end
end

function deckSetup()
  local suits = {"C", "D", "H", "S"}
  for suit_i = 1, 4 do
    for rank = 1, 13 do
      table.insert(deck, suits[suit_i] .. tostring(rank))
    end
  end
end

function love.update()
  require("lovebird").update()
  grabber:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
  
  for _, stack in ipairs(stackTable) do
    stack:update()
  end
end

function love.draw()
  for _, stack in ipairs(stackTable) do
    stack:draw()
  end
  
  for _, card in ipairs(cardTable) do
    card:draw() --card.draw(card)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
    card:checkGrabbed(grabber)
    if card.state == 2 then
      grabber.heldObject = card
    end
  end
  
  for _, stack in ipairs(stackTable) do
    if stack:checkForCard(grabber) then
      grabber.nearestStack = stack
    end
  end
end
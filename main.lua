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
  stackTable = {}
  
  table.insert(cardTable, CardClass:new(100, 100))
  table.insert(stackTable, StackClass:new(200, 200))
  
end
function love.update()
  require("lovebird").update()
  grabber:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
end
function love.draw()
  for _, card in ipairs(cardTable) do
    card:draw() --card.draw(card)
  end

  for _, stack in ipairs(stackTable) do
    stack:draw()
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
  end
end
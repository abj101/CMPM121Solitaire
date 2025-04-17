require "vector"
require "card"

StackClass = {}

function StackClass:new(xpos, ypos)
    local stack = {}
    local metadata = {__index = StackClass}
    setmetatable(stack, metadata)

    stack.position = Vector(xpos, ypos)

    return stack
end

function StackClass:update()
    
end

function StackClass:draw()
    local base = love.graphics.newImage("Sprites/Card/base50.png")
    love.graphics.draw(base, self.position.x, self.position.y)
end


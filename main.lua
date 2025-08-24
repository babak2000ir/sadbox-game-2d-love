if arg[2] == "debug" then
    require("lldebugger").start()
end

local ninja = {}
local lastKeyMessage = ""

function love.load()
   ninja.image = love.graphics.newImage("assets/Characters/NinjaFrog/Fall (32x32).png")
   ninja.imgx = 100 -- starting X position
   ninja.imgy = 100 -- starting Y position
   ninja.scale = 4  -- scale factor for the image
   ninja.speed = 100
   love.graphics.setNewFont(18)
   love.graphics.setBackgroundColor(255, 255, 255)
end

function love.update(dt)
   if love.keyboard.isDown("left") then
      ninja.imgx = ninja.imgx - ninja.speed * ninja.scale * dt
   end
   if love.keyboard.isDown("right") then
      ninja.imgx = ninja.imgx + ninja.speed * ninja.scale * dt
   end
   if love.keyboard.isDown("up") then
      ninja.imgy = ninja.imgy - ninja.speed * ninja.scale * dt
   end
   if love.keyboard.isDown("down") then
      ninja.imgy = ninja.imgy + ninja.speed * ninja.scale * dt
   end
end

function love.draw()
   love.graphics.setColor(1, 1, 1, 1)                                                   -- Reset to white (no tinting)
   love.graphics.draw(ninja.image, ninja.imgx, ninja.imgy, 0, ninja.scale, ninja.scale) -- draw image at imgx, imgy with no rotation and scaled to 2x size
   love.graphics.setColor(0, 0, 0)
   love.graphics.print("Click and drag ninja-frog around or use the arrow keys", 10, 10)
   love.graphics.print(lastKeyMessage, 10, 30) 
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
      ninja.imgx = x - (ninja.image:getWidth() * ninja.scale) / 2
      ninja.imgy = y - (ninja.image:getHeight() * ninja.scale) / 2
   end
end

function love.mousemoved(x, y, dx, dy, istouch)
   if love.mouse.isDown(1) then
      ninja.imgx = x - (ninja.image:getWidth() * ninja.scale) / 2
      ninja.imgy = y - (ninja.image:getHeight() * ninja.scale) / 2
   end
end

function love.keypressed(key)
   love.graphics.setColor(0, 0, 0)
   lastKeyMessage = string.format("The key %s was pressed.", key)
end

function love.keyreleased(key)
   love.graphics.setColor(0, 0, 0)
   lastKeyMessage = string.format("The key %s was released.", key)
end

function love.quit()
   love.graphics.setColor(0, 0, 0)
   print("Thanks for playing! Come back soon!")
end

--[[
function love.mousereleased(x, y, button, istouch)
   if button == 1 then
      fireSlingshot(x,y) -- this totally awesome custom function is defined elsewhere
   end
end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
  else
    print("GAINED FOCUS")
  end
end


]]

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

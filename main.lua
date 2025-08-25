if arg[2] == "debug" then
   require("lldebugger").start()
end

local tick
local ninja
local head
local lastKeyMessage = ""
local headDistx = 0
local headDisty = 0
local collided = false

function love.load()
   Object = require "classic"
   tick = require "tick"
   local Sprite = require "sprite"

   ninja = Sprite("characters/NinjaFrog/Fall (32x32).png", 100, 100, 4, 100)
   head = Sprite("scenery/Rock Head/Idle.png", 300, 100, 5, 30)

   love.graphics.setNewFont(18)
   love.graphics.setBackgroundColor(255, 255, 255)

   tick.recur(function()
      headDistx = math.random(-1, 1)
      headDisty = math.random(-1, 1)
   end, 1)
end

function checkCollision(spritea, spriteb)
   --With locals it's common usage to use underscores instead of camelCasing
   local a_left = spritea.imgx
   local a_right = spritea.imgx + spritea:getWidth()
   local a_top = spritea.imgy
   local a_bottom = spritea.imgy + spritea:getHeight()

   local b_left = spriteb.imgx
   local b_right = spriteb.imgx + spriteb:getWidth()
   local b_top = spriteb.imgy
   local b_bottom = spriteb.imgy + spriteb:getHeight()

   --Directly return this boolean value without using if-statement
   return a_right > b_left
       and a_left < b_right
       and a_bottom > b_top
       and a_top < b_bottom
end

function love.update(dt)
   ninja:update(dt)
   head:update(dt)
   tick.update(dt)

   if love.keyboard.isDown("left") then
      ninja:movex(-1)
   end

   if love.keyboard.isDown("right") then
      ninja:movex(1)
   end

   if love.keyboard.isDown("up") then
      ninja:movey(-1)
   end

   if love.keyboard.isDown("down") then
      ninja:movey(1)
   end

   head:movex(headDistx)
   head:movey(headDisty)
   collided = checkCollision(ninja, head)
end

function love.draw()
   love.graphics.setColor(1, 1, 1, 1)
   head:draw()
   ninja:draw()
   if collided then
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", head.imgx, head.imgy, head:getWidth(), head:getHeight())
      love.graphics.rectangle("line", ninja.imgx, ninja.imgy, ninja:getWidth(), ninja:getHeight())
   end
   love.graphics.setColor(0, 0, 0)
   love.graphics.print("Click and drag ninja-frog around or use the arrow keys", 10, 10)
   love.graphics.print(lastKeyMessage, 10, 30)
   if collided then
      love.graphics.print("Collision!", 10, 50)
   end
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

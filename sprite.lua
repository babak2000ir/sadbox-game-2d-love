local Sprite = Object:extend()

--Lua turns this into: Rectangle.new(self)
function Sprite:new(asset, x, y, scale, speed, collisionBox)
    self.image = love.graphics.newImage("assets/" .. asset)
    self.imgx = tonumber(x) or 0
    self.imgy = tonumber(y) or 0
    self.scale = tonumber(scale) or 2 -- scale factor for the image
    self.speed = tonumber(speed) or 100
    self.collisionBox = collisionBox or { x = 0, y = 0, w = self.image:getWidth(), h = self.image:getHeight() }
end

function Sprite:getCurrentCollisionBox()
    return {
        x1 = self.imgx + (self.collisionBox.x * self.scale),
        y1 = self.imgy + (self.collisionBox.y * self.scale),
        x2 = self.imgx + (self.collisionBox.x + self.collisionBox.w) * self.scale,
        y2 = self.imgy + (self.collisionBox.y + self.collisionBox.h) * self.scale
    }
end

function Sprite:update(dt)
    self.dt = dt
end

function Sprite:draw()
    love.graphics.draw(self.image, self.imgx, self.imgy, 0, self.scale, self.scale)
end

function Sprite:drawCollisionBox()
    local currentCollisionBox = self:getCurrentCollisionBox()
    love.graphics.rectangle("line", 
        currentCollisionBox.x1, 
        currentCollisionBox.y1,
        currentCollisionBox.x2 - currentCollisionBox.x1, 
        currentCollisionBox.y2 - currentCollisionBox.y1)
end

function Sprite:canmovex(distance)
    if distance < 0 and self.imgx > 0 then
        return true
    end
    if distance > 0 and self.imgx < love.graphics.getWidth() - self.image:getWidth() * self.scale then
        return true
    end
    return false
end

function Sprite:canmovey(distance)
    if distance < 0 and self.imgy > 0 then
        return true
    end
    if distance > 0 and self.imgy < love.graphics.getHeight() - self.image:getHeight() * self.scale then
        return true
    end
    return false
end

function Sprite:movex(distance)
    if self:canmovex(distance) then
        self.imgx = self.imgx + self.speed * self.scale * self.dt * distance
    end
end

function Sprite:movey(distance)
    if self:canmovey(distance) then
        self.imgy = self.imgy + self.speed * self.scale * self.dt * distance
    end
end

function Sprite:checkCollision(spritea, spriteb)
   --With locals it's common usage to use underscores instead of camelCasing
   local cb1 = spritea:getCurrentCollisionBox()
   local cb2 = spriteb:getCurrentCollisionBox()

   return cb1.x2 > cb2.x1
       and cb1.x1 < cb2.x2
       and cb1.y2 > cb2.y1
       and cb1.y1 < cb2.y2
end

return Sprite

Sprite = Object:extend()

--Lua turns this into: Rectangle.new(self)
function Sprite:new(asset, x, y, scale, speed)
    self.image = love.graphics.newImage("assets/" .. asset)
    self.imgx = tonumber(x) or 0
    self.imgy = tonumber(y) or 0
    self.scale = tonumber(scale) or 2 -- scale factor for the image
    self.speed = tonumber(speed) or 100
end

function Sprite:update(dt)
    self.dt = dt
end

function Sprite:draw()
    love.graphics.draw(self.image, self.imgx, self.imgy, 0, self.scale, self.scale)
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

return Sprite

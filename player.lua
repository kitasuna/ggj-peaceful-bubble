-- Player movement. Requires bcirc.lua.

-- bcirc bounds
function player(bounds)
  return {
    bounds=bounds,
    prevx=-128,
    prevx=-128,
    points=0,
    update=function(self)
      local left = 0
      local right = 1
      local up = 2
      local down = 3

      if self.bounds.pos != nil then
        self.prevx = self.bounds.pos.x
        self.prevy = self.bounds.pos.y
      end

      if btn(up) then
        self.bounds.pos.y -= 1
      elseif btn(down) then
        self.bounds.pos.y += 1
      end

      if btn(left) then
        self.bounds.pos.x -= 1
      elseif btn(right) then
        self.bounds.pos.x += 1
      end
    end,
    draw=function(self)
      -- circfill(self.bounds.pos.x, self.bounds.pos.y, self.bounds.radius, 12)
      if (self.prevx != self.bounds.pos.x or self.prevy != self.bounds.pos.y) and (self.prevx != nil and self.prevy != nil) then
        if rnd() > 0.5 then
          circ(self.prevx+4, self.prevy+4, 4, 7)
        end
      end
      spr(1, self.bounds.pos.x, self.bounds.pos.y)

    end,
    die=function(self)
      sfx(0)
    end,
  }
end

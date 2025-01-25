-- Player movement. Requires bcirc.lua.

-- bcirc bounds
function player(bounds)
  return {
    bounds=bounds,
    update=function(self)
      local left = 0
      local right = 1
      local up = 2
      local down = 3

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
      circfill(self.bounds.pos.x, self.bounds.pos.y, self.bounds.radius, 12)
    end,
    die=function(self)
      sfx(0)
    end,
  }
end

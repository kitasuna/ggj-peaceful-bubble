-- Player movement. Requires bcirc.lua.

-- bcirc bounds
function player(bounds)
  return {
    bounds=bounds,
    trail=v2(0,0),
    points=0,
    t=0,
    update=function(self)
      local left = 0
      local right = 1
      local up = 2
      local down = 3

      if btn(up) then
        self.bounds.pos.y -= 1
        self.trail.y = min(3, self.trail.y + 1.5)
      elseif btn(down) then
        self.bounds.pos.y += 1
        self.trail.y = max(-2, self.trail.y - 0.5)
      end

      if btn(left) then
        self.bounds.pos.x -= 1
        self.trail.x = min(3, self.trail.x + 1.5)
      elseif btn(right) then
        self.bounds.pos.x += 1
        self.trail.x = max(-2, self.trail.x - 0.5)
      end
      self.trail *= 0.8
      self.t += 1
    end,
    draw=function(self)
      -- circfill(self.bounds.pos.x, self.bounds.pos.y, self.bounds.radius, 12)
      --[[
      if (self.prevx != self.bounds.pos.x or self.prevy != self.bounds.pos.y) and (self.prevx != nil and self.prevy != nil) then
        if rnd() > 0.5 then
          circ(self.prevx+4, self.prevy+4, 4, 7)
        end
      end
      ]]
      local x = self.bounds.pos.x
      local y = self.bounds.pos.y
      local t = self.t
      local r = 4
      local rf = function(t) return 0.5+sin(cos(t/400)) end
      circ(x+r+self.trail.x,y+r+self.trail.y,r+rf(t-5),11)
      if t%2 == 0 then
        circ(x+r+self.trail.x/2,y+r+self.trail.y/2,r+rf(t-2),1)
      else
        circ(x+r+self.trail.x/2,y+r+self.trail.y/2,r+rf(t-2),3)
      end
      circ(x+r,y+r,r+rf(t),2)
      spr(17, x-rf(t)/2, y-rf(t)/2)
      -- spr(1, self.bounds.pos.x, self.bounds.pos.y)

    end,
    die=function(self)
      sfx(0)
    end,
  }
end

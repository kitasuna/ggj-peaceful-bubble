function wobubble()
  return {
    t=0,
    trail=v2(0,0),
    update=function(self, dx, dy)
      if dy < 0 then
        self.trail.y = min(3, self.trail.y + 1.5)
      elseif dy > 0 then
        self.trail.y = max(-2, self.trail.y - 0.5)
      end
      if dx < 0 then
        self.trail.x = min(3, self.trail.x + 1.5)
      elseif dx > 0 then
        self.trail.x = max(-2, self.trail.x - 0.5)
      end
      self.trail *= 0.8
      self.t += 1
    end,
    draw=function(self, pos, r)
      local t = self.t
      if self.size == "big" then
        r = 8
      end
      local function draw_layer(p, r, c)
        -- How great is the trail's X magnitude relative to the Y?
        local x_winning = (2+abs(self.trail.x) - abs(self.trail.y))/5 - 0.5;
        local xr = r * (1 + x_winning/2)
        local yr = r * (1 - x_winning/2)
        oval(p.x - xr, p.y - yr, p.x + xr, p.y + yr, c)
      end
      local rf = function(t)
        return r/4*(0.5+sin(cos(t/400)))
      end
      draw_layer(pos + self.trail, r+rf(t-5),11)
      if t%2 == 0 then
        draw_layer(pos + 0.5*self.trail, r+rf(t-2),1)
      else
        draw_layer(pos + 0.5*self.trail, r+rf(t-2),3)
      end
      -- Draw the oil spot before the top layer.
      local dr = r+rf(t)
      spr(17, pos.x-0.7*dr, pos.y-0.7*dr)
      draw_layer(pos,dr,2)
    end,
  }
end

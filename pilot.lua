function new_pilot(bounds, velvec, velttl)
  local pilot = {
    t=0,
    start_pos=bounds.pos,
    end_pos=bounds.pos+v2(0,60),
    draw = function(self)
      -- draw ship
      spr(198, self.pos.x-24, self.pos.y+8, 2, 2)
      -- draw pilot
      spr(200, self.pos.x-2, self.pos.y-self.offsets[self.current_offset]-2, 1, 1)
    end,
    vel = velvec,
    velttl = velttl,
    offsets={0,1,2,3,2,1,0,-1},
    current_offset=1,
    current_offsetttl=0.1,
    -- used to reset the ttl after pos change
    offsetttl=0.8,
    update = function(self, dt)
      self.t += 1
      self.pos = sine_ease(self.start_pos, self.end_pos, self.t/400)

      self.current_offsetttl -= dt
      if self.current_offsetttl <= 0 then
        self.current_offsetttl = self.offsetttl
        self.current_offset += 1 
        if self.current_offset > #self.offsets then
          self.current_offset = 1
        end
      end
    end,
  }
  return merge(pilot, bounds)
end

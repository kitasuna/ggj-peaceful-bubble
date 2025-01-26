function new_item(bounds, velvec, velttl)
  local item = {
    draw = function(self)
      spr(self.frames[self.current_frame], self.pos.x, self.pos.y, 2, 2)
    end,
    vel = velvec,
    velttl = velttl,
    frames={39,41,43,45,45,43,41,39},
    current_frame=1,
    current_framettl=0.1,
    -- used to reset the ttl after frame change
    framettl=0.1,
    update = function(self, dt)
      self.pos += self.vel
      self.velttl -= dt
      if self.velttl <= 0 then
        self.vel = v2(0,0)
      end

      self.current_framettl -= dt
      if self.current_framettl <= 0 then
        self.current_framettl = self.framettl
        self.current_frame += 1 
        if self.current_frame > #self.frames then
          self.current_frame = 1
        end
      end
    end,
  }
  return merge(item, bounds)
end

function items()
  return {
      new_item(bcirc(v2(136,136), 5), v2(-0.25,-0.30), 3),
      new_item(bcirc(v2(136,-8), 5), v2(-0.30,0.20), 3),
      new_item(bcirc(v2(-8,-8), 5), v2(0.55,0.35), 2),
  }
end

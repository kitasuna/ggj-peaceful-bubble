function new_item(start_pos, end_pos)
  return {
    t=0,
    pos=start_pos,
    start_pos=start_pos,
    end_pos=end_pos,
    draw = function(self)
      spr(self.frames[self.current_frame], self.pos.x-8, self.pos.y-8, 2, 2)
    end,
    frames={39,41,43,45,45,43,41,39},
    current_frame=1,
    current_framettl=0.2,
    -- used to reset the ttl after frame change
    framettl=0.2,
    update = function(self, dt)
      self.t += 1
      self.pos = sine_ease(self.start_pos, self.end_pos, self.t/400)

      self.current_framettl -= dt
      if self.current_framettl <= 0 then
        self.current_framettl = self.framettl
        self.current_frame += 1 
        if self.current_frame > #self.frames then
          self.current_frame = 1
        end
      end
    end,
    collider = function(self)
      return circle_collider(self.pos, 7)
    end
  }
end

function items(phase)
  local is = {
    -- TODO: Do this math xD The end_pos are calculated from the old
    -- velocity-based code + how many frames it ran.
    new_item(v2(136,136), v2(136,136) + v2(-0.25,-0.30)*180),
    new_item(v2(136,-8), v2(136, -8) + v2(-0.30,0.20)*180),
    new_item(v2(-8,-8), v2(-8,-8) + v2(0.55,0.35)*120),
  }
  return is[phase]
end

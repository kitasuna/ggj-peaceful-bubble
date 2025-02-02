function passing_ship(pos)
  return {
    pos = pos,
    vel = v2(0,-30),
    done=false,
    flame_timer=-5,
    update = function(self,dt)
      self.flame_timer += 1
      if self.flame_timer > 5 then
        self.flame_timer = -5
      end
      self.pos += dt * self.vel
    end,

    draw = function(self)
      spr(198, self.pos.x, self.pos.y, 2, 2)
      if self.flame_timer > 0 then
        spr(230, self.pos.x, self.pos.y + 16, 2, 1)
      else
        spr(246, self.pos.x, self.pos.y + 16, 2, 1)
      end
    end,
  }
end
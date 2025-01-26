function passing_ship()
  local speed = 0.5
  return{

    pos = v2((20 + rnd(90)), 150),
    done=false,
    flame_timer=-15,

    update = function(self)
      if self.done then
        return
      end
      self.flame_timer += 1
      if self.flame_timer > 15 then
        self.flame_timer = -15
      end
      self.pos.y -= speed
      if self.pos.y < -50 then
        self.done = true
      end
    end,

    draw = function(self)
      if self.done then
        return
      end
      spr(198, self.pos.x, self.pos.y, 2, 2)
      if self.flame_timer > 0 then
        spr(230, self.pos.x, self.pos.y + 16, 2, 2)
      end
    end,

  }
end
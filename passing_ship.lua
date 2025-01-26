function passing_ship()
  local speed = 0.5
  return{

    pos = v2((20 + rnd(90)), 150),
    done=false,

    update = function(self)
      if self.done then
        return
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
    end,

  }
end
function new_item(bounds, velvec, velttl)
  local item = {
    draw = function(self)
      rectfill(
        self.pos.x,
        self.pos.y,
        self.pos.x+4,
        self.pos.y+4
      )
    end,
    vel = velvec,
    velttl = velttl,
    update = function(self, dt)
      self.pos += self.vel
      self.velttl -= dt
      if self.velttl <= 0 then
        self.vel = v2(0,0)
      end
    end,
  }
  local tmp= merge(item, bounds)
  return tmp
end

function items()
  return {
      new_item(bcirc(v2(136,136), 5), v2(-0.25,-0.30), 3),
      new_item(bcirc(v2(136,-8), 5), v2(-0.30,0.20), 3),
      new_item(bcirc(v2(-8,-8), 5), v2(0.55,0.35), 2),
  }
end

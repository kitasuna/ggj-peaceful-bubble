function floating_bubble(pos, dy, with_pilot)
  return {
    t = 0,
    with_pilot = with_pilot,
    update = function(self)
      self.t += 1
    end,
    draw = function(self)
      local x,y = pos.x, pos.y + dy * sin(self.t/180)
      spr(2, x-8, y-8, 2, 2)
      if self.with_pilot then
        spr(200, x-4, y-3)
      end
    end,
  }
end

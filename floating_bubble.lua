function floating_bubble(x, y, max_deviation, with_pilot)
  local bubble_going_up = true
  local ymid = y
  return {
    t = 0,
    with_pilot = with_pilot,
    update = function(self)
      self.t += 1
      if bubble_going_up then
        y -= 0.1
      else
        y += 0.1
      end
      if abs(y - ymid) > max_deviation then
        bubble_going_up = not bubble_going_up
      end
      return nil
    end,

    draw = function(self)
      spr(2, x, y, 2, 2)
      if self.with_pilot then
        spr(200, x+4, y+5)
      end
    end,

  }
end

function floating_bubble(x, y, max_deviation)
  local bubble_going_up = true
  return {
    t = 0,
    update = function(self)
      self.t += 1
      if bubble_going_up then
        y -= 0.1
      else
        y += 0.1
      end
      if abs(y - 56) > max_deviation then
        bubble_going_up = not bubble_going_up
      end
      return nil
    end,
    draw = function(self)
      spr(2, x, y, 2, 2)
    end,
  }
end

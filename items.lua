function new_item(start_pos, end_pos)
  local item_anim = anim.from_frames({39,41,43,45,45,43,41,39})
    :map(function(s)
      return draw_spr(s,-8,-8,2,2)
    end)
    :scale(8/60)
    :loop()

  return {
    t=0,
    pos=start_pos,
    start_pos=start_pos,
    end_pos=end_pos,
    draw = function(self)
      draw_with_offset(self.pos)
        (item_anim.at(self.t))()
    end,
    update = function(self, dt)
      self.t += dt
      self.pos = sine_ease(self.start_pos, self.end_pos, 60*self.t/400)
    end,
    collider = function(self)
      return circle_collider(self.pos, 7)
    end
  }
end

function items(phase)
  local is = {
    new_item(v2(136,136), v2(91,82)),
    new_item(v2(136,-8), v2(82, 28)),
    new_item(v2(-8,-8), v2(58,34)),
    new_item(v2(136,136), v2(91,82)),
  }
  return is[phase]
end

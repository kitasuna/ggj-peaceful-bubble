function new_pilot(pos)
  local wobble_anim = anim.from_frames({0,1,2,3,2,1,0,-1})
    :scale(16/60)
    :loop()

  return {
    t=0,
    pos=pos,
    start_pos=pos,
    end_pos=pos+v2(0,60),
    draw = function(self)
      -- draw ship
      compose(
        draw_with_offset(self.pos),
        draw_with_outline(0)
      )(draw_spr(198, -24, 8, 2, 2))()
      -- draw pilot
      local dy = wobble_anim.at(self.t)
      draw_with_offset(self.pos)
        (draw_spr(200, -2, -dy - 2, 1, 1))()
    end,
    update = function(self, dt)
      self.t += dt
      self.pos = sine_ease(self.start_pos, self.end_pos, 60*self.t/400)
    end,
    collider=function(self)
      return circle_collider(self.pos, 3)
    end,
  }
end

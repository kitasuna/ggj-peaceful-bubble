-- Requires collision, vector2.
do

local function flicker(n)
  return anim.create(function(t)
    return suspend(function(draw)
      if ceil(60*t) % (2*n) < n then
        draw()
      end
    end)
  end, 32000)
end

draw_warning = function()
  fillp(0x36c9.8)
  rectfill(-4,0,4,128,4)
  draw_with_outline(4)(draw_spr(15,-3,12))()
  fillp()
end

draw_laser_sprite = suspend(function(s)
  for y=0,128,16 do
    spr(s,-8,y,2,2)
  end
end)

laser_anim = anim.concat({
  anim.const(draw_warning,  60/60)
    :apply(flicker(15)),
  anim.const(noop, 30/60),
  anim.const(draw_laser_sprite(5),  15/60)
    :apply(flicker(4)),
  anim.const(draw_laser_sprite(5),  10/60)
    :apply(flicker(2)),
  anim.const(draw_laser_sprite(5),  2/60),
  anim.const(draw_laser_sprite(9),  3/60),
  anim.const(draw_laser_sprite(11), 4/60),
  anim.const(draw_laser_sprite(13), 30/60),
  anim.const(draw_laser_sprite(11), 4/60),
  anim.const(draw_laser_sprite(9),  3/60),
  anim.const(draw_laser_sprite(5),  5/60)
    :apply(flicker(2)),
  anim.const(noop),
})

laser_collider_anim = anim.concat({
  anim.const(false,  124/60),
  anim.const(true,   30/60),
  anim.const(false),
})

function new_laser(x_pos)
  return {
    t=0,
    ttl=laser_anim.dur,
    x_pos = x_pos,
    update=function(self,dt)
      self.t += dt
    end,
    draw=function(self)
      draw_with_offset(v2(self.x_pos, 0))(
        laser_anim.at(self.t)
      )()
    end,
    collider=function(self)
      local is_on = laser_collider_anim.at(self.t)
      return is_on
        and box_collider(v2(self.x_pos,64),8,128)
        or  null_collider
    end
  }
end

end
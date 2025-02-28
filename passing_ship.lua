function obj_from_anim(a)
  return {
    t = 0,
    ttl = a.dur,
    update = function(self,dt)
      if self.t > self.ttl then return end
      self.t += dt
    end,
    draw = function(self)
      if self.t > self.ttl then return end
      a.at(self.t)()
    end,
  }
end

function contrails_anim(pos)
  return anim.create(suspend(function(t)
    local p1,p2,p3,p4 =
      pos.at(t),
      pos.at(t-2/60) or pos.at(t),
      pos.at(t-4/60) or pos.at(t),
      pos.at(t-12/60) or pos.at(t)
    line(p1.x, p1.y, p2.x, p2.y, 2)
    fillp(▤)
    line(p2.x, p2.y, p3.x, p3.y, 2)
    fillp(0x00ff)
    line(p3.x, p3.y, p4.x, p4.y, 15)
    fillp()
  end), pos.dur)
end


do

local ship_base = anim.const(draw_spr(198,0,0,2,2))

local ship_flame = anim.from_frames({230,246})
  :map(function(s)
    return draw_spr(s,0,16,2,1)
  end)
  :scale(3/60)

local function ship_contrails(pos)
  return anim.from_tbl({
    contrails_anim(pos)
      :map(draw_with_offset(v2(0,18))),
    contrails_anim(pos)
      :map(draw_with_offset(v2(15,18))),
  })
  :map(draw_seq)
end

local function ship_anim(opts)
  local keep_draw = id
  local skip_draw = const(function() end)

  return function(pos)
    return anim.from_tbl({
      -- ship sprite
      ship_base:apply(pos:map(draw_with_offset)),
      -- engine flame
      ship_flame:apply(pos:map(draw_with_offset))
        :map(opts.flame and keep_draw or skip_draw),
      -- contrails
      ship_contrails(pos)
        :map(opts.contrails and keep_draw or skip_draw),
    }):map(draw_seq)
  end
end

function passing_ship()
  return obj_from_anim(
    anim.concat({
      -- wait before entering
      anim.linear
        :map(lerp(v2(40,150), v2(40,150)))
        :scale(0.5)
        :thru(ship_anim({ contrails = false, flame = false})),
      -- ship enters screen quickly
      anim.linear
        :map(function(t) return t*t end)
        :map(lerp(v2(40,150), v2(40,60)))
        :scale(1.5)
        :thru(ship_anim({ contrails = true, flame = true})),
      -- waits
      anim.linear
        :map(lerp(v2(40,60), v2(40,50)))
        :scale(1)
        :thru(ship_anim({ contrails = false, flame = true})),
      -- then drifts away slow
      anim.linear
        :map(lerp(v2(40,50), v2(40,-50)))
        :scale(6)
        :thru(ship_anim({ contrails = false, flame = false})),
    })
  )
end

end
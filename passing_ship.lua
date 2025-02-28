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
      pos.at(t-6/60) or pos.at(t),
      pos.at(t-18/60) or pos.at(t)
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

local keep_draw = anim.const(id, 32000)
local skip_draw = anim.const(function() end, 32000)
local flicker   = anim.create(function(t)
  return function(draw)
    if (t*60) % 1 > 0.5 then
      draw()
    end
  end
end)

local function ship_anim(opts)
  return function(pos)
    return anim.from_tbl({
      -- ship sprite
      ship_base:apply(pos:map(draw_with_offset)),
      -- engine flame
      ship_flame:apply(pos:map(draw_with_offset))
        :apply(opts.flame),
      -- contrails
      ship_contrails(pos)
        :apply(opts.contrails),
    }):map(draw_seq)
  end
end

function passing_ship()
  local p0 = v2(40,150)
  local p1 = v2(40,60)
  local p2 = v2(40,56)
  local p3 = v2(40,50)
  local p4 = v2(40,42)
  local p5 = v2(40,-50)

  return obj_from_anim(
    anim.concat({
      -- wait before entering
      anim.linear
        :map(const(p0))
        :scale(0.5)
        :thru(ship_anim({ contrails = skip_draw, flame = skip_draw})),
      -- ship enters screen quickly
      anim.linear
        :map(function(t) return sine_ease(0,1,t) end)
        :map(lerp(p0,p1))
        :scale(1.5)
        :thru(ship_anim({ contrails = keep_draw, flame = keep_draw})),
      -- waits
      anim.linear
        :map(lerp(p1,p2))
        :scale(0.5)
        :thru(ship_anim({ contrails = skip_draw, flame = keep_draw})),
      -- waits
      anim.linear
        :map(lerp(p2,p3))
        :scale(1)
        :thru(ship_anim({ contrails = skip_draw, flame = skip_draw})),
      -- try to restart engine
      anim.linear
        :map(lerp(p3,p4))
        :scale(1.5)
        :thru(ship_anim({ contrails = skip_draw, flame = flicker})),
      -- then drifts away slow
      anim.linear
        :map(lerp(p4,p5))
        :scale(7)
        :thru(ship_anim({ contrails = skip_draw, flame = skip_draw})),
    })
  )
end

end
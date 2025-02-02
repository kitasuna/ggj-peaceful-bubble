-- Requires cycler, vector2.

function new_emitter(pos, vel, bullcount, cooldown, bullet_f)
  local e = {
    pos=pos,
    vel=vel,
    bullet_f=bullet_f,
    cycler = new_cycler(0.1, {2,4,3,5}),
    rot = 90,
    bullcount = bullcount,
    cooldown = cooldown,
    draw = function(self)
      local colors = {5,3,4}
      for i=1,#self.cycler.colors do
        pal(colors[i], self.cycler.colors[i])
      end
      for b in all(self.bulls) do
        b:draw() 
      end
      altpal()
    end,
    update = function(self, dt, target)
      for b in all(self.bulls) do
        b:update(dt)
        -- clean up any bullets that have strayed off screen
        if b.pos.x > 136 or b.pos.x < -8 or b.pos.y > 136 or b.pos.y < -8 then
          del(self.bulls, b)
        end
      end
      self.timer:update(time(), target)
      self.cycler:update(dt)
      self.pos += dt * self.vel
      -- when the emitter reaches the edge of the screen,
      -- "bounce" back in the other direction
      if self.pos.x > 136 or self.pos.x < -8 then
        self.vel.x = -self.vel.x
      end
      if self.pos.y > 136 or self.pos.y < -8 then
        self.vel.y = -self.vel.y
      end
    end,
    bulls = {},
  }

  e.timer = new_timer(
    0,
    0,
    function(t,now,target)
      local new_bulls = {}
      if e.bullet_f == nil then
        new_bulls = new_aimed_bullets(
          e.bullcount,
          e.pos,
          target,
          0,
          nil
        )
      else
        new_bulls = new_bullets(
          e.bullcount,
          e.pos,
          target,
          e.rot,
          e.bullet_f
        )
      end

      foreach(new_bulls, function(b)
        add(e.bulls, b)
      end)

      e.rot = (e.rot + 15) % 360
      t:add(e.cooldown)
    end
    )

  e.timer:init(1.5, time())

  return e
end

-- call this guy in a loop and pass the loop index
function bendy(angle, idx)
  return angle + (idx^4)
end

function waves(angle, idx)
  return angle + (15*idx)
end


function emitters(phase)
  local es = {
    {
      new_emitter(v2(64, -8), 60 * v2(0.4, 0), 1, 1),
      new_emitter(v2(-8, 64), 60 * v2(0, 0.4), 1, 1.1),
    },
    {
      new_emitter(v2(64, -8), 60 * v2(-0.4, 0), 2, 0.6),
      new_emitter(v2(136, 64), 60 * v2(0, 0.4), 2, 0.7),
    },
    {
      new_emitter(v2(130, 64), 60 * v2(0, 0), 10, 0.4, bendy),
    },
  }
  return es[phase]
end

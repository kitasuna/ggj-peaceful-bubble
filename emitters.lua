-- Requires cycler, vector2.

function new_bullet_emitter(level, pos, vel, bullcount, cooldown, bullet_f)
  local e = {
    pos=pos,
    vel=vel,
    bulls = {},
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
      self.timer:update(dt)
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
    fire = function(e)
      local new_bulls = {}
      local target = level.hero.pos
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

      -- schedule the next shot burst
      e.timer = new_timer(e.cooldown, function()
        e:fire()
      end)
    end,
    stop = function(e)
      e.bullcount = 0
    end,
  }
  -- schedule the first shot burst
  e.timer = new_timer(1.5, function()
    e:fire()
  end)

  return e
end

function new_laser_emitter(positions, cooldown)
  local e = {
    cooldown = cooldown,
    lasers = {},
    draw = function(self)
      for l in all(self.lasers) do
        l:draw() 
      end
    end,
    update = function(self, dt)
      for l in all(self.lasers) do
        l:update(dt)
        -- clean up any lasers that have finished firing
        if l.t > l.ttl then
          del(self.lasers, l)
        end
      end
      self.timer:update(dt)
    end,
    fire = function(e, idx)
      for x_pos in all(positions[idx]) do
        add(e.lasers, new_laser(x_pos))
      end
      -- schedule the next shot
      e.timer = new_timer(e.cooldown, function()
        local next_idx = idx == #positions
          and 1
          or  idx+1
        e:fire(next_idx)
      end)
    end,
    stop = function(e)
      e.timer = new_timer(1, function() end)
    end,
  }
  -- schedule the first shot
  e.timer = new_timer(e.cooldown, function()
    e:fire(1)
  end)
  return e
end

-- call this guy in a loop and pass the loop index
function bendy(angle, idx)
  return angle + (idx^4)
end

function waves(angle, idx)
  return angle + (30*idx)
end


function emitters(level, phase)
  local es = {
    {
      new_bullet_emitter(level, v2(64, -8), 60 * v2(0.4, 0), 1, 1),
      new_bullet_emitter(level, v2(-8, 64), 60 * v2(0, 0.4), 1, 1.1),
    },
    {
      new_bullet_emitter(level, v2(64, -8), 60 * v2(-0.4, 0), 2, 0.6),
      new_bullet_emitter(level, v2(136, 64), 60 * v2(0, 0.4), 2, 0.7),
    },
    {
      new_bullet_emitter(level, v2(130, 64), v_zero, 10, 0.4, bendy),
    },
    {
      new_laser_emitter({
        {4, 124},
        {28},
        {76},
        {52},
        {100},
      }, 3),
      new_bullet_emitter(level, v2(130, 64), v_zero, 5, 0.7, waves),
      new_bullet_emitter(level, v2(-8, 64), v_zero, 5, 0.7, waves),
    },
  }
  return es[phase]
end

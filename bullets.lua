-- Requires bcirc, vector2.

function new_emitter(x, y, dx, dy, bullet_f)
  local e = {
    x=x,
    y=y,
    dx=dx,
    dy=dy,
    cycler = new_cycler(0.1, {7,8,9,10}),
    rot = 90,
    bullcount = 2,
    cooldown = 0.6,
    draw = function(self)
      -- circfill(e.x,e.y,3,11)
      local colors = {8,9,10}
      for i=1,#self.cycler.colors do
        pal(colors[i], self.cycler.colors[i]) 
      end
      for i, b in pairs(self.bulls) do
        b:draw(dt) 
      end
      altpal()
    end,
    update = function(self, dt, level)
      for i, b in pairs(self.bulls) do
        b:update(dt) 
        if b.pos.x > 136 or b.pos.x < -8 or b.pos.y > 136 or b.pos.y < -8 then
          del(self.bulls, b)
        end
      end
      self.timer:update(time(), level.hero)
      self.cycler:update(dt)

      self.x += self.dx
      self.y += self.dy
      if self.x > 136 or self.x < -8 then
        self.dx = -self.dx
      end
      if self.y > 136 or self.y < -8 then
        self.dy = -self.dy
      end
    end,
    bulls = {},
  }

  e.timer = new_timer(
    0,
    function(t,now,hero)
      -- local new_bulls = new_bullets(e.bullcount, e.x, e.y, e.rot, bendy)
      local new_bulls = new_aimed_bullets(e.bullcount, e.x, e.y, hero.bounds.pos.x, hero.bounds.pos.y)

      foreach(new_bulls, function(b)
        add(e.bulls, b)
      end)

      e.rot = (e.rot + 45)  % 360
      t:add(e.cooldown)
    end
    )

    e.timer:init(e.cooldown, 0)

    e.bulls = new_bullets(e.bullcount,
      e.x,
      e.y,
      e.rot,
      waves)
    return e
end

-- call this guy in a loop and pass the loop index
function bendy(angle, idx)
  return angle + (idx^4)
end

function waves(angle, idx)
  return angle + (15*idx)
end

function new_bullets(count, start_x, start_y, base_angle, rot_f)
  local bulls = {}
  -- change the max of the for loop to make more bullets in one spawn
  for i=1,count do
    -- change the second factor here to rotate starting positions around the emitter's origin
    -- Guided stuff
    -- local angle = base_rot + (i^4)
    local angle = rot_f(base_angle, i)
    -- Fixed waves
    -- local angle = base_rot + (15*i)
    local sinof, cosof = sin(angle/360), cos(angle/360)
    -- change the constant here to change spawning distance from emitter
    local bull = {
      dx=1*cosof,
      dy=1*sinof,
      draw=function(b)
        -- circfill(b.pos.x,b.pos.y,b.radius,12)
        spr(4, b.pos.x, b.pos.y)
      end,
      update=function(b,dt)
        b.pos.x+=b.dx
        b.pos.y+=b.dy
      end,
    }
    local bcircbull = bcirc(v2(start_x+5*cosof,start_y+5*sinof),2)
    --  bcirc(v2(3,3),3),
    -- bcirc(v2(0,0),1),
    bulls[i] = merge(bull, bcircbull)
  end
  return bulls
end

function new_aimed_bullets(count, start_x, start_y, tgt_x, tgt_y)
  local bulls = {}
  -- change the max of the for loop to make more bullets in one spawn
  for i=1,count do
    -- change the second factor here to rotate starting positions around the emitter's origin
    -- Guided stuff
    -- local angle = base_rot + (i^4)
    local diffx = tgt_x - start_x
    local diffy = tgt_y - start_y
    local velx = (diffx / (abs(diffx) + abs(diffy))) * 1.2
    local vely = (diffy / (abs(diffy) + abs(diffx))) * 1.2

    -- Fixed waves
    -- local angle = base_rot + (15*i)
    -- local sinof, cosof = sin(angle/360), cos(angle/360)
    -- change the constant here to change spawning distance from emitter
    local bull = {
      dx=velx,
      dy=vely,
      draw=function(b)
        -- circfill(b.pos.x,b.pos.y,b.radius,12)
        spr(4, b.pos.x, b.pos.y)
      end,
      update=function(b,dt)
        b.pos.x+=b.dx
        b.pos.y+=b.dy
      end,
    }
    local bcircbull = bcirc(v2(start_x+rnd(10)-5,start_y+rnd(10)-5),2)
    bulls[i] = merge(bull, bcircbull)
  end
  return bulls
end

function new_timer(now, f)
  return {
    ttl = 0,
    last_t = now,
    f = f,
    init = function(t, ttl, last_t)
      t.ttl = ttl
      t.last_t = last_t
    end,
    -- add allows us to add some add'l time to the timer
    add = function(t, addl_t)
      t.ttl += addl_t
    end,
    update = function(t, now, hero)
      if t.ttl == 0 then
        return
      end
      t.ttl = t.ttl - (now - t.last_t)
      t.last_t = now
      if t.ttl <= 0 then
        t.ttl = 0
        t:f(now, hero)
      end
    end,
  }
end

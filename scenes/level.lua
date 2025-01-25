-- level(nxt)
-- * nxt : callback - call to end the level pass control to the next scene
function level(nxt)
  local items = items(1)
  return {
    last_ts = time(),
    phase = 1,
    emitters = {},
    -- figure we'll pass the level/screen index here and for emitters (eventually)
    hero = player(v2(64,64)),
    items = {},
    item_timer = new_timer(time(), 5, function(self, now, level)
      -- add item to level...
      add(level.items, items[1])
      -- remove it from our list so we don't put it there again
      del(items, items[1])
    end),
    emitter_timer = new_timer(time(), 1, function(self, now, level)
      level.emitters = emitters(level.phase)
    end),
    cloud_map=wrapping_bg(0,0,32),
    -- TODO: Add easing between these.
    cloud_velocities={
      v2(0.1,0.25),
      v2(0.25,-0.1),
      v2(-0.5,-0.3),
    },
    star_map=wrapping_bg(32,0,32),
    star_velocities={
      v2(0.2,0.4),
      v2(0.4,-0.2),
      v2(-1.2,-0.8),
    },
    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.last_ts = now
      self.hero:update(dt)
      self.item_timer:update(now, self)
      self.emitter_timer:update(now, self)

      foreach(self.emitters, function(e)
        e:update(dt, self)
      end)

      -- check for bullet collisions
      local allbulls = {}
      foreach(self.emitters, function(e)
        foreach(e.bulls, function(b)
          add(allbulls, b)
          end
        )
      end)
      local bullet_collisions = collision(self.hero.bounds, allbulls)
      if #bullet_collisions > 0 then
        foreach(self.emitters, function(e)
          del(e.bulls, bullet_collisions[1])
        end)
        self.hero:damage() -- if it gets small, make it invincible for a bit
      end

      -- check for item collisions
      local itemgets = collision(self.hero.bounds, self.items)
      if #itemgets > 0 then
        del(self.items, itemgets[1])
        self.hero:grow()
        self.hero.points += 1
        -- chill out current emitters...
        foreach(self.emitters, function(e)
          e.bullcount = 0
        end)
        -- ... and set a timer to instantiate the next ones
        self.emitter_timer:init(3, time())
        -- also set a timer for the next item to show up
        self.item_timer:init(7, time())
        self.phase += 1
      end

      -- check if we should go to the next scene
      if not self.hero.alive then
        nxt("dead")
      end
      if #self.items == 0 and #items == 0 then
        nxt("complete")
      end

      -- self.phase can outgrow our velocities.
      if self.phase <= #self.cloud_velocities then
        self.cloud_map:scroll(self.cloud_velocities[self.phase])
        self.star_map:scroll(self.star_velocities[self.phase])
      end
    end,
    draw = function(self)
      cls()
      self.cloud_map:draw()
      self.star_map:draw()
      foreach(self.emitters, function(e)
        e:draw(dt)
      end)
      foreach(self.items, function(i)
        i:draw(dt)
      end)
      -- draw hero
      self.hero:draw()
    end,
  }
end

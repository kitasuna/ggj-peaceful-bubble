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
        if(not self.hero.alive) then
          nxt("dead")
        end
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
    end,
    draw = function(self)
      cls()
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

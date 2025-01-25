-- level(nxt)
-- * nxt : callback - call to end the level pass control to the next scene
function level(nxt)
  return {
    last_ts = time(),
    emitters = {
      new_emitter(120, 64, 0, 0.4),
      new_emitter(64, 120, -0.4, 0),
    },
    -- figure we'll pass the level/screen index here and for emitters (eventually)
    items = items(1),
    hero = player(bcirc(v2(0,64),5)),
    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.last_ts = now
      self.hero:update(dt)

      foreach(self.emitters, function(e)
        e:update(dt, self)
      end)

      local allbulls = {}
      foreach(self.emitters, function(e)
        foreach(e.bulls, function(b)
          add(allbulls, b)
          end
        )
      end)

      local collisions = collision(self.hero.bounds, allbulls)
      if #collisions > 0 then
        self.hero:die()
        nxt("dead")
      end

      local itemgets = collision(self.hero.bounds, self.items)
      if #itemgets > 0 then
        del(self.items, itemgets[1])
        self.hero.points += 1
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

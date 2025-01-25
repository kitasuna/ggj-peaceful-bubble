function level()

  return {
    last_ts = time(),
    emitters = {
    new_emitter(120, 64, 0, 0.4),
    new_emitter(64, 120, -0.4, 0)
    },
    hero = player(bcirc(v2(0,64),5)),
    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.hero:update(dt)

      foreach(self.emitters, function(e)
        e:update(dt, self.hero)
      end)

      --[[
      if(btnp(0)) then
        emitter.cooldown += 0.1
      elseif(btnp(1)) then
        emitter.cooldown -= 0.1
      elseif(btnp(2)) then
        emitter.bullcount += 1
      elseif(btnp(3)) then
        emitter.bullcount -= 1
      end
      ]]--

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
        return cutscene()
      end

      return nil  -- continue
    end,
    draw = function(self)
      cls()
      -- print("Hello World", 64, 64, 12)
      foreach(self.emitters, function(e)
        e:draw(dt)
      end)
      -- draw hero
      self.hero:draw()
    end,
  }
end

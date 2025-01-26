-- level(nxt)
-- * nxt : callback - call to end the level pass control to the next scene
function level(nxt)
  return {
    last_ts = time(),
    restart_timer=nil,
    emitters = {
      new_emitter(120, 64, 0, 0.4),
      new_emitter(64, 120, -0.4, 0),
    },
    -- figure we'll pass the level/screen index here and for emitters (eventually)
    items = items(1),
    hero = player(v2(0,64)),
    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.last_ts = now
      self.hero:update(dt)

      foreach(self.emitters, function(e)
        e:update(dt, self)
      end)

      -- check collisions
      if(self.hero.alive) then
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
          self.hero:damage()
          if(not self.hero.alive) then
            self.restart_timer = 80
          end
        end
        -- check for item collisions
        local itemgets = collision(self.hero.bounds, self.items)
        if #itemgets > 0 then
          del(self.items, itemgets[1])
          self.hero:grow()
        end
      end
      
      --restart timer
      if self.restart_timer != nil then
        self.restart_timer -= 1
        if self.restart_timer <= 0 then
          return nxt()
        end
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

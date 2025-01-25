function level()
  return {
    last_ts = time(),
    emitter = new_emitter(),
    hero = player(bcirc(v2(0,64),5)),
    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.emitter:update(dt)
      self.hero:update(dt)

      if(btnp(0)) then
        self.emitter.cooldown += 0.1
      elseif(btnp(1)) then
        self.emitter.cooldown -= 0.1
      elseif(btnp(2)) then
        self.emitter.bullcount += 1
      elseif(btnp(3)) then
        self.emitter.bullcount -= 1
      end

      local collisions = collision(self.hero.bounds, self.emitter.bulls)
      if #collisions > 0 then
        self.hero:die()
        return "dead"
      end
      
      return ""  -- continue
    end,
    draw = function(self)
      cls()
      -- print("Hello World", 64, 64, 12)
      self.emitter:draw()
      -- draw hero
      self.hero:draw()
    end,
  }
end

-- level(nxt)
-- * nxt : callback - call to end the level pass control to the next scene
function level(nxt)
  return {
    passing_ship = passing_ship(),
    last_ts = time(),
    phase = 1,
    phase_t = 0,
    hero = player(v2(64,64)),
    emitters = {},
    items = {},
    item_particles = empty,
    pilot = empty,
    interphase = false,
    bg = star_background(),
    bg_velocities={
      v2(0.2,0.4),
      v2(0.4,-0.2),
      v2(-1.2,-0.8),
      v2(1.2,-0.8),
      v2(0, -2.5)
    },
    timers = {},

    init = function(self)
      music_controller:play_song("zero_g")

      self:add_timer(5, function()
        self.items = { items(self.phase) }
      end)

      self:add_timer(2, function()
        self.emitters = emitters(self, self.phase)
      end)
    end,

    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.last_ts = now
      self.phase_t += 1
      
      self.hero:update(dt)
      
      self.passing_ship:update(dt)
      
      self.pilot:update(dt)

      local total_bulls = 0
      foreach(self.emitters, function(e)
        e:update(dt)
        total_bulls += #(e.bulls or {})
      end)

      if total_bulls == 0 and self.interphase then
        self:cue_next_phase()
      end

      foreach(self.items, function(i)
        i:update(dt)
      end)

      self.item_particles:update()

      -- check collisions
      if self.hero.alive then
        self:check_collisions()
      end

      -- self.phase can outgrow our velocities.
      if self.phase <= 1 then
        self.bg:scroll(self.bg_velocities[self.phase])
      elseif self.phase <= #self.bg_velocities then
        self.bg:scroll(ease(self.bg_velocities[self.phase-1],
                                   self.bg_velocities[self.phase],
                                   self.phase_t/60))
      else
        self.bg:scroll(self.bg_velocities[#self.bg_velocities])
      end

      -- update timers
      foreach(self.timers, function(t)
        t:update(dt)
      end)
    end,

    add_timer = function(self, ttl, f)
      add(self.timers, new_timer(ttl, function(timer)
        f()
        del(self.timers, timer)
      end))
    end,

    check_collisions = function(self)
      collision(self.hero, {empty})


      -- check for bullet collisions
      local allbulls = {}
      foreach(self.emitters, function(e)
        foreach(e.bulls, function(b)
          add(allbulls, b)
        end)
      end)

      local bullet_collisions = collision(self.hero, allbulls)
      if #bullet_collisions > 0 then
        foreach(self.emitters, function(e)
          del(e.bulls, bullet_collisions[1])
        end)
        self.hero:damage()
        -- schedule a timer to end the level
        if not self.hero.alive then
          self:add_timer(100/60, function()
            nxt("dead")
          end)
        end
      end

      -- check for item collisions
      local itemgets = collision(self.hero, self.items)
      if #itemgets > 0 then
        self:on_item_hero_collision(itemgets[1])
      end

      if self.pilot != nil then
        -- check for pilot collision / end game
        local pilotgets = collision(self.hero, {self.pilot})
        -- schedule a timer to finish the game
        if #pilotgets > 0 then
          self:add_timer(15/60, function()
            nxt("complete")
          end)
        end
      end
    end,

    on_item_hero_collision = function(self, item)
      self.hero:grow()
      self.item_particles = particles(46, item.pos+v2(4,4), 3, 1)
      del(self.items, item)
      self:stop_emitters()
      self.interphase = true
    end,

    cue_next_phase = function(self)
      self.phase += 1
      self.interphase = false
      self.phase_t = 0
      local now = time()
      if #self.items == 0 and self.phase == 5 then
        self:add_timer(1, function()
          self:spawn_pilot()
        end)
      else
        -- schedule item spawn
        self:add_timer(7 + (self.phase * 2), function()
          self.items = { items(self.phase) }
        end)
        -- schedule new emitters
        self:add_timer(3, function()
          self.emitters = emitters(self, self.phase)
        end)
      end
    end,

    stop_emitters = function(self)
      foreach(self.emitters, function(e)
        e:stop()
      end)
    end,

    spawn_pilot = function(self)
      pilot_x = self.hero.pos.x < 64 and 96 or 32  
      -- spawn the pilot
      self.pilot = new_pilot(v2(pilot_x,-32))
    end,

    draw = function(self)
      cls()
      self.bg:draw()
      self.passing_ship:draw()
      foreach(self.emitters, function(e)
        e:draw()
      end)
      foreach(self.items, function(i)
        i:draw()
      end)
      self.item_particles:draw()
      self.pilot:draw()
      self.hero:draw()
    end,
  }
end

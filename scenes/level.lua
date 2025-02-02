-- level(nxt)
-- * nxt : callback - call to end the level pass control to the next scene
function level(nxt)
  return {
    passing_ship = passing_ship(v2((20 + rnd(90)), 150)),
    last_ts = time(),
    phase = 1,
    phase_t = 0,
    hero = player(v2(64,64)),
    emitters = {},
    items = {},
    item_particles=nil,
    pilot = nil,
    interphase = false,
    cloud_map=wrapping_bg(0,0,32),
    cloud_velocities={
      v2(0.1,0.25),
      v2(0.25,-0.1),
      v2(-0.5,-0.3),
      v2(0, -1)
    },
    star_map=wrapping_bg(32,0,32),
    star_velocities={
      v2(0.2,0.4),
      v2(0.4,-0.2),
      v2(-1.2,-0.8),
      v2(0, -2.5)
    },
    timers = {},

    init = function(self)
      music_controller:play_song("zero_g")

      self:add_timer(5, function()
        self.items = { items(self.phase) }
      end)

      self:add_timer(1, function()
        self.emitters = emitters(self, self.phase)
      end)
    end,

    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.last_ts = now
      self.phase_t += 1
      
      self.hero:update(dt)
      
      if self.passing_ship != nil then
        self.passing_ship:update(dt)
        if self.passing_ship.pos.y < -50 then
          self.passing_ship = nil
        end
      end
      if self.pilot != nil then
        self.pilot:update(dt)
      end

      local total_bulls = 0
      foreach(self.emitters, function(e)
        e:update(dt)
        total_bulls += e.bullcount
        total_bulls += #e.bulls
      end)

      if total_bulls == 0 and self.interphase then
        printh("Oh man, trigger now")
        self:cue_next_phase()
        printh("phase: "..self.phase)
      end

      foreach(self.items, function(i)
        i:update(dt)
      end)

      if self.item_particles != nil then
        self.item_particles:update()
      end

      -- check collisions
      if self.hero.alive then
        self:check_collisions()
      end

      -- self.phase can outgrow our velocities.
      if self.phase <= 1 then
        self.cloud_map:scroll(self.cloud_velocities[self.phase])
        self.star_map:scroll(self.star_velocities[self.phase])
      elseif self.phase <= #self.cloud_velocities then
        self.cloud_map:scroll(ease(self.cloud_velocities[self.phase-1],
                                   self.cloud_velocities[self.phase],
                                   self.phase_t/60))
        self.star_map:scroll(ease(self.star_velocities[self.phase-1],
                                  self.star_velocities[self.phase],
                                  self.phase_t/60))
      else
        self.cloud_map:scroll(self.cloud_velocities[#self.cloud_velocities])
        self.star_map:scroll(self.star_velocities[#self.star_velocities])
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
      -- check for bullet collisions
      local allbulls = {}
      foreach(self.emitters, function(e)
        foreach(e.bulls, function(b)
          add(allbulls, b)
        end)
      end)

      local bullet_collisions = collision(self.hero.bounds, allbulls)
      if #bullet_collisions > 0 then
        foreach(self.emitters, function(e)
          del(e.bulls, bullet_collisions[1])
        end)
        self.hero:damage()
        -- schedule a timer to end the level
        if not self.hero.alive then
          self:add_timer(80/60, function()
            nxt("dead")
          end)
        end
      end

      -- check for item collisions
      local itemgets = collision(self.hero.bounds, self.items)
      if #itemgets > 0 then
        self:on_item_hero_collision(itemgets[1])
      end

      if self.pilot != nil then
        -- check for pilot collision / end game
        local pilotgets = collision(self.hero.bounds, {self.pilot})
        if #pilotgets > 0 then
          nxt("complete")
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
      if #self.items == 0 and self.phase == 4 then
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
        e.bullcount = 0
      end)
    end,

    spawn_pilot = function(self)
      pilot_x = self.hero.bounds.pos.x < 64 and 96 or 32  
      -- spawn the pilot
      self.pilot = new_pilot(bcirc(v2(pilot_x,-32), 3))
    end,

    draw = function(self)
      cls()
      self.cloud_map:draw()
      self.star_map:draw()

      if self.passing_ship != nil then
        self.passing_ship:draw()
      end

      foreach(self.emitters, function(e)
        e:draw()
      end)
      foreach(self.items, function(i)
        i:draw()
      end)
      if self.item_particles != nil then
        self.item_particles:draw()
      end

      -- if pilot exists..
      if self.pilot != nil then
        self.pilot:draw()
      end

      self.hero:draw()
    end,
  }
end

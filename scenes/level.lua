-- level(nxt)
-- * nxt : callback - call to end the level pass control to the next scene
function level(nxt)
  local items = items(1)
  return {
    passing_ship = passing_ship(),
    last_ts = time(),
    restart_timer=nil,
    phase = 1,
    phase_t = 0,
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
    pilot_spawn_timer = nil,
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

    init = function(self)
      music_controller:play_song("zero_g")
    end,

    update = function(self)
      local now = time()
      local dt = now - self.last_ts
      self.last_ts = now
      self.hero:update(dt)
      self.item_timer:update(now, self)
      self.emitter_timer:update(now, self)
      self.phase_t += 1
      self.passing_ship:update()
      if(self.pilot_spawn_timer != nil) then
        self.pilot_spawn_timer:update(now, self)
      end
      if(self.pilot != nil) then
        self.pilot:update(dt, self)
      end

      local total_bulls = 0
      foreach(self.emitters, function(e)
        e:update(dt, self)
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
          -- ej
          self:on_item_hero_collision(itemgets[1])
        end

        if self.pilot != nil then
          -- check for pilot collision / end game
          local pilotgets = collision(self.hero.bounds, {self.pilot})
          if #pilotgets > 0 then
            nxt("complete")
          end
        end
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
      
      --restart timer
      if self.restart_timer != nil then
        self.restart_timer -= 1
        if self.restart_timer <= 0 then
          return nxt("dead") -- todo: restart level
        end
      end
    end,

    on_item_hero_collision = function(self, item)
      self.hero:grow()
      del(self.items, item)
      self:stop_emitters()
      self.interphase = true
    end,

    cue_next_phase = function(self)
      self.phase += 1
      self.interphase = false
      self.phase_t = 0
      if #self.items == 0 and #items == 0 then
        self.pilot_spawn_timer = new_timer(time(), 1, self.spawn_pilot)
      else
        self.emitter_timer:init(3, time()) -- set a timer to instantiate the next ones
        self.item_timer:init(7 + (self.phase * 2), time())
      end
    end,

    stop_emitters = function(self)
      foreach(self.emitters, function(e)
        e.bullcount = 0
      end)
    end,

    spawn_pilot = function(callTimer, now, self)
      pilot_x = self.hero.bounds.pos.x < 64 and 96 or 32  
      -- spawn the pilot
      self.pilot = new_pilot(bcirc(v2(pilot_x,-32), 3))
    end,

    draw = function(self)
      cls()
      self.cloud_map:draw()
      self.star_map:draw()
      self.passing_ship:draw()
      foreach(self.emitters, function(e)
        e:draw(dt)
      end)
      foreach(self.items, function(i)
        i:draw(dt)
      end)

      -- if pilot exists..
      if self.pilot != nil then
        self.pilot:draw()
      end

      self.hero:draw()

    end,
  }
end

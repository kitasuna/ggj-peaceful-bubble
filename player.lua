-- Player movement. Requires collision.lua

function player(pos)
  local small_radius=4
  local big_radius=8
  return {
    pos=pos,
    points=0,
    size="small",
    grow_time=0,  -- How long we've been growing.
    alive=true,
    invincibility_timer=0,
    death_anim=nil,
    death_particles=nil,
    shrink_particles=nil,
    wobubble=wobubble(),

    grow=function(self)
      if self.size != "big" then
        -- only reset easing if we're not already big
        self.grow_time = 0
      end
      self.size = "big"
      sfx_controller:play_sound("bubble grow")
      self.points += 1
    end,

    damage=function(self)
      if(self.invincibility_timer > 0) then
        return
      end
      if(self.size == "small") then
        self:die()
        return
      end
      self:shrink()
      self.invincibility_timer = 30
    end,

    shrink=function(self)
      self.size = "small"
      self.shrink_particles = particles(46, self.pos, 4, 2)
      sfx_controller:play_sound("bubble shrink")
    end,

    update=function(self)
      if self.shrink_particles != nil then
        self.shrink_particles:update()
      end
      if self.death_particles != nil then
        self.death_particles:update()
      end
      if self.death_anim != nil then
        self.death_anim:update()
      end
      if self.alive then
        self.grow_time += 1
        self:update_movement()
        self.invincibility_timer -= 1
      end
    end,

    update_movement=function(self)
      local left = 0
      local right = 1
      local up = 2
      local down = 3

      local dx = 0
      local dy = 0
      if btn(up) then
        if(self.pos.y > 0) then
          self.pos.y -= 1
          dy = -1
        end
      elseif btn(down) then
        if(self.pos.y < 128) then
          self.pos.y += 1
          dy = 1
        end
      end

      if btn(left) then
        if(self.pos.x > 0) then
          self.pos.x -= 1
          dx = -1
        end
      elseif btn(right) then
        if(self.pos.x < 128) then
          self.pos.x += 1
          dx = 1
        end
      end
      self.wobubble:update(dx, dy)
    end,

    draw=function(self)
      if self.thought != nil then
        self.thought:draw()
      end
      if self.death_particles != nil then
        self.death_particles:draw()
      end
      if self.shrink_particles != nil then
        self.shrink_particles:draw()
      end
      if self.death_anim != nil then
        self.death_anim:draw()
      end
      if self.alive then
        local r
        if self.size == "big" then
          r = ease(small_radius, big_radius, self.grow_time/20)
        else
          r = small_radius
        end
        self.wobubble:draw(self.pos, r)
      end
    end,

    collider=function(self)
      return circle_collider(self.pos, self.size == "big" and big_radius or small_radius)
    end,

    die=function(self)
      sfx_controller:play_sound("bubble pop")
      self.death_anim = death_animation(self.pos)
      self.death_particles = particles(46, self.pos, 3, 1)
      self.alive = false
    end,
  }
end

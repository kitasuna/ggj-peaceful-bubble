-- Player movement. Requires bcirc.lua.

-- bcirc bounds

function player(spawnVec)
  return {
    bounds=bcirc(spawnVec, 5),
    points=0,
    size="small",
    alive=true,
    invincibility_timer=0,
    death_anim=nil,
    wobubble=wobubble(),

    grow=function(self)
      self.bounds = bcirc(self.bounds.pos, 8)
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
      self.bounds = bcirc(self.bounds.pos, 4)
      self.size = "small"
      sfx_controller:play_sound("bubble shrink")
    end,

    update=function(self)
      if self.death_anim != nil then
        self.death_anim:update()
      end
      if self.alive then
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
        if(self.bounds.pos.y > 0) then
          self.bounds.pos.y -= 1
          dy = -1
        end
      elseif btn(down) then
        if(self.bounds.pos.y < 128) then
          self.bounds.pos.y += 1
          dy = 1
        end
      end

      if btn(left) then
        if(self.bounds.pos.x > 0) then
          self.bounds.pos.x -= 1
          dx = -1
        end
      elseif btn(right) then
        if(self.bounds.pos.x < 128) then
          self.bounds.pos.x += 1
          dx = 1
        end
      end
      self.wobubble:update(dx, dy)
    end,

    draw=function(self)
      if self.thought != nil then
        self.thought:draw()
      end
      if self.death_anim != nil then
        self.death_anim:draw()
      end
      if self.alive then
        local x = self.bounds.pos.x
        local y = self.bounds.pos.y
        local r = 4
        if self.size == "big" then
          r = 8
        end
        self.wobubble:draw(x, y, r)
      end
    end,

    die=function(self)
      sfx_controller:play_sound("bubble pop")
      self.death_anim = death_animation(self.bounds.pos)
      self.alive = false
    end,
  }
end

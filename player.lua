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
    end,

    update=function(self)

      if self.death_anim != nil then
        self.death_anim:update()
      end

      if not self.alive then
        return
      end

      local left = 0
      local right = 1
      local up = 2
      local down = 3

      local dx = 0
      local dy = 0
      if btn(up) then
        self.bounds.pos.y -= 1
        dy = -1
      elseif btn(down) then
        self.bounds.pos.y += 1
        dy = 1
      end
      if btn(left) then
        self.bounds.pos.x -= 1
        dx = -1
      elseif btn(right) then
        self.bounds.pos.x += 1
        dx = 1
      end
      self.wobubble:update(dx, dy)

      self.invincibility_timer -= 1
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
      sfx(0)
      self.death_anim = death_animation(self.bounds.pos)
      self.alive = false
    end,
  }
end

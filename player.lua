-- Player movement. Requires bcirc.lua.

-- bcirc bounds

function player(spawnVec)
  return {
    bounds=bcirc(spawnVec, 5),
    trail=v2(0,0),
    points=0,
    size="small",
    alive=true,
    invincibility_timer=0,
    death_anim=nil,
    t=0,

    grow=function(self)
      self.bounds = bcirc(self.bounds.pos, 8)
      self.size = "big"
      self.points += 1
      -- should add a "thought" here as well
      -- that dissapears after a second or so
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

      if btn(up) then
        if(self.bounds.pos.y > 0) then
          self.bounds.pos.y -= 1
          self.trail.y = min(3, self.trail.y + 1.5)
        end
      elseif btn(down) then
        if(self.bounds.pos.y < 128) then
          self.bounds.pos.y += 1
          self.trail.y = max(-2, self.trail.y - 0.5)
        end
      end

      if btn(left) then
        if(self.bounds.pos.x > 0) then
          self.bounds.pos.x -= 1
          self.trail.x = min(3, self.trail.x + 1.5)
        end
      elseif btn(right) then
        if(self.bounds.pos.x < 128) then
          self.bounds.pos.x += 1
          self.trail.x = max(-2, self.trail.x - 0.5)
        end
      end
      
      self.trail *= 0.8
      self.t += 1
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
        local t = self.t
        local r = 4
        if self.size == "big" then
          r = 8
        end
        local rf = function(t) return r/4*(0.5+sin(cos(t/400))) end
        circ(x+self.trail.x,y+self.trail.y,r+rf(t-5),11)
        if t%2 == 0 then
          circ(x+self.trail.x/2,y+self.trail.y/2,r+rf(t-2),1)
        else
          circ(x+self.trail.x/2,y+self.trail.y/2,r+rf(t-2),3)
        end
        -- Draw the oil spot before the top layer.
        spr(17, x-(r+rf(t))*0.8, y-(r+rf(t))*0.8)
        circ(x,y,r+rf(t),2)
      end
    end,

    die=function(self)
      sfx(3)
      self.death_anim = death_animation(self.bounds.pos)
      self.alive = false
    end,
  }
end

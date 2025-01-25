-- Player movement. Requires bcirc.lua.

-- bcirc bounds
function player(spawnVec)
  return {

    bounds=bcirc(spawnVec, 5),
    prevx=-128,
    prevx=-128,
    points=0,
    size="small",
    alive=true,
    invincibility_timer=0,

    grow=function(self)
      self.bounds = bcirc(self.bounds.pos, 10)
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
      self.bounds = bcirc(self.bounds.pos, 5)
      self.size = "small"
    end,

    update=function(self)
      local left = 0
      local right = 1
      local up = 2
      local down = 3

      if self.bounds.pos != nil then
        self.prevx = self.bounds.pos.x
        self.prevy = self.bounds.pos.y
      end

      if btn(up) then
        self.bounds.pos.y -= 1
      elseif btn(down) then
        self.bounds.pos.y += 1
      end

      if btn(left) then
        self.bounds.pos.x -= 1
      elseif btn(right) then
        self.bounds.pos.x += 1
      end

      self.invincibility_timer -= 1
    end,

    draw=function(self)
      if (self.prevx != self.bounds.pos.x or self.prevy != self.bounds.pos.y) and (self.prevx != nil and self.prevy != nil) then
        if rnd() > 0.5 then
          circ(self.prevx+4, self.prevy+4, 4, 7)
        end
      end
      if(self.size == "small") then
        spr(1, self.bounds.pos.x, self.bounds.pos.y) -- small
      else
        spr(2, self.bounds.pos.x, self.bounds.pos.y, 2, 2) -- big
      end
    end,
    die=function(self)
      sfx(0)
      self.alive = false
    end,
  }
end

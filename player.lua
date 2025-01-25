-- Player movement. Requires bcirc.lua.

-- bcirc bounds
function player(bounds)
  return {
    bounds=bounds,
    update=function(self)
      local left = 0
      local right = 1
      local up = 2
      local down = 3

      if btn(up) then
        bounds.pos.y -= 1
      elseif btn(down) then
        bounds.pos.y += 1
      end

      if btn(left) then
        bounds.pos.x -= 1
      elseif btn(right) then
        bounds.pos.x += 1
      end
    end,
    draw=function(self)
      spr(0,bounds.pos.x,bounds.pos.y)
    end,
  }
end

-- A bounding circle class. Requires vector2.lua.

bcirc_meta={
  __index={
    colliding=function(self,other)
      local delta = self.pos - other.pos
      local length2 = delta.x*delta.x + delta.y*delta.y
      local radii_sum = self.radius + other.radius
      return length2 < (radii_sum * radii_sum)
    end
  },
}

-- vector2 pos, float radius
function bcirc(pos, radius)
  return setmetatable(
    {pos=pos,radius=radius},
    bcirc_meta
  )
end

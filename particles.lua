function particles(sprn, pos, n, vel)
  local parts = {}
  for i=1,n do
    add(parts, {
      pos=pos,
      vel=vel*(1+rnd()),
      dir=i/n+0.1*rnd(),
    })
  end
  return {
    sprn=sprn,
    pos=pos,
    n=n,
    parts=parts,
    fade_start=10,
    disappear_t=30,
    t=0,
    update=function(self)
      self.t+=1
      for part in all(self.parts) do
        part.pos += v2(part.vel*cos(part.dir),part.vel*sin(part.dir))
        part.vel *= 0.9
      end
    end,
    draw=function(self)
      if self.t >= self.disappear_t then
        return
      end
      if self.t < self.fade_start or self.t % 2 == 0 then
        for part in all(self.parts) do
          spr(self.sprn, part.pos.x - 4, part.pos.y -4)
        end
      end
    end,
  }
end

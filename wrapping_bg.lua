function wrapping_bg(tx,ty,map_size)
  return {
    tx=tx,
    ty=ty,
    offset=v2(0,0),
    velocity=velocity,
    map_size=map_size,
    scroll=function(self,d)
      self.offset += d
      if self.offset.x < 0 then
        self.offset.x += self.map_size*8
      elseif self.offset.x >= 8*self.map_size*8 then
        self.offset.x -= self.map_size*8
      end
      if self.offset.y < 0 then
        self.offset.y += self.map_size*8
      elseif self.offset.y >= self.map_size*8 then
        self.offset.y -= self.map_size*8
      end
    end,
    draw=function(self)
      map(self.tx,self.ty,-self.offset.x,-self.offset.y,self.map_size,self.map_size)
      map(self.tx,self.ty,self.map_size*8-self.offset.x,-self.offset.y,self.map_size,self.map_size)
      map(self.tx,self.ty,self.map_size*8-self.offset.x,self.map_size*8-self.offset.y,self.map_size,self.map_size)
      map(self.tx,self.ty,-self.offset.x,self.map_size*8-self.offset.y,self.map_size,self.map_size)
    end,
  }
end


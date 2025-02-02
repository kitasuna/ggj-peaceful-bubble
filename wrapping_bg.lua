function wrapping_bg(tx,ty,map_size)
  return {
    tx=tx,
    ty=ty,
    offset=v2(0,0),
    map_size=map_size,
    scroll=function(self,d)
      self.offset += d
      self.offset = v2(
        self.offset.x % (8*self.map_size),
        self.offset.y % (8*self.map_size)
      )
    end,
    draw=function(self)
      local tx,ty,ox,oy = self.tx, self.ty, self.offset.x, self.offset.y
      local size = self.map_size
      map(tx,ty,-ox,-oy,size,size)
      map(tx,ty,8*size-ox,-oy,size,size)
      map(tx,ty,8*size-ox,8*size-oy,size,size)
      map(tx,ty,-ox,8*size-oy,size,size)
    end,
  }
end


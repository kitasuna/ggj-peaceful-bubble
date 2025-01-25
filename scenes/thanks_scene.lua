-- thanks_scene(nxt)
-- * nxt : callback - call to pass control to the next scene
function thanks_scene(nxt)
  return {
    bubble = floating_bubble(56, 80, 5),
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
      self.bubble:update()
    end,
    draw = function(self)
      cls()
      local x,y=20,48
      print("\14 thank you\nfor playing",x,y+1,7)
      print("\14 thank you\nfor playing",x,y,2)
      self.bubble:draw()
    end,
  }
end

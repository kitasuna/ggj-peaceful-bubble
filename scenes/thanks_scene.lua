-- thanks_scene(nxt)
-- * nxt : callback - call to pass control to the next scene
function thanks_scene(nxt)
  return {
    bubble = floating_bubble(v2(64,68), 5, true),
    init = function(self)
      music_controller:stop()
    end,
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
      self.bubble:update()
    end,
    draw = function(self)
      cls()
      
      local x,y=20,28
      print("\14 thank you\nfor playing.",x,y+1,7)
      print("\14 thank you\nfor playing.",x,y,2)

      self.bubble:draw()

      local x,y=32,90
      print("and for existing.",x,y+1,7)
      print("and for existing.",x,y,2)

      print("❎ -> title", 40, 120, 7)
    end,
  }
end

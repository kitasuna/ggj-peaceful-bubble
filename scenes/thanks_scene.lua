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
      styled_text.title(" thank you\nfor playing.",x,y)

      self.bubble:draw()

      local x,y=32,90
      styled_text.body1("and for existing.",x,y)

      print("❎ -> title", 42, 120, 7)
    end,
  }
end

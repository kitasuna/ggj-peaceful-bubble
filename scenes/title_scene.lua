-- title(nxt)
-- * nxt : callback - call to pass control to the next scene
function title_scene(nxt)
  return {
    bubble = floating_bubble(56, 56, 5),
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
      self.bubble:update()
      return nil
    end,
    draw = function(self)
      cls()
      -- \14: use custom font
      print("\14what is it like \nto be a bubble?",6,11,11)
      print("\14what is it like \nto be a bubble?",5,10,2)
      self.bubble:draw()
      print("press ❎ to come into existence",3,100,2)
    end,
  }
end

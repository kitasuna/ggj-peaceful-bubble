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
      print("\^w\^twhat is it like \nto be a bubble?",11,11,12)
      print("\^w\^twhat is it like \nto be a bubble?",10,10,7)
      self.bubble:draw()
      print("press ❎ to come into existence",6,100,7)
    end,
  }
end

-- title(nxt)
-- * nxt : callback - call to pass control to the next scene
function title_scene(nxt)
  return {
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
      return nil
    end,
    draw = function(self)
      cls()
      print("\^w\^twhat is it like \nto be a bubble?",11,11,12)
      print("\^w\^twhat is it like \nto be a bubble?",10,10,7)
      spr(2, 56, 56, 2, 2)
      print("press ❎ to come into existence",6,100,7)
    end,
  }
end

-- credits_scene(nxt)
-- * nxt : callback - call to pass control to the next scene
function credits_scene(nxt)
  return {
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
    end,
    draw = function(self)
      cls()
      local x,y=3,3

      print("\14credits:",x,y+1,7)
      print("\14credits:",x,y,2)
      y+=16
      
      print("douglas",x,y+1,7)
      print("douglas",x,y,2)
      y+=8
      print("PROGRAMMING, STORY",x,y,14)
      y+=12
      
      print("eric",x,y+1,7)
      print("eric",x,y,2)
      y+=8
      print("PROGRAMMING, LEVEL DESIGN",x,y,14)
      y+=12
      
      print("josh",x,y+1,7)
      print("josh",x,y,2)
      y+=8
      print("PROGRAMMING",x,y,14)
      y+=12
      
      print("matt",x,y+1,7)
      print("matt",x,y,2)
      y+=8
      print("MUSIC, SFX, PROGRAMMING",x,y,14)
      y+=12
      
      print("shane",x,y+1,7)
      print("shane",x,y,2)
      y+=8
      print("ART",x,y,14)
      y+=12
    end,
  }
end

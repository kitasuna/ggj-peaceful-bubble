-- credits_scene(nxt)
-- * nxt : callback - call to pass control to the next scene
function credits_scene(nxt)
  return {
    init = function(self)
    end,
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
    end,
    draw = function(self)
      cls()
      local x,y=3,3

      styled_text.title('credits:',x,y)
      y+=16
      
      styled_text.body1('douglas',x,y)
      y+=8
      styled_text.body2("PROGRAMMING, STORY",x,y)
      y+=12
      
      styled_text.body1('eric',x,y)
      y+=8
      styled_text.body2("PROGRAMMING, LEVEL DESIGN",x,y)
      y+=12
      
      styled_text.body1("josh",x,y,2)
      y+=8
      styled_text.body2("PROGRAMMING",x,y)
      y+=12
      
      styled_text.body1("matt",x,y)
      y+=8
      styled_text.body2("MUSIC, SFX, PROGRAMMING",x,y)
      y+=12
      
      styled_text.body1("shane",x,y)
      y+=8
      styled_text.body2("ART",x,y)
      y+=12
    end,
  }
end

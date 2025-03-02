-- Create with this function, then add update() and draw() to the respetive
-- sections.

styled_text = {
  title = function(text,x,y)
    styled_text.body1("\14"..text,x,y)
  end,
  body1 = function(text,x,y)
    draw_with_shadow(7)
      (function()
        print(text,x,y,2)
      end)()
  end,
  body2 = function(text,x,y)
    print(text,x,y,14)
  end,
  caption = function(text,x,y)
    compose(
      draw_with_shadow(7),
      draw_with_outline(0)
    )(function()
      print(text,x,y,2)
    end)()
  end,
}

function bubbletext(text, pos)
  local char_ticks=4
  return {
    t=0,
    last_char=1,
    is_done=false,
    update=function(self)
      self.t += 1
      self.last_char = min(self.last_char + 1/char_ticks, #text)
      self.is_done = self.last_char >= #text
    end,
    draw=function(self)
      local dx,dy = 0,0
      for i=1,self.last_char do 
        local text_x = pos.x+dx+3*sin(self.t/100)
        local text_y = pos.y+dy+2*cos((4*i+self.t)/80)
        print(text[i], text_x, text_y+1, 12)
        print(text[i], text_x, text_y, 2)
        if text[i] == '\n' then
          dx = 0
          dy += 7
        else
          dx += 4
        end
      end
    end,
    -- show the rest of the text immediately without waiting
    reveal=function(self)
      self.last_char = #text
    end,
  }
end

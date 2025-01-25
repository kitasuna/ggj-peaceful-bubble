-- Create with this function, then add update() and draw() to the respetive
-- sections.
function bubbletext(text, pos)
  return {
    t=0,
    pos=pos,
    text=text,
    char_ticks=4,
    update=function(self)
      self.t += 1
    end,
    draw=function(self)
      last_char = flr(self.t/self.char_ticks)
      for i=1,#self.text do 
        if i > last_char then
          break
        end
        print(self.text[i],self.pos.x+(i-1)*6+3*sin(self.t/100),self.pos.y+2*cos((4*i+self.t)/80))
      end
    end,
  }
end

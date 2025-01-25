function intro(nxt)
  local thoughts = {
    "...",
    "i feel something",
    "what is this?",
    "i am a bubble",
    "why?",
    "what is the point of \nbeing here?",
    "bullets!",
    "aaaaaaaahhhhhh!"
  }
  local time_per_thought = 120
  local thought_index = 0
  return {
    t = 0,
    text = bubbletext("dasdasdas", v2(10, 10)),
    bubble = floating_bubble(56, 56, 5),
    update = function(self)
      self.t += 1

      -- skip by pressing x
      if btnp(❎) then
        return nxt()
      end

      --thought cycling
      thought_index = flr(self.t / time_per_thought) + 1
      if thought_index > #thoughts then
        return nxt()
      end
      self.text.text = thoughts[thought_index]
      self.text:update()
      self.bubble:update()
      return nil  -- continue
    end,
    draw = function(self)
      cls()      
      self.bubble:draw()
      self.text:draw()
    end,
  }
end

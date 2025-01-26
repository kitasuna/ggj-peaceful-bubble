function intro(nxt)
  local thoughts = {
    "...",
    "a thought",
    "a feeling",
    "what is reality?",
    "why am I here?",
    "why am I so bubbly?",
    "what is the reason\nfor my existence?",
    "light! heat! pain!",
    "i must continue existing!"
  }
  local time_per_thought = 120
  local thought_index = 0
  return {
    t = 0,
    text = bubbletext("dasdasdas", v2(10, 10)),
    bubble = floating_bubble(56, 56, 5),
    init = function(self)
      music_controller:play_song("liftoff")
    end,
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

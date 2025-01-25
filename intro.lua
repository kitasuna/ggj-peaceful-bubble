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
  local bubble_y_pos = 56
  local bubble_going_up = true
  local bubble_max_deviation = 5
  return {
    t = 0,
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

      --bubble movement
      if bubble_going_up then
        bubble_y_pos -= 0.1
      else
        bubble_y_pos += 0.1
      end
      if abs(bubble_y_pos - 56) > bubble_max_deviation then
        bubble_going_up = not bubble_going_up
      end

      return nil  -- continue
    end,
    draw = function(self)
      cls()
      local thought = thoughts[thought_index]
      print(thought,10,10,7)
      spr(2, 56, bubble_y_pos, 2, 2)
    end,
  }
end

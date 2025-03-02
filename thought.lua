function new_thought(thought)
  local base_time_per_thought = 80
  local time_per_letter = 3
  local thought_duration = base_time_per_thought + time_per_letter * #thought
  
  local function thought_placement(thought)
    local length_of_first_line = 0
    for i=1,#thought do
      if thought[i] == '\n' then
        break
      end
      length_of_first_line += 1
    end
    return v2(
      64 - 2 * length_of_first_line,
      20
    )
  end

  return flow.once(function(nxt)
    return {
      t = 0,
      max_t = thought_duration,
      text = bubbletext(thought, thought_placement(thought)),
      update = function(self)
        if btnp(❎) then
          if self.text.is_done then
            -- go to next thought
            return nxt()
          else
            -- skip to end of text
            self.text:reveal()
          end
        end
        self.t += 1
        if(self.t > self.max_t) then
          return nxt()
        end
        self.text:update()
      end,
      draw = function(self)
        self.text:draw()
      end, 
    }
  end)
end

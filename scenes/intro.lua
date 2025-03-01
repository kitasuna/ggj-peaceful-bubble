function intro(nxt)
  local thoughts = {
    "...",
    "...",
    "a thought",
    "a feeling",
    "what is reality?",
    "why am I here?",
    "why am I so bubbly?",
    "what is the reason\nfor my existence?",
    "light! heat! pain!",
    "i must continue existing"
  }
  local base_time_per_thought = 80
  local time_add_per_letter = 3
  return {
    current_thought_time = 0,
    max_time_for_current_thought = 0,
    text = bubbletext(thoughts[1], v2(10, 10)),
    bubble = floating_bubble(v2(64,64), 5, false),
    current_thought_id = 1,
    bg = star_background(),

    init = function(self)
      music_controller:play_song("liftoff")
      max_time_for_current_thought = base_time_per_thought + #thoughts[self.current_thought_id] * time_add_per_letter
    end,
    
    update = function(self)
      -- skip by pressing x
      if btnp(❎) then
        return nxt()
      end

      --thought cycling
      self.current_thought_time += 1
      if self.current_thought_time >= self.max_time_for_current_thought then
        self.current_thought_id += 1
        if self.current_thought_id > #thoughts then
          return nxt()
        end
        self.current_thought_time = 0
        thought_length = #thoughts[self.current_thought_id]
        self.max_time_for_current_thought = base_time_per_thought + thought_length * time_add_per_letter
        local length_of_first_line = 0
        for i=1,thought_length do
          if thoughts[self.current_thought_id][i] == '\n' then
            break
          end
          length_of_first_line += 1
        end
        text_x = 64 - 2 * length_of_first_line
        self.text = bubbletext(thoughts[self.current_thought_id], v2(text_x, 20))
      end
      self.text:update()

      --graphics
      self.bg:scroll(v2(0.2,0.2))
      self.bubble:update()
      return nil  -- continue
    end,

    draw = function(self)
      cls()
      self.bg:draw()
      self.bubble:draw()
      self.text:draw()
    end,

  }
end

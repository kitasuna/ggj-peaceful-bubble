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

function skip_button()
  local hold_max = 60
  -- keep track of how long the button has been held
  -- and how long its been since it was last pressed
  return {
    hold_t=0,
    show_t=0,
    is_done=false,
    is_visible=false,
    update=function(self)
      if btn(❎) or btn(🅾️) then
        self.hold_t += 1
        self.show_t = 60
      else
        self.hold_t = 0
        self.show_t -= 1
      end
      self.is_visible = self.show_t > 0
      self.is_done = self.hold_t >= hold_max
    end,
    draw=function(self)
      if not self.is_visible then return end
      -- show a progress bar, but include a "dead zone"
      local fac = (self.hold_t - 15) / (hold_max - 15)
      if fac > 0 then
        local w = 58
        rectfill(66,116,66+w*fac,125,4)
      end
      ui_text(function()
        print("skip (hold ❎)",68,118,2)
      end)()
    end,
  }
end

function intro(nxt)
  local thoughts = flow.seq({
    new_thought("..."),
    new_thought("..."),
    new_thought("a thought"),
    new_thought("a feeling"),
    new_thought("what is reality?"),
    new_thought("why am I here?"),
    new_thought("why am I so bubbly?"),
    new_thought("what is the reason\nfor my existence?"),
    new_thought("light! heat! pain!"),
    new_thought("i must continue existing"),
  })

  return {
    skip_button = skip_button(),
    bubble = floating_bubble(v2(64,64), 5, false),
    bg = star_background(),
    init = function(self)
      music_controller:play_song("liftoff")
      thoughts.run(
        function(thought) self.thought = thought end,
        nxt
      )
    end,
    
    update = function(self)
      self.skip_button:update()
      if self.skip_button.is_done then
        nxt()
      end
      self.bg:scroll(v2(0.2,0.2))
      self.bubble:update()
      self.thought:update()
    end,

    draw = function(self)
      cls()
      self.bg:draw()
      self.bubble:draw()
      self.thought:draw()
      self.skip_button:draw()
    end,
  }
end

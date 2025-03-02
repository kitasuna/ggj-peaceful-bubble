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
      styled_text.caption("skip (hold ❎)",68,118)
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

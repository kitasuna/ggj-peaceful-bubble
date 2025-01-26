-- clear_scene(nxt)
-- * nxt : callback - call to end the cutscene and pass control to the next scene
function clear_scene(nxt)

  local thoughts = {
    "here! i feel something",
    "this is it",
    "the meaning of it all",
    "is love"
  }
  local time_per_thought = 150
  local thought_index = 0

  return {
    time_on_current_thought = 0,
    text = bubbletext(thoughts[1], v2(10, 10)),
    bubble = floating_bubble(56, 56, 5, true),
    current_thought_idx = 1,

    init = function(self)
      music_controller:play_song("liftoff")
    end,

    update = function(self)
      self.time_on_current_thought += 1
      if(self.time_on_current_thought > time_per_thought) then
        self.time_on_current_thought = 0
        self.current_thought_idx += 1
        if self.current_thought_idx > #thoughts then
          return nxt()
        end
        self.text = bubbletext(thoughts[self.current_thought_idx], v2(10, 10))
      end
      self.text:update()
      self.bubble:update()
      return nil
    end,

    draw = function(self)
      cls()      
      self.bubble:draw()
      self.text:draw()
    end,
  }

end

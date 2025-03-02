-- clear_scene(nxt)
-- * nxt : callback - call to end the cutscene and pass control to the next scene
function clear_scene(nxt)

  local thoughts = flow.seq({
    new_thought("here! i feel something"),
    new_thought("this is it"),
    new_thought("the meaning of it all"),
    -- make this last on the screen longer by adding a bunch of whitespace
    new_thought("is love\n                      "),
  })

  return {
    bubble = floating_bubble(v2(64,64), 5, true),
    init = function(self)
      music_controller:play_song("liftoff")
      thoughts.run(
        function(thought) self.thought = thought end,
        nxt
      )
    end,
    update = function(self)
      self.thought:update()
      self.bubble:update()
    end,

    draw = function(self)
      cls()
      self.bubble:draw()
      self.thought:draw()
    end,
  }

end

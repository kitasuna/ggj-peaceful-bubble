-- cutscene(nxt)
-- * nxt : callback - call to end the cutscene and pass control to the next scene
function death_scene(nxt)

  local death_thoughts = {
    "was this all?",
    "i feel empty",
    "what was the point?",
    "i am a failure",
  }

  local random_thought = death_thoughts[flr(rnd(#death_thoughts))+1]

  return {
    t = 0,
    text=bubbletext(random_thought,v2(20,60)),
    init = function(self)
    end,
    update = function(self)
      self.t += 1
      self.text:update()
      -- Allow early exit with btn press.
      if btnp(❎) then
        nxt()
      end
      return nil  -- continue
    end,
    draw = function(self)
      cls()
      self.text:draw()
    end,
  }
end

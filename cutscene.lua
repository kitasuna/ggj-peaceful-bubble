-- cutscene(nxt)
-- * nxt : callback - call to end the cutscene and pass control to the next scene
function cutscene(nxt)
  return {
    t = 0,
    text=bubbletext("cutscene!",v2(20,60)),
    update = function(self)
      self.t += 1
      self.text:update()
      -- Allow early exit with btn press.
      if self.t > 120 or btn(4) or btn(5) then
        -- Go back to the level.
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

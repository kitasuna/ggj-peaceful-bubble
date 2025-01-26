-- clear_scene(nxt)
-- * nxt : callback - call to end the cutscene and pass control to the next scene
function clear_scene(nxt)
  return {
    t = 0,
    text=bubbletext("i did it!",v2(20,60)),
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

function cutscene()
  return {
    t = 0,
    update = function(self)
      self.t += 1
      -- Allow early exit with btn press.
      if self.t > 120 or btn(4) or btn(5) then
        -- Go back to the level.
        return level()
      end
      return nil  -- continue
    end,
    draw = function(self)
      cls()
      print("cutscene!",20,60)
    end,
  }
end

-- result_scene(nxt)
-- * nxt : callback - call to end the level pass control to the next scene
function result_scene(nxt)
  return {
    update = function(self)
      if btnp(❎) then
        nxt()
      end
    end,
    draw = function(self)
      cls()
      print("game over", 46, 64, 12)
    end,
  }
end

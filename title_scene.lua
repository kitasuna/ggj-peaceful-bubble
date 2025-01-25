-- title(nxt)
-- * nxt : callback - call to pass control to the next scene
function title_scene(nxt)
  return {
    update = function(self)
      if btnp(❎) then
        nxt()
      end
    end,
    draw = function(self)
      cls()
      print("press ❎ to start", 30, 64, 12)
    end,
  }
end

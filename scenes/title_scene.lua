-- title(nxt)
-- * nxt : callback - call to pass control to the next scene
function title_scene(nxt)
  return {
    bubble = floating_bubble(v2(64,64), 5),
    cloud_map=wrapping_bg(0,0,32),
    star_map=wrapping_bg(32,0,32),
    cloud_v=v2(0.1,0.25),
    star_v=v2(0.2,0.4),

    init = function(self)
      music_controller:play_song("liftoff")
    end,
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
      
      self.bubble:update()
      self.cloud_map:scroll(self.cloud_v)
      self.star_map:scroll(self.star_v)

      return nil
    end,
    draw = function(self)
      cls()

      self.cloud_map:draw()
      self.star_map:draw()

      print("\14what is it like",8,13,11)
      print("\14what is it like",7,12,2)

      print("\14to be a bubble?",6,27,11)
      print("\14to be a bubble?",5,26,2)

      self.bubble:draw()

      print("press ❎ to come",34,101,7)
      print("press ❎ to come",34,100,2)
      print("into existence",38,111,7)
      print("into existence",38,110,2)
    end,
  }
end

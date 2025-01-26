-- title(nxt)
-- * nxt : callback - call to pass control to the next scene
function title_scene(nxt)
  return {
    bubble = floating_bubble(56, 56, 5),
    
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
      -- \14: use custom font
      print("\14what is it like \nto be a bubble?",6,11,11)
      print("\14what is it like \nto be a bubble?",5,10,2)
      self.bubble:draw()
      print("press ❎ to come into existence",3,100,2)
    end,
  }
end

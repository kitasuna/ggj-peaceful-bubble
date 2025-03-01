-- title(nxt)
-- * nxt : callback - call to pass control to the next scene
function title_scene(nxt)
  return {
    bubble = floating_bubble(v2(64,64), 5),
    bg = star_background(),

    init = function(self)
      music_controller:play_song("liftoff")
    end,
    update = function(self)
      if btnp(❎) then
        return nxt()
      end
      
      self.bubble:update()
      self.bg:scroll(v2(0.2,0.4))

      return nil
    end,
    draw = function(self)
      cls()

      self.bg:draw()

      print("\14what is it like",8,13,11)
      print("\14what is it like",7,12,2)

      print("\14to be a bubble?",6,27,11)
      print("\14to be a bubble?",5,26,2)

      self.bubble:draw()

      print("press ❎ to come",33,101,7)
      print("press ❎ to come",33,100,2)
      print("into existence",37,111,7)
      print("into existence",37,110,2)
    end,
  }
end

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

      compose(
        draw_with_shadow(11,v2(1,1)),
        draw_with_outline(0)
      )(function()
        print("\14what is it like",7,12,2)
        print("\14to be a bubble?",5,26,2)
      end)()

      self.bubble:draw()

      styled_text.caption("press ❎ to come",33,100)
      styled_text.caption("into existence",37,110)
    end,
  }
end

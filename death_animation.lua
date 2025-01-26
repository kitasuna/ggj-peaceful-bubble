function death_animation(pos)

  local death_thoughts = {
    "was this all?",
    "i feel empty",
    "what was the point?",
    "i am a failure",
  }
  local thought_text = rnd(death_thoughts)

  return{

    frame=0,
    sprites={1, 33, 35, 37},
    current_sprite_id=1,
    animation_done=false,
    frames_per_sprite=3,
    thought=bubbletext(thought_text, pos),

    update=function(self)
      self.thought:update()
      if not self.animation_done then
        self.frame += 1
        if self.frame > self.frames_per_sprite then
          self.frame = 0
          self.current_sprite_id += 1
          if(self.current_sprite_id > #self.sprites) then
            self.animation_done = true
          end
        end
      end
    end,

    draw=function(self)
      self.thought:draw()
      if not self.animation_done then
        if(self.current_sprite_id == 1) then
          spr(self.sprites[self.current_sprite_id], pos.x, pos.y)
          return
        end
        spr(self.sprites[self.current_sprite_id], pos.x-4, pos.y-4, 2, 2)
      end
    end,

  }

end
draw_map_tiled = suspend(function(tx,ty,s)
  map(tx,ty, 0,   0,   s,s)
  map(tx,ty, 8*s, 0,   s,s)
  map(tx,ty, 0,   8*s, s,s)
  map(tx,ty, 8*s, 8*s, s,s)
end)

function bg_layer(tx,ty,map_size)
  local draw = draw_map_tiled(tx,ty,map_size)
  return {
    draw_effect=id,
    offset=v_zero,
    scroll=function(self,d)
      self.offset += d
      self.offset = v2(
        self.offset.x % (8*map_size),
        self.offset.y % (8*map_size)
      )
      return self
    end,
    effect=function(self,f)
      self.draw_effect = compose(self.draw_effect,f)
      return self
    end,
    draw=function(self)
      local effect = compose(
        self.draw_effect,
        draw_with_offset(-1*self.offset)
      )
      return effect(draw)
    end,
  }
end

function parallax_bg(layers)
  return {
    layers=layers,
    scroll=function(self,d)
      for i,l in ipairs(self.layers) do
        l:scroll(i/#self.layers * d)
      end
    end,
    draw=function(self)
      for l in all(self.layers) do
        l:draw()()
      end
    end,
  }
end

function star_background()
  return parallax_bg({
    -- distant stars
    bg_layer(32,0,32)
      :effect(draw_with_color(7)),
    -- distant clouds
    bg_layer(64,0,32)
      :effect(draw_with_palette(
        tbl_to_pal({[7]=-1})
      ))
      :scroll(v2(30,44)),
    -- middle stars
    bg_layer(32,0,32)
      :effect(draw_with_color(7)),
    -- middle clouds
    bg_layer(64,0,32)
      :effect(draw_with_palette(
        tbl_to_pal({[6]=-1})
      )),
    -- middle clouds
    bg_layer(64,0,32)
      :scroll(v2(-10,57))
      :effect(draw_with_palette(
        tbl_to_pal({[6]=-1, [7]=6})
      )),
    -- near stars
    bg_layer(32,0,32),
 })
end
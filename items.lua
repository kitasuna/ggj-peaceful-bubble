function new_item(posvec)
  local item = {
    draw = function(self)
      rectfill(
        self.pos.x,
        self.pos.y,
        self.pos.x+4,
        self.pos.y+4
      )
    end,
    update = function(self)

    end,
  }
  return merge(item, posvec)
end

function items(level)
  local items = {
    -- level 1
    {
      new_item(bcirc(v2(64,64), 5)),
      new_item(bcirc(v2(120,16), 5)),
      new_item(bcirc(v2(16,96), 5)),
    },
    -- add more below this...
  }
  return items[level]
end

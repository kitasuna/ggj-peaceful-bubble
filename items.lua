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

function items()
  return {
      new_item(bcirc(v2(112,112), 5)),
      new_item(bcirc(v2(32,32), 5)),
      new_item(bcirc(v2(112,24), 5)),
  }
end

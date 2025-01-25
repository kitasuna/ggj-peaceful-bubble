function _game_update()
  local result = state:update()
  if result == "dead" then
    state = level()
  end
end

function merge(t0, t1)
  local t2 = {}
  for k,v in pairs(t0) do
    t2[k] = v
  end
  for k,v in pairs(t1) do
    t2[k] = v
  end
  return t2
end

function _game_draw()
  state:draw()
end

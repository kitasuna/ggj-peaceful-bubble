function _game_update()
  -- __update()
  local now = time()
  local dt = now - last_ts
  

  foreach(emitters, function(e)
    e:update(dt)
  end)

  hero:update(dt)

  --[[
  if(btnp(0)) then
    emitter.cooldown += 0.1
  elseif(btnp(1)) then
    emitter.cooldown -= 0.1
  elseif(btnp(2)) then
    emitter.bullcount += 1
  elseif(btnp(3)) then
    emitter.bullcount -= 1
  end
  ]]--

  local allbulls = {}
  foreach(emitters, function(e)
    foreach(e.bulls, function(b)
      add(allbulls, b)
      end
    )
  end)
  local collisions = collision(hero.bounds, allbulls)
  if #collisions > 0 then
    hero:die()
    -- del(c, emitter.bulls)
    _init()
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
  cls()
  -- print("Hello World", 64, 64, 12)
  -- hero draw
  foreach(emitters, function(e)
    e:draw(dt)
  end)
  -- draw hero
  hero:draw()
end

-- Collision functions. Requires bcirc.lua.

-- bcirc hero, bcirc bullets[]
function collision(hero, bullets)
  local collisions = {}
  for id, bullet in pairs(bullets) do
    if hero:colliding(bullet) then
      add(collisions, id)
    end
  end
  return collisions
end

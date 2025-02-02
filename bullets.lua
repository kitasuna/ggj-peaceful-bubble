-- Requires bcirc, vector2.

function new_bullet(pos,vel)
  return merge({
    pos = pos,
    vel = vel,
    draw=function(b)
      spr(4, b.pos.x-4, b.pos.y-4)
    end,
    update=function(b,dt)
      b.pos += dt * b.vel
    end,
  }, bcirc(pos,2))
end

-- function new_bullets(count, start, target, base_angle, rot_f)
function new_bullets(count, start, target, base_angle, rot_f)
  local bulls = {}
  for i=1,count do
    local angle = rot_f(base_angle, i)
    local sinof, cosof = sin(angle/360), cos(angle/360)
    
    -- change the constant here to change spawning distance from emitter
    local pos = start + 5 * v2(cosof,sinof)
    local vel = 60 * v2(cosof, sinof)

    add(bulls,new_bullet(pos,vel))
  end
  return bulls
end

function new_aimed_bullets(count, start, target, _, _)
  local bulls = {}
  for i=1,count do
    local pos = start + v2(rnd(10)-5,rnd(10)-5)
    local diff = target - start
    local vel = 60 * 1.2 * diff:unit()
    add(bulls,new_bullet(pos,vel))
  end
  return bulls
end

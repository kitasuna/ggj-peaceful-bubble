-- Collision functions. Requires vector2.lua

-- "roundbox" collider
collider_meta = {
	__index={
		-- does the collider contain point p?
		contains=function(c,p)
			local q = p - c.p
			local d = v2(
				max(0, abs(q.x) - c.w/2),
				max(0, abs(q.y) - c.h/2)
			)
			return d:dot(d) <= c.r*c.r
		end,
	},
}

function collider(p,w,h,r)
	return setmetatable(
		{
			p=p, w=w, h=h, r=r
		},
		collider_meta
	)
end

function collider_diff(c1, c2)
	local p = c1.p - c2.p
	local r1, r2 = c1.r, c2.r
	local w1, w2 = c1.w - 2*r1, c2.w - 2*r2
	local h1, h2 = c1.h - 2*r1, c2.h - 2*r2
	return collider(
		p,
		w1 + w2 + 2*r1 + 2*r2,
		h1 + h2 + 2*r1 + 2*r2,
		r1+r2
	)
end

function collider_overlaps(c1,c2)
  return collider_diff(c1,c2):contains(v_zero)
end

function circle_collider(p,r)
	return collider(p,0,0,r)
end

function box_collider(p,w,h)
	return collider(p,w,h,0)
end

null_collider = collider(v_zero,-10,-10,0)


-- has collider hero, has collider bullets[]
function collision(hero, bullets)
  local collisions = {}
  local hero_collider = hero:collider()
  for bullet in all(bullets) do
    if collider_overlaps(hero_collider, bullet:collider()) then
      add(collisions, bullet)
    end
  end
  return collisions
end

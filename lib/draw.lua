function pal_to_tbl(f)
	local ret={}
	for i=0,15 do
		ret[i] = f(i)
	end
	return ret
end

function tbl_to_pal(tbl)
	return function(c)
		return tbl[c] or c
	end
end

function draw_with_offset(v)
	return suspend(function(draw)
		local cx,cy =	peek2(0x5f28, 2)
		camera(cx-v.x, cy-v.y)
		draw()
		poke2(0x5f28,cx,cy)
	end)
end

draw_pal = id
function draw_with_palette(p)
	return suspend(function(draw)
		local prev = draw_pal
		-- combine the old palette with the new one
		draw_pal = compose(p,draw_pal)
		for i=0,15 do
			pal(i,draw_pal(i))
			if i > 0 then
				palt(i,draw_pal(i) == -1)
			end
		end
		draw()
		-- restore the old palette
		palt()
		draw_pal = prev
		for i=0,15 do
			pal(i,draw_pal(i))
		end
	end)
end

function draw_with_color(c)
	return draw_with_palette(function(col)
		return col == 0
			and 0
			or c
	end)
end

function draw_with_outline(o)
	return suspend(function(draw)
		draw_with_color(o)(function()
			for i=-1,1 do
				for j=-1,1 do
					if abs(i) + abs(j) < 2 then
						draw_with_offset(v2(i,j))(draw)()
					end
				end
			end
		end)()
		draw()
	end)
end

function draw_with_shadow(s,off)
	off = off or v2(0,1)
	return suspend(function(draw)
		compose(
			draw_with_offset(off),
			draw_with_color(s)
		)(draw)()
		draw()
	end)
end

draw_spr = suspend(spr)

draw_seq = suspend(
	function(tbl)
		foreach(tbl, function(draw)
			draw()
		end)
	end
)
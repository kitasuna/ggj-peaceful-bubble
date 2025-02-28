function pal_to_tbl(f)
	local tbl = {}
	for i=0,15 do
		tbl[i] = f(i)
	end
	return tbl
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
		pal(pal_to_tbl(draw_pal))
		draw()
		-- restore the old palette
		draw_pal = prev
		pal(pal_to_tbl(draw_pal))
	end)
end

function draw_with_color(c)
	return draw_with_palette(const(c))
end

function draw_with_outline(o)
	return suspend(function(draw)
		-- get the current camera state
		local x,y = peek2(0x5f28,2)
		draw_with_color(o)(function()
			for i=-1,1 do
				for j=-1,1 do
					if abs(i) + abs(j) < 2 then
						camera(x-i,y-j)
						draw()
					end
				end
			end
		end)()
		-- restore the camera state
		camera(x,y)
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
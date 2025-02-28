function draw_with_offset(v)
	return suspend(function(draw)
		local cx,cy =	peek2(0x5f28, 2)
		camera(cx-v.x, cy-v.y)
		draw()
		poke2(0x5f28,cx,cy)
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
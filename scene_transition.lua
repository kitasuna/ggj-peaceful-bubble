function transition_flow(f)
	local prev
	return flow.create(function(nxt,done)
		f.run(function(cur)
			nxt(transition_scn(cur, prev))
			prev = cur
		end, done)
	end)
end

function transition_scn(cur,prv)
	local dur = bubble_wipe.dur
	local t = 0
	local t_0 = time()
	return {
		did_init = false,
		update=function(scn)
			local dt = time() - t_0
			t_0 = time()
			t += dt
			-- wait for transition to finish
			-- before running "update"
			if t < dur/2 and prv then
				return
			end
			if (t >= dur/2 or not prv) and not scn.did_init then
				cur:init()
				scn.did_init = true
			end
			cur:update()
		end,
		draw=function(scn)
			if not prv then
				cur:draw()
				return
			end
			-- draw a "wipe" transition
			if t < dur/2 then
				prv:draw()
				bubble_wipe.at(t)()
			elseif t > dur/2 and t <= dur then
				cur:draw()
				bubble_wipe.at(t)()
			elseif t > dur then
				cur:draw()
			end
		end,
	}
end

do
	local function bubble(x,y,r)
		return anim.linear
		:ease(function(t)
			return t*t
		end)
		:map(lerp(128+48,-48))
		:map(function(dy)
			return function()
				circfill(x,y+dy,r,14)
			end
		end)
	end
	
	local function bubble_group(r,n)
		local list = {}
		for i=1,n do
			list[i] = bubble(
				rrnd(-8,136),
				rrnd(-48+r,48-r),
				r
			):delay(rnd())
		end
		return anim.from_list(list)
			:map(draw_seq)
	end
	
	local small_bubbles  = bubble_group(8,16)
	local medium_bubbles = bubble_group(24,8)
	local large_bubbles  = bubble_group(48,3)
	local giant_bubble   = bubble(64,64,90):delay(0.75)
	
	-- layer a bunch of bubbles of different sizes
	bubble_wipe = anim.from_list({
		small_bubbles
			:scale(0.9),
		medium_bubbles
			:scale(0.8)
			:delay(0.4),
		large_bubbles
			:scale(0.7)
			:delay(0.7),
		giant_bubble
			:scale(0.5)
			:delay(0.6),
		medium_bubbles
			:scale(0.5)
			:delay(1),
		small_bubbles
			:scale(0.8)
			:delay(1),
	})
	:map(draw_seq)
	
	bubble_wipe = bubble_wipe
		:scale(1.5/bubble_wipe.dur)
	end

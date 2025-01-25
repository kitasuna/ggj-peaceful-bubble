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
	local dur = 0.5
	local t = 0
	local t_0 = time()
	return {
		update=function(scn)
			local dt = time() - t_0
			t_0 = time()
			t += dt
			-- wait for transition to finish
			-- before running "update"
			if t < dur and prv then
				return
			end
			cur:update()
		end,
		draw=function(scn)
			if not prv then
				cur:draw()
				return
			end
			-- draw a "wipe" transition
			if t < dur then
				prv:draw()
				local fac = t/dur
				local r = 92 * fac
				circfill(64,64,r,10)
			elseif t > dur and t <= 2*dur then
				cur:draw()
				local fac = (t-dur)/dur
				local r = 92 * (1-fac)
				circfill(64,64,r,10)
			elseif t > 2*dur then
				cur:draw()
			end
		end,
	}
end

flow = {}

flow_meta={
	__index={
		map=function(m,f)
			return flow.create(
				function(nxt, done)
					m.run(nxt, compose(f,done))
				end)
		end,
		flatmap=function(m,f)
			return flow.create(
				function(nxt, done)
					m:map(f).run(nxt, function(n)
						n.run(nxt, done)
					end)
				end)
		end,
		thru=function(m,f)
			return f(m)
		end,
	}
}

function flow.create(run_scn)
	return setmetatable({
		run=run_scn,
	},flow_meta)
end

function flow.of(value)
	return flow.create(function(nxt, done)
		done(value)
	end)
end

function flow.once(make_scene)
	return flow.create(function(nxt, done)
		nxt(make_scene(once(done)))
	end)
end

-- run a list of scenes in sequence, one after another
function flow.seq(scenes)
	local ret = flow.of(nil)
	for scn in all(scenes) do
		ret = ret:flatmap(const(scn))
	end
	return ret
end

-- run a scene flow, loop back to the beginning when finished
function flow.loop(m)
	return m:flatmap(function()
		return flow.loop(m)
	end)
end

-- animation
-- requires utils (id, const)

anim = {}

anim_meta = {
	__index = {
		map=function(a,f)
			return anim.create(
				function(t)
					return f(a.at(t))
				end,
				a.dur
			)
		end,
		apply=function(a,a2)
			return anim.create(function(t)
				local x = a.at(t)
				local f = a2.at(t)
				return f(x)
			end, min(a.dur, a2.dur))
		end,
		concat=function(a,a2)
			return anim.create(
				function(t)
					if t < a.dur then
						return a.at(t)
					end
					return a2.at(t-a.dur)
				end,
				a.dur + a2.dur
			)
		end,
		ease=function(a,f)
			return anim.create(
				function(t)
					return a.at(f(t))
				end,
				a.dur
			)
		end,
		scale=function(a,x)
			return anim.create(
				function(t)
					return a.at(t/x)
				end,
				x*a.dur
			)
		end,
		delay=function(a,d)
			return anim.create(
				function(t)
					return a.at(max(0,t-d))
				end,
				a.dur+d
			)
		end,
		loop=function(a)
			return anim.create(function(t)
				return a.at(t%a.dur)
			end, 32000)
		end,
		thru=function(a,f)
			return f(a)
		end
	}
}

function anim.create(at,dur)
	return setmetatable({
		at=at,
		dur=dur or 1,
	}, anim_meta)
end

anim.linear = anim.create(id)

function anim.const(x,d)
	return anim.create(const(x),d)
end

function anim.from_group(keys)
	return function(tbl)
		local dur = 0
		for k,v in keys(tbl) do
			dur = max(v.dur, dur)
		end
		local at = function(t)
			local ret = {}
			for k,v in keys(tbl) do
				ret[k] = v.at(t)
			end
			return ret
		end
		return anim.create(at,dur)
	end
end

anim.from_tbl  = anim.from_group(pairs)
anim.from_list = anim.from_group(ipairs)

function anim.concat(tbl)
	local ret	= anim.const(nil,0)
	for a in all(tbl) do
		ret = ret:concat(a)
	end
	return ret
end

function anim.from_frames(fs)
  return anim.create(function(t)
    return fs[1 + (t\1) % #fs]
  end, #fs)
end

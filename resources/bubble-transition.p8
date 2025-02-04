pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--bubble transition

function _init()
	a = bubble_transition
	tstart = time()
end

function _update60()
	if btnp(❎) then
		tstart = time()
	end
end

function _draw()
	cls()
--	print(a.dur)
	a.at(time() - tstart)()
end
-->8
-- library
function id(x) return x end

function const(x)
	return function() return x end
end

function lerp(a,b)
	return function(t)
		return a + t*(b-a)
	end
end

function draw_all(tbl)
	return function()
		for d in all(tbl) do
			d()
		end
	end
end

function rrnd(lo,hi)
	return lerp(lo,hi)(rnd())
end


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

-->8
do

local function bubble(x,y,r)
	return anim.linear
	:ease(function(t)
		return t*t
	end)
	:map(lerp(128+48,-48))
	:map(function(dy)
		return function()
			circfill(x,y+dy,r)
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
		:map(draw_all)
end

local small_bubbles  = bubble_group(8,16)
local medium_bubbles = bubble_group(24,8)
local large_bubbles  = bubble_group(48,3)
local giant_bubble   = bubble(64,64,90):delay(0.75)

bubble_transition = anim.from_list({
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
:map(draw_all)

bubble_transition = bubble_transition
	:scale(1.5/bubble_transition.dur)
end
__gfx__
00000000000000000070000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000770000000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000007777700007707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000700070000000000077777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000777770000000000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

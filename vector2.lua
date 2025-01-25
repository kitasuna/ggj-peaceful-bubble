-- 2d vector ------------------


function v_len(v)
	return sqrt(v:dot(v))
end

function v_unit(v)
	local fac=1/v:len()
	return v*fac
end

v2_meta={
	__mul=function(a,b)
		if type(b) == "number" then
			return a:scale(b)
		end
		if type(a) == "number" then
			return b:scale(a)
		end
	end,
	__add=function(u,v)
		return u:add(v)
	end,
	__sub=function(u,v)
		return u:sub(v)
	end,
	__index={
		len=v_len,
		unit=v_unit,
		add=function(u,v)
			return v2(u.x+v.x, u.y+v.y)
		end,
		sub=function(u,v)
			return v2(u.x-v.x, u.y-v.y)
		end,
		dot=function(u,v)
			return u.x*v.x + u.y*v.y
		end,
		scale=function(v,s)
			return v2(v.x*s, v.y*s)
		end,
		unpack=function(v)
			return v.x,v.y
		end
	},
}

function v2(x,y)
	return setmetatable(
		{x=x,y=y},
		v2_meta
	)
end

v_zero = v2(0,0)
v_x = v2(1,0)
v_y = v2(0,1)

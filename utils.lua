function new_cycler(cycle_ttl, colors) 
  return {
    cycle_ttl = cycle_ttl,
    colors = colors,
    update = function(self, dt)
      self.cycle_ttl -= dt 
      if self.cycle_ttl <= 0 then
        printh("expired!")
        local first = self.colors[1]
        for i=1,#self.colors-1 do
          printh("shuffled:"..self.colors[i]..","..self.colors[i+1])
          self.colors[i] = self.colors[i+1]
        end
        self.colors[#self.colors] = first
        for i=1,#self.colors do
          printh(self.colors[i])
        end
        self.cycle_ttl = cycle_ttl
      end
    end,
    get_color = function(self)
      return self.colors[self.current]
    end,
  }
end

function merge(t0, t1)
	local t2 = {}
	for k,v in pairs(t0) do
		t2[k] = v
	end
	for k,v in pairs(t1) do
		t2[k] = v
	end
	return t2
end

function const(x)
	return function()
		return x
	end
end

function compose(f,g)
	return function(...)
		return g(f(...))
	end
end

function once(f)
	local done
	return function(val)
		if not done then
			done = true
			f(val)
		end
	end
end

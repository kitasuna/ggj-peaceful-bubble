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

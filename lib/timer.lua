function new_timer(init_ttl, f)
  return {
    ttl = init_ttl,
    f = f,
    update = function(t, dt)
      if t.ttl == 0 then
        return
      end
      t.ttl = t.ttl - dt
      if t.ttl <= 0 then
        t.ttl = 0
        t:f()
      end
    end,
  }
end

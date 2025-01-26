function emitters(phase)
  local es = {
    {
      new_emitter(64, -8, 0.4, 0, 1, 1),
      new_emitter(-8, 64, 0, 0.4, 1, 1.1),
    },
    {
      new_emitter(64, -8, -0.4, 0, 2, 0.6),
      new_emitter(136, 64, 0, 0.4, 2, 0.7),
    },
    {
      new_emitter(130, 64, 0, 0, 10, 0.4, waves),
    },
  }
  return es[phase]
end

function emitters(phase)
  local es = {
    {
      -- new_emitter(120, 64, 0, 0.6, 1, 1),
      -- new_emitter(64, 120, -0.6, 0, 1, 1),
      new_emitter(128, 64, 0, 0.4, 1, 1),
      new_emitter(64, 128, 0.4, 0, 1, 1),
    },
    {
      new_emitter(64, -8, -0.4, 0, 2, 0.6),
      new_emitter(-8, 64, 0, 0.4, 2, 0.6),
    },
    {
      new_emitter(130, 64, 0, 0, 10, 0.4, waves),
    },
  }
  return es[phase]
end

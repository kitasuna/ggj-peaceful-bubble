function _init()
  last_ts = time()
  emitters = {
    new_emitter(64, -10),
    new_emitter(64, 138)
  }
  -- emitter = new_emitter(64, -10)
  -- emitter1 = new_emitter(64, 138)

  hero = player(bcirc(v2(0,64),5))

  _update60 = _game_update
  _draw = _game_draw
end

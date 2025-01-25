function _init()
  last_ts = time()
  emitter = new_emitter()

  hero = bcirc(v2(0,64),5)

  _update60 = _game_update
  _draw = _game_draw
end

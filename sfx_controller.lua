sfx_controller = {
  -- map from sound name to sfx index
  sounds = {
    ["bubble grow"] = 1,
    ["bubble shrink"] = 2,
    ["bubble pop"] = 3,
    ["explosion 1"] = 4,
    ["explosion 2"] = 5,
    ["alarm"] = 6,
  },
  play_sound = function(m,sound_name)
    sfx(m.sounds[sound_name])
  end,
}
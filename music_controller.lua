music_controller = {
  -- map from song name to pattern index
  songs = {
    ["liftoff"] = 0,
    ["zero_g"]  = 7,
  },
  -- start playing the named song
  -- if it's already playing, do nothing
  play_song = function(m,song_name)
    if song_name == m.song_name then
      return
    end
    m.song_name = song_name
    music(m.songs[song_name])
  end,
  -- stop the music
  stop = function(m)
    music(-1)
    m.song_name = nil
  end,
}
function _init()
  printh("__init__")

  -- define scenes
  -- and run them in sequence
  flow.seq({
    flow.once(title_scene),
    flow.once(intro),
    flow.once(level):thru(flow.loop),
  })
  :thru(flow.loop)
  :thru(transition_flow)
  .run(
    function(s)
      scene = s
    end
  )
end

function _update60()
  scene:update()
end

function _draw()
  scene:draw()
end
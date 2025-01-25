function _init()
  printh("__init__")

  local function game_flow()
    return flow.once(level)
      :flatmap(function(res)
        -- retry if the player died
        if res == "dead" then
          return flow.seq({
            flow.once(death_scene),
            game_flow(),
          })
        end
        -- otherwise, show the victory scene and proceed
        if res == "complete" then
          return flow.once(clear_scene)
        end
      end)
  end

  -- define scenes
  -- and run them in sequence
  flow.seq({
    flow.once(title_scene),
    flow.once(intro),
    game_flow(),
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
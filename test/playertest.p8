pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- putting this before the includes so editor palette is changed for artists
-- (who may not have the .lua includes).
function altpal()
  pal()
  pal({[0]=130,14,7,137,9,136,2,141,132,5,129,12,1,131,13,6},1)
end

altpal()
poke(0x5f2e,1)

#include ../lib/utils.lua
#include ../lib/anim.lua
#include ../lib/draw.lua
#include ../lib/vector2.lua
#include ../lib/collision.lua
#include ../player.lua
#include ../wobubble.lua
#include ../texteffects.lua
#include ../death_animation.lua
#include ../particles.lua
#include ../bullets.lua
#include ../lasers.lua


function _init()
  t0 = time()

  hero = player(v2(0,0))
  bullets = {
    new_bullet(v2(67,64),v_zero),
    new_bullet(v2(12,130),v_zero),
    new_bullet(v2(30,60),v_zero),
  }
  lasers = {
    new_laser(72)
  }
  has_collision = false
  
  sfx(0)
end

function _update60()
  local dt = time() - t0
  t0 = time()

  has_collision = #collision(hero, bullets) + #collision(hero, lasers) > 0
  hero:update()

  for l in all(lasers) do
    l:update(dt)
  end
end

function _draw()
  rectfill(0,0,127,127,0)
  for l in all(lasers) do
    l:draw()
  end
  for b in all(bullets) do
    b:draw()
  end
  circ(hero.pos.x,hero.pos.y,4, has_collision and 11 or 2)
end
__gfx__
00000000000000000000000000000000005555000000007117000000000000755700000000000051150000000000051221500000000051222215000000777000
00000000000000000000000000000000053333500000007117000000000000755700000000000051150000000000051221500000000051222215000000747000
00700700000000000000000000000000533443350000007117000000000000755700000000000051150000000000051221500000000051222215000007747700
00077000000000000000000000000000534224350000007117000000000000755700000000000051150000000000051221500000000051222215000007747700
00077000000000000000000000000000534224350000007117000000000000755700000000000051150000000000051221500000000051222215000007747700
00700700000000000000000000000000533443350000007117000000000000755700000000000051150000000000051221500000000051222215000077777770
00000000000000000000000000000000053333500000007117000000000000755700000000000051150000000000051221500000000051222215000077747770
00000000000000000000000000000000005555000000007117000000000000755700000000000051150000000000051221500000000051222215000077777770
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
00000000000000000000000000000000000000000000007117000000000000755700000000000051150000000000051221500000000051222215000000000000
__sfx__
35100000131201f1111f1101f1101f1101311113111131150010000100001000010000100001000022400631006210c621006210c223002230022300000000000000000000000000000027600000000000000000

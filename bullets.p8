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

#include _init.lua
#include utils.lua
#include flow.lua
#include scene_transition.lua
#include bcirc.lua
#include vector2.lua
#include collision.lua
#include bullets.lua
#include items.lua
#include emitters.lua
#include player.lua
#include floating_bubble.lua
#include texteffects.lua
#include wrapping_bg.lua
#include death_animation.lua

-- scenes
#include scenes/title_scene.lua
#include scenes/intro.lua
#include scenes/level.lua
#include scenes/death_scene.lua
#include scenes/clear_scene.lua
#include scenes/credits_scene.lua
#include scenes/thanks_scene.lua

__gfx__
0000000000222f000000022222200000005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200200021000200002f100000f2000054444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00022000212b00020021000000000200544444450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002200020b000020210000000000020544224450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200200200000020f000100000000f0544224450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000f00000bf2100122200000002544444450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002000b202000022b00000002054444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f22200200002b000000002005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001000020000000000000b2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000012b0000f000000000000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b00000200000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000002000000000b200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000002f00000bf2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000022222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000f0200000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000202000000000002000200f000002000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000f00000b00010000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000f0220f0000000000f0002f00000000000000000000f2000000000000000000000000000000000000000000000000000000000000000000000000
00000000000012100b20000000000210002000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000012b0002000000000000000200000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000f020200000000000002020000000000000000bf00000000000000000000000000000000000000000000000000000000000000000000000000
000000000002200000020000000000000ff202000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000f00000bf00000200f00000bf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000022f0000000000200200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000f2b200000000000002b20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000f000000000000222f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000b00000000000000020000000000000000b000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000020020000000000f000e00000b0000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000002000000000f000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000ccc000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccfccc0cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccffccccfccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccccceeeccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cceecccceeeeccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccceecccceefecc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccceefc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cccccc0ccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000fcc000ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066666666000000000000000006666660000000000008800000000000000000000000000000000000000000000000000000000000000000000000
00000000066666666666666000000000000666666666600000000085510000000000000000000000000000000000000000000000000000000000000000000000
00000006666666666666666660000000006666666666660000000085510000000000000000000000000000000000000000000000000000000000000000000000
00000066666666666666666666000000066666666666666000000885515000000000000000000000000000000000000000000000000000000000000000000000
00000666666666666666666666600000066666666666666000008885515500000000000000000000000000000000000000000000000000000000000000000000
00006666666666666666666666660000666666666666666600008885515100000000000000000000000000000000000000000000000000000000000000000000
0006666666666666666666666666600066666666666666660000888ef15100000000000000000000000000000000000000000000000000000000000000000000
006666666666666666666666666666006666666666666666000088ccbf5100000000000000000000000000000000000000000000000000000000000000000000
006666666666666600666600666666006666666666666666000088ccbf5100000000000000000000000000000000000000000000000000000000000000000000
066666666666666606666660666666606666666666666666000888ccbf5510000000000000000000000000000000000000000000000000000000000000000000
066666666666666666666666666666606666666666666666008888ccbf5551000000000000000000000000000000000000000000000000000000000000000000
06666666666666666666666666666660066666666666666008888555511555100000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666066666666666666088858888881555510000000000000000000000000000000000000000000000000000000000000000
666666666666666666666666666666660066666666666600888885555118888b0000000000000000000000000000000000000000000000000000000000000000
66666666666666660666666066666666000666666666600088558888888555110000000000000000000000000000000000000000000000000000000000000000
666666666666666600666600666666660000066666600000b5550cccecc05b1b0000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666000000000000000066666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666000000000000000066666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666000000000000000066666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666000000000000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006666666666666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000066666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000006666666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000000000000000000000000d200000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d200000000c0c1c2c3000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c2c3c4c500000000d0d1d1d3d20000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d1d3d4d500000000e0d1d1e3000000000000000000000000000000000000000000000000100010000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0d1d1e3c4c5000000c0c1d1d1f3000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f1f2d2d4d500c4c5d0d1d1d300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000d200000000d4d5e0d1d1e300000000000000000000000000000000000000000000100000000000000000000000000010000000001000000010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000d2f0f1f2f300000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c0c1c2c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d0d1d1d30000000000c4c5d200000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d2c4c5e0d2d1e30000000000d4d50000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000d4d5f0f1f2f3000000000000000000000000000000000000000000000000000010000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000d2c4c5000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d4d5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000010000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000001000100000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000100000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000040000001000000000000000000000000000001000000000000010000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

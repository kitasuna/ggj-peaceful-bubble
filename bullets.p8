pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include _init.lua
#include utils.lua
#include flow.lua
#include bcirc.lua
#include vector2.lua
#include collision.lua
#include bullets.lua
#include player.lua
#include level.lua
#include cutscene.lua
#include utils.lua

-- scenes
#include title_scene.lua
#include level.lua
#include result_scene.lua

__gfx__
00000000007776000000077777700000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007e0007000076e0000067000089999800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007007e7c0007007e000000000700899aa9980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700070c0000707e000000000007089a77a980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770007000000706000e000000006089a77a980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700600000c67e00e77700000007899aa9980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007000c707000077c00000007089999800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000677700700007c000000007008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000070000000000000c7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000600000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000700000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000007000000000c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007600000c67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000111000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111611101111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111661111611100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0011111111ddd1110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011dd1111dddd1110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111dd1111dd6d1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111dd61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111116000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111110111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00061100011111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000011111111000000000000000001111110000000000002200000000000000000000000000000000000000000000000000000000000000000000000
000000000111111111111110000000000001111111111000000000222e0000000000000000000000000000000000000000000000000000000000000000000000
000000011111111111111111100000000011111111111100000000222e0000000000000000000000000000000000000000000000000000000000000000000000
000000111111111111111111110000000111111111111110000002222e2000000000000000000000000000000000000000000000000000000000000000000000
000001111111111111111111111000000111111111111110000022222e2200000000000000000000000000000000000000000000000000000000000000000000
000011111111111111111111111100001111111111111111000022222e2e00000000000000000000000000000000000000000000000000000000000000000000
0001111111111111111111111111100011111111111111110000222d6e2e00000000000000000000000000000000000000000000000000000000000000000000
00111111111111111111111111111100111111111111111100002211c72e00000000000000000000000000000000000000000000000000000000000000000000
00111111111111110011110011111100111111111111111100002211c72e00000000000000000000000000000000000000000000000000000000000000000000
01111111111111110111111011111110111111111111111100022211c622e0000000000000000000000000000000000000000000000000000000000000000000
01111111111111111111111111111110111111111111111100222211c6222e000000000000000000000000000000000000000000000000000000000000000000
011111111111111111111111111111100111111111111110022222222ee222e00000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111101111111111111102222222222e2222e0000000000000000000000000000000000000000000000000000000000000000
111111111111111111111111111111110011111111111100222222222ee2222c0000000000000000000000000000000000000000000000000000000000000000
11111111111111110111111011111111000111111111100022222222222222ee0000000000000000000000000000000000000000000000000000000000000000
111111111111111100111100111111110000011111100000c2220111d1102cec0000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000011111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000011111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000011111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000011111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111111000000000000000011111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111111000000000000000011111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111111000000000000000011111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111111000000000000000011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000011111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000011111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000404100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0040410000505100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0050510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000404100005051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000505100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

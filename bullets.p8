pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include _init.lua
#include _game.lua
#include bcirc.lua
#include vector2.lua
#include collision.lua
#include bullets.lua
#include player.lua

__gfx__
00000000007776000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007e0007000076e0000067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007007e7c0007007e000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700070c0000707e0000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770007000000706000e0000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700600000c67e00e77700000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007000c707000077c00000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000677700700007c000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000070000000000000c7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000600000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000700000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000007000000000c700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007600000c67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--variables

function _init()
	p={
		sp=1,
		x=59,
		y=59,
		w=8,
		h=8,
		flp=false,
		dx=0,
		dy=0,
		max_dx=2,
		max_dy=3,
		acc=0.5,
		boost=4,
		anim=0,
		running=false,
		jumping=false,
		falling=false,
		sliding=false,
		landed=false,
	}
	
	gravity=0.3
	friction=0.85
	
	--simple camera
	cam_x=0
	
	--map limits
	map_start=0
	map_end=1024
end
-->8
--update and draw
function _update()
	p_update()
	p_animate()
	
	--simple camera
	cam_x=p.x-64+(p.w/2)
	if cam_x<map_start then
		cam_x=map_start
	end
	if cam_x>map_end-128 then
		cam_x=map_end-128
	end
	camera(cam_x,0)
end


function _draw()
	cls()
	map(0,0)
	spr(p.sp,p.x,p.y,1,1,p.flp)
end
-->8
--collisions

function collide_map(obj,aim,flag)
	--obj = table needs x,y,w,h
	--aim = left,right,up,down
	
	local x=obj.x local y=obj.y
	local w=obj.w local h=obj.h
	
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
		x1=x-1 y1=y
		x2=x   y2=y+h-1
	
	elseif aim=="right" then
		x1=x+w-1  y1=y
		x2=x+w    y2=y+h-1
	
	elseif aim=="up" then
		x1=x+2   y1=y-1
		x2=x+w-3 y2=y
	
	elseif aim=="down" then
		x1=x+2   y1=y+h
		x2=x+w-3 y2=y+h
	end
	
	--pixels to tiles
	x1/=8 y1/=8
	x2/=8 y2/=8
	
	if fget(mget(x1,y1), flag)
	or fget(mget(x2,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
		return true
	else
		return false
	end
	
end
-->8
--player

function p_update()
	--physics
	p.dy+=gravity
	p.dx*=friction
	
	--controls
	if btn(⬅️) then
		p.dx-=p.acc
		p.running=true
		p.flp=true
	end
	if btn(➡️) then
		p.dx+=p.acc
		p.running=true
		p.flp=false
	end
	
	--slide
	if p.running
	and not btn(⬅️)
	and not btn(➡️)
	and not p.falling
	and not p.jumping then
		p.running=false
		p.sliding=true
	end
	
	--jump
	if btn(❎)
	and p.landed then
		p.dy-=p.boost
		p.landed=false
	end
	
	-- check col ⬆️ and ⬇️
	if p.dy>0 then
		p.falling=true
		p.landed=false
		p.jumping=false
		
		p.dy=limit_speed(p.dy,p.max_dy)
		
		if collide_map(p,"down",0) then
			p.landed=true
			p.falling=false
			p.dy=0
			p.y-=((p.y+p.h+1)%8)-1
		end
	elseif p.dy<0 then
		p.jumping=true
		if collide_map(p,"up",1) then
			p.dy=0
		end
	end
	
	-- check col ⬅️ and ➡️
	if p.dx<0 then
		
		p.dx=limit_speed(p.dx,p.max_dx)
		
		if collide_map(p,"left",1) then
			p.dx=0
		end
	elseif p.dx>0 then
	
		p.dx=limit_speed(p.dx,p.max_dx)
	
		if collide_map(p,"right",1) then
			p.dx=0
		end
	end
	
	--stop sliding
	if p.sliding then
		if abs(p.dx) <.2
		or p.running then
			p.dx=0
			p.sliding=false
		end
	end
	
	p.x+=p.dx
	p.y+=p.dy
	
	--limit player to map
	if p.x<map_start then
		p.x=map_start
	end
	if p.x>map_end-p.w then
		p.x=map_end-p.w
	end
	
end

function p_animate()
	if p.jumping then
		p.sp=7
	elseif p.falling then
		p.sp=8
	elseif p.sliding then
		p.sp=9
	elseif p.running then
		if time()-p.anim>.1 then
			p.anim=time()
			p.sp+=1
			if p.sp>6 then
				p.sp=3				
			end
		end
	--player idle
	else
		if time()-p.anim>.3 then
			p.anim=time()
			p.sp+=1
			if p.sp>2 then
				p.sp=1				
			end
		end
	end
end

function limit_speed(num,m)
	return mid(-m,num,m)
end
__gfx__
00000000066000600660006006660006060600066006000660660006006600066660000660006000000000000000000000000000000000000000000000000000
00000000606ccc60606ccc606006ccc66066ccc60666ccc60606ccc60606ccc60066ccc606000600000000000000000000000000000000000000000000000000
00700700006736300067363000067363000673630006736300067363600673630006736306ccc600000000000000000000000000000000000000000000000000
00077000006ffff0006ffef00006ffef0006ffef0006ffef0006ffef0006ffef0006ffef06736300000000000000000000000000000000000000000000000000
0007700000066000006666000066660000666600006666000066660000666000000066600fffef00000000000000000000000000000000000000000000000000
00700700006776000607706006077060060770600607706006077060060770000000770600677660000000000000000000000000000000000000000000000000
00000000060d5060000d50000dd0500000d500000dd05000005d0000005d000000000d50060d5000000000000000000000000000000000000000000000000000
0000000000d0050000d005000000500000d5000000005000005d000005d00000000000d50000d550000000000000000000000000000000000000000000000000
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
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b33bbb33b3bbb333b333bb3bbbbb33b0bbbb3b3bbb3bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000
33223b323b33bb2233223b3233bbb323bb3b32323b323bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
222523222323b322222223b223bb3222bbb33222232233bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
222222222223322229222332223b3229bb32222d222223bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
222222d2222222922222223222232222b33222222922223b00000000000000000000000000000000000000000000000000000000000000000000000000000000
2922222222222222222212222f222222bb32f2222222223b00000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222d222222222222222222222332222222222e22300000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22922222292222222222d22222229222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222f22222255222222222222277772000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222225152292266222127d7d2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22d22222222225522225666222266662000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222d22222225555222226622000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
222222e2222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222221111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e2eee2eee2eee2eec1ccc1ccc1ccc1cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e2eee2eee2eee2eec1ccc1ccc1ccc1cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222221111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee2eee2eee2eee2ecc1ccc1ccc1ccc1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee2eee2eee2eee2ecc1ccc1ccc1ccc1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222221111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002ee20000000000001cc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002ee200002ee200001cc100001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002e2200002ee200001c1100001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002ee200002ee200001cc100001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002ee20000222200001cc10000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002ee200002ee200001cc100001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0022e200002ee2000011c100001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002ee200002ee200001cc100001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002ee200002ee200001cc100001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030300000000000000000000030303030000000000000000000000000101010100000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000006263620000000000000000000000000000000000000000000000000062620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000007200720000000000000000000000000000000000000000000000006262000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000006263620000000000000000000000000000000000000000000000626200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000007200720000000000000000000000000000000000000000000062620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000006263620000000000000000000000000000000000000000006262000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000007200720000000000000000000000000000000000000000626200000000000000000000000000000000000000000000000000000000000000000000000000004441414342450000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000006263620000000000000000000000000000000000000062620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000007200720000000000000000000000000000000000006262000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004344000000
0000000000000000000060000000000000000000000000000000000000000000000000006263620000000000000000000000000000000000626200000000000000000000000000000000000000000000000000000000000000000000000000000000000043404243450000000000000000000000000000000063005050000000
0000006363630000000071000000000000000000000000000000000000000000000000007200720000000000000000000000000000000062620000000000000000000000000000000000000000000000000000000000000000000000000000000000000050505052504500000000000000630063004300430000005050000000
0000000000720000616061606100000000000000000000000000000000006262000000006263620000000000000062620000000000006262000000000000626200006363000000006363630000006262000063000000636300006363000062620000630000005351525043450000626200000000005000500000005050006262
0000730000720000007000710000000000000000000000000000000000007372000000007200720000000000000073720000000000626200000000000000737200000000000000000000000000007372000000000000000000000000000073720000000000000000505051500000737200000000005000500000005050007372
0000724445730000007100700000000000000000000000000000000000007373000000006263620000000000000073730000000062620000000000000000737300000000000063000000000000007373006300000000000000000000000073730063000000000000000000000063737300000000005000500000000000637373
0000445053414500007000710000730000000000000000000000000000007273000000007200720000000000000072730000006262000000000000000000727300000000000000000000000000007273000000000000000000000000000072730000000000000000000000000000727300000000000000000000000000007273
4342505050505042434242434042434041424043424041424040434142404341414240434240414240404341424043414142404342404142404043414240434141424043424041424040434142404341414240434240414240404341424043414142404342404142404043414240434141424043424041424040434142404341
5150505051525050505053505250505050515052505050505053505150525051505150525050505050535051505250515051505250505050505350515052505150515052505050505053505150525051505150525050505050535051505250515051505250505050505350515052505150515052505050505053505150525051

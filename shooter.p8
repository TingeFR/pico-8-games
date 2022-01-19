pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
function _init()
	p={x=60,y=60,speed=2}
	bullets={}
	enemies={}
	explosions={}
	create_stars()
	spawn_enemies()
end

function _update60()
	if (btn(➡️)) p.x+=p.speed
	if (btn(⬅️)) p.x-=p.speed
	if (btn(⬆️)) p.y-=p.speed
	if (btn(⬇️)) p.y+=p.speed
	if (btnp(❎)) shoot()
	update_bullets()
	update_stars()
	if #enemies==0 then
		spawn_enemies()
	end
	update_enemies()
	update_explosions()
end

function _draw()
	cls()
	--stars
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	--vaisseau
	spr(1,p.x,p.y)
	--enemies
	for e in all(enemies) do
		spr(3,e.x,e.y)
	end
	--explosions
	draw_explosions()
	--bullets
	for b in all(bullets) do
		spr(2,b.x,b.y)
	end
end
-->8
--bullets

function shoot()
	new_bullet={
		x=p.x,
		y=p.y,
		speed=4,
	}
	add(bullets,new_bullet)
	sfx(0)
end

function update_bullets()
	for b in all(bullets) do
		b.y-=p.speed
		if b.y<-8 then
			del(bullets,b)
		end
	end
end
-->8
--stars

function create_stars()
	stars={}
	for i=1,13 do
		new_star={
			x=rnd(128),
			y=rnd(128),
			col=1,
			speed=0.5+rnd(1),
		}
		add(stars,new_star)
	end
	for i=1,9 do
		new_star={
			x=rnd(128),
			y=rnd(128),
			col=6,
			speed=2+rnd(2),
		}
		add(stars,new_star)
	end
end

function update_stars()
	for s in all(stars) do
		s.y+=s.speed
		if s.y > 128 then
			s.y=0
			s.x=rnd(128)
		end
	end
end
-->8
--enemies

function spawn_enemies()
	new_enemy={
		x=60,
		y=-20,
		life=4,
	}
	add(enemies,new_enemy)
end

function update_enemies()
	for e in all(enemies) do
		e.y+=0.3
		if e.y > 128 then
			del(enemies,e)
		end
		--collision
		for b in all(bullets) do
			if collision(e,b) then
				del(bullets,b)
				e.life-=1
				create_explosion(b.x+4,b.y+2)
				if e.life==0 then
					del(enemies,e)
				end
			end
		end
	end
end
-->8
--collisions

function collision(a,b)
	if a.x>b.x+8
	or a.y>b.y+8
	or a.x+8<b.x
	or a.y+8<b.y then
		return false
	else
		return true
	end
end
-->8
--explosions

function create_explosion(_x,_y)
	sfx(1)
	add(explosions,{x=_x,
																	y=_y,
																	timer=0})
end

function update_explosions()
	for e in all(explosions) do
		e.timer+=1
		if e.timer==13 then
			del(explosions,e)
		end
	end
end

function draw_explosions()
	circ(x,y,rayon,couleur)
	
	for e in all(explosions) do
		circ(e.x,e.y,e.timer/3,
							8+e.timer%3)
	end
end
__gfx__
0000000000dccd0000a00a0002000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dccd0000a00a002d2002d2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000db7d0000a00a002d2002d2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000cdb7dc000a00a002d2222d2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000cbb77c000a00a00228dd822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700dcbb77cd0000000002888820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cdccccdc0000000002ffff20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000008dccccd80000000002222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000295502b5502d5502d550265501d5501754016540135401253012520105100050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000100002462024630226301f6301b62018610186101861019600000000000000000000002a600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

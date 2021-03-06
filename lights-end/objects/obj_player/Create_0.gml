/// @desc

event_inherited();

#macro ARROWDISTANCE 64

enum ST_Player
{
	control,
	hurt, 
	
	grab_ghost,
	
	defeat0,	// Fall1
	defeat1,	// Bounce1
	defeat2,	// Fall2
	defeat3,	// Bounce2
}

spritesets = [
	{
		idle : spr_playerM_idle,
		shoot : spr_playerM_shoot,
		flash : spr_playerM_flash,
		run : spr_playerM_run,
		hurt : spr_playerM_hurt,
		kick : spr_playerM_kick,
		knockdown : spr_playerM_knockdown,
	
		grab_ghost : spr_playerM_grab_ghost,
	},
	{
		idle : spr_playerF_idle,
		shoot : spr_playerF_shoot,
		flash : spr_playerF_flash,
		run : spr_playerF_run,
		hurt : spr_playerF_hurt,
		kick : spr_playerF_kick,
		knockdown : spr_playerF_knockdown,
	
		grab_ghost : spr_playerF_grab_ghost,
	}
];

spriteset = spritesets[global.g_playercharacter];

input = INPUTP1;

radius = 32;

direction = 0;
aimdirection = 0;
movedirection = 0;
aimdirindex = 0;

movespeed = 6;
timesinceshot = 0;

aimlock = false;

refiretime = 8;
refiredelay = 0;

firebuffer = 0;
firebuffertime = 5;

iframes = 0;
iframestime = 180;

healthmax = 3;
healthpoints = healthmax;

batteriesmax = 3;
batteries = batteriesmax;

flashingstep = 0;
flashingsteptime = 30;

cankick = false;
kickingstep = 0;
kickingsteptime = 40;

movingstep = 0;
movingsteptime = 30;

collisionfilter |= FL_CollisionFilter.player;

image_speed = 0;

x = 0; y = 0; z = 0;

pressuremeter = 0;
pressuremetermax = 160;
mashstep = 0;
mashstepmax = 100;
grabenemyinst = noone;

grabbed = false;



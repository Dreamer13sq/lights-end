/// @desc Initialize Vars

#macro XSHAKETIME 16
#macro KICKFRAMES 10

enum FL_Entity
{
	shootable = 1 << 0,
	solid = 1<<1,
	hostile = 1<<2,
	kickable = 1<<3,
	wallbounce = 1<<4,
	
	pickup = 1<<5,
}

enum FL_Collision
{
	player = 1<<0,
	enemy = 1<<1,
}

shadowsprite = spr_shadow64;

image_speed = 0;

entityflag = 0;

tag = "";
trigger = "<no-trigger>";
active = true;

healthmax = 0;
healthpoints = 0;
damage = 0;
scorevalue = 0;
darkened = false;
kicked = false;

xshake = 0;

event_user(0);

xspeed = 0;
yspeed = 0;
zspeed = 0;

radius = 1;

state = 0;
statestart = 0;
statestep = 0;
z = 0;

autodepth = true;
depthoffset = 0;
collisionfilter = 0;

hitlist = ds_list_create();

lastdamageparams = [0, 0, 0];
lastdamagestep = 0;

drawmatrix = array_create(16);

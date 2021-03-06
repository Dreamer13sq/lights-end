/// @desc Methods & Functions

function SetHealthMax(value)
{
	healthmax = value;
	healthpoints = healthmax;
}

function Update(ts=1)
{
	
}

function Draw()
{
	var xx = x, yy = y;
	
	if (xshake > 0)
	{
		xx += 3 * Polarize(BoolStep(xshake, 4));
	}
	
	if (shadowsprite >= 0)
	{
		U_DrawMatrixClear();
		DrawBillboard(shadowsprite, 0, xx, yy, 0, LightsEndColor.dark);
	}
	
	U_DrawMatrix(drawmatrix);
	DrawBillboardExt(sprite_index, image_index, xx, yy, z, image_xscale, image_yscale);
}

function Draw3D()
{
	
}

function SetState(_state)
{
	state = _state;
	statestart = 1;
}

function PopStateStart()
{
	if (statestart) {statestart = 0; return true;}
	return false;
}

// Decrements health from entity
function DoDamage(value, angle=0, knockback=0)
{
	value = max(1, darkened? value div 2: value);
	
	SFXPlayAt(snd_hit, x, y);
	
	healthpoints = max(0, healthpoints-value);
	lastdamageparams[0] = value;
	lastdamageparams[1] = angle;
	lastdamageparams[2] = knockback;
	
	lastdamagestep = 5;
	
	OnDamage(value, angle, knockback);
	
	if (healthpoints == 0)
	{
		OnDefeat();
	}
}

function DoKick(angle)
{
	SetHitstop(KICKFRAMES);
	SetCameraShake(KICKFRAMES + 5);
	
	SFXPlayAt(snd_defeat, x, y);
	
	GFX_Kickpop(x, y, z);
	OnKick(angle);
}

function OnKick(angle)
{
	
}

function OnDamage(damage, angle, knockback)
{
	if (damage > 0)
	{
		xshake = XSHAKETIME;
	}
}

// Called when health is zero
function OnDefeat()
{
	instance_destroy();
}

function SetFlag(f) {entityflag |= f;}
function ClearFlag(f) {entityflag &= ~(f);}
function HasFlag(f) {return (entityflag & f) != 0;}
function UpdateFlags(activeflags, inertflags=0)
{
	entityflag |= activeflags;
	entityflag &= ~inertflags;
}

function GetHealth() {return healthpoints;}
function GetHealthMax() {return healthmax;}
function GetDamage() {return damage;}

function SetTags(_tag="", _trigger="")
{
	tag = _tag;
	trigger = _trigger;
	
	if (trigger != "")
	{
		active = false;
	}
}

function AnswerPoll(triggertag)
{
	if (trigger != "" && trigger == triggertag)
	{
		active = true;
		OnAnswer();
	}
}

function OnAnswer()
{
	
}

function EvaluateLineCollision()
{
	// Check lines
	ds_list_clear(hitlist);
	
	var intersect = [0, 0], dir;
	var n = collision_circle_list(x, y, 128, obj_lvl_line, false, true, hitlist, false);
	var e;
	
	var movedir = darctan2(xspeed, yspeed);
	var movespd = point_distance(0,0, xspeed, yspeed);
	var hit = false;
	
	for (var i = 0; i < n; i++)
	{
		e = hitlist[| i];
		if (!e.active) {continue;}
		if ( (e.collisionfilter & collisionfilter) == 0) {continue;}
		
		// Line
		if ( CircleOnLine(x, y, radius, e.x1, e.y1, e.x2, e.y2, intersect)	)
		{
			if (DotAngle(point_direction(intersect[0], intersect[1], x, y), e.normal) < 0)
			{
				dir = e.normal+180;
			}
			else
			{
				dir = e.normal;
			}
			
			x = intersect[0] + lengthdir_x(radius+1, dir);
			y = intersect[1] + lengthdir_y(radius+1, dir);
			movedir = dir;
			hit = true;
		}
		
		// Endpoints
		if ( point_distance(e.x1, e.y1, x, y) <= radius )
		{
			dir = point_direction(e.x1, e.y1, x, y);
			x = e.x1 + lengthdir_x(radius+1, dir);
			y = e.y1 + lengthdir_y(radius+1, dir);
			movedir = dir;
			hit = true;
		}
		
		if ( point_distance(e.x2, e.y2, x, y) <= radius )
		{
			dir = point_direction(e.x2, e.y2, x, y);
			x = e.x2 + lengthdir_x(radius+1, dir);
			y = e.y2 + lengthdir_y(radius+1, dir);
			movedir = dir;
			hit = true;
		}
	}
	
	// Bounce
	if (hit && HasFlag(FL_Entity.wallbounce))
	{
		xspeed = lengthdir_x(movespd, movedir);	
		yspeed = lengthdir_y(movespd, movedir);	
	}
	
	return hit;
	
}

function EvaluateRadius(r, obj = obj_entity)
{
	var hlist = hitlist;
	ds_list_clear(hlist);
	var n = 0;
	var xx = x, yy = y;
	
	with obj
	{
		if ( point_distance(xx, yy, x, y) <= radius+r )
		{
			ds_list_add(hlist, id);
			n += 1;	
		}
	}
	
	return n;
}

function DistanceTo(otherentity)
{
	return point_distance(x, y, otherentity.x, otherentity.y);	
}

function DirectionTo(otherentity) {return point_direction(x, y, otherentity.x, otherentity.y);}
function DirectionFrom(otherentity) {return point_direction(otherentity.x, otherentity.y, x, y);}

function NextState()
{
	SetState(state+1);	
}

function SetDrawMatrix(blend_col=0, blend_strength=0, fill_col=0, fill_strength=0)
{
	drawmatrix = [
		color_get_red(blend_col), color_get_green(blend_col), color_get_blue(blend_col), blend_strength,
		color_get_red(fill_col), color_get_green(fill_col), color_get_blue(fill_col), fill_strength,
		0,0,0,0,
		0,0,0,0,
	];
}

function U_DrawMatrix(drawmatrix)
{
	shader_set_uniform_f_array(obj_header.shd_billboard_drawmatrix, drawmatrix);	
}

function U_DrawMatrixClear()
{
	shader_set_uniform_f_array(obj_header.shd_billboard_drawmatrix, array_create(16));	
}

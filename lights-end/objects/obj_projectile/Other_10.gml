/// @desc Methods & Functions

event_inherited();

function Update(ts)
{
	x += lengthdir_x(projspeed, projdirection);
	y += lengthdir_y(projspeed, projdirection);
	
	// Progress life
	if (life > 0) {life = Approach(life, 0, ts);}
	else
	{
		instance_destroy();	
		return;
	}
	
	// Deal Damage
	var inst = instance_place(x, y, obj_enemy);
	if (inst)
	{
		if (inst.HasFlag(FL_Entity.shootable))
		{
			inst.DoDamage(damage);
			instance_destroy();
			return;
		}
		
	}
}

function Draw3D()
{
	DrawBillboard(spr_projectile, 0, x, y, z, c_yellow);
	
	return;
	
	matrix_set(matrix_world, Mat4Translate(x, y, z));
	draw_primitive_begin(pr_trianglelist);
	
	var w2s = WorldToScreenXY(x, y, z), xx = w2s[0], yy = w2s[1];
	
	var r = 10;
	var pts = [
		lengthdir_x(r, projdirection-90),
		lengthdir_y(r, projdirection-90),
		lengthdir_x(r, projdirection),
		lengthdir_y(r, projdirection),
		lengthdir_x(r, projdirection+90),
		lengthdir_y(r, projdirection+90),
		lengthdir_x(r*2, projdirection+180),
		lengthdir_y(r*2, projdirection+180),
	];
	
	draw_vertex_color(pts[0], pts[1], color, 1);
	draw_vertex_color(pts[2], pts[3], color, 1);
	draw_vertex_color(pts[4], pts[5], color, 1);
	
	draw_vertex_color(pts[4], pts[5], color, 1);
	draw_vertex_color(pts[6], pts[7], color, 1);
	draw_vertex_color(pts[0], pts[1], color, 1);
	
	draw_primitive_end();
}

function SetDirection(_dir)
{
	projdirection = _dir;
}


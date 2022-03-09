/// @desc

function EntityFromTag(entry)
{
	var inst = noone;
	
	switch(entry.entity)
	{
		// Internals
		case("player1"): 
			inst = instance_create_depth(entry.x, entry.y, 0, obj_lvl_playerspawn1);
			break;
		//case("player2"): inst = instance_create_depth(entry.x, entry.y, 0, obj_lvl_playerspawn2); break;
		
		// World
		case("trigger"): 
			inst = instance_create_depth(entry.x, entry.y, 0, obj_lvl_trigger)
				.SetBounds(entry.bounds[0], -entry.bounds[1], entry.bounds[2], -entry.bounds[3]);
			break;
		
		// Enemies
		case("ghost"): inst = instance_create_depth(entry.x, entry.y, 0, obj_enemy_ghostM); break;
		
	}
	
	print(entry.entity)
	if (inst)
	{
		inst.tag = entry.tag;
		inst.SetTrigger(entry.trigger);
	}
	
	return inst;
}

function DefineLine(x1, y1, x2, y2)
{
	return instance_create_depth(0,0,0, obj_lvl_line).SetLine(x1, y1, x2, y2);
}

function LoadLevel(jsonpath)
{
	var b = buffer_load(filename_change_ext(jsonpath, ".json"));
	
	if (b >= 0)
	{
		var outjson = json_parse(buffer_read(b, buffer_text));
		buffer_delete(b);
		
		var e;
		var n;
		
		// Lines
		var linejson = outjson.lines;
		n = array_length(linejson);
		
		for (var i = 0; i < n; i++)
		{
			e = linejson[i];
			DefineLine(e.x1, -e.y1, e.x2, -e.y2);
		}
		
		// Elements
		var elementjson = outjson.elements;
		n = array_length(elementjson);
		for (var i = 0; i < n; i++)
		{
			e = elementjson[i];
			EntityFromTag(e);
		}
		
	}
}

function LevelAnswerPoll(triggertag)
{
	with obj_lvlElement {AnswerPoll(triggertag);}
	with obj_entity {AnswerPoll(triggertag);}
}



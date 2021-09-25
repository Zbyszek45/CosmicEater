extends Node

enum {TOP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}


func get_rand_point(player_pos: Vector2) -> Vector2:
	var result: Vector2
	
	var side = randi()%4
	if side == LEFT: 
		result.y = (randi()% int(Global.wind_size.y*2)) + (player_pos.y - Global.wind_size.y)
		result.x = player_pos.x - Global.wind_size.x
	if side == RIGHT: 
		result.y = (randi()% int(Global.wind_size.y*2)) + (player_pos.y - Global.wind_size.y)
		result.x = player_pos.x + Global.wind_size.x
	if side == TOP:
		result.y = player_pos.y - Global.wind_size.y
		result.x = (randi()% int(Global.wind_size.x*2)) + (player_pos.x - Global.wind_size.x)
	if side == DOWN:
		result.y = player_pos.y + Global.wind_size.y
		result.x = (randi()% int(Global.wind_size.x*2)) + (player_pos.x - Global.wind_size.x)
	
	return result


func get_rand_point_top_down(player_pos: Vector2) -> Vector2:
	var result: Vector2
	
	var side = randi()%2
	if side == TOP:
		result.y = player_pos.y - Global.wind_size.y
		result.x = (randi()% int(Global.wind_size.x*2)) + (player_pos.x - Global.wind_size.x)
	if side == DOWN:
		result.y = player_pos.y + Global.wind_size.y
		result.x = (randi()% int(Global.wind_size.x*2)) + (player_pos.x - Global.wind_size.x)
	
	return result


extends Node

var wind_size: Vector2


func _ready():
	wind_size = get_viewport().get_visible_rect().size


func show_error(script_name, description):
	var error : String = ""
	error += "----------------ERROR-----------------"
	error += "\n"
	error += "######################################"
	error += "\n"
	error += "Script: " 
	error += "\n"
	error += script_name
	error += "\n"
	error += "Description:"
	error += "\n"
	error += description
	error += "\n"
	error += "######################################"
	error += "\n"
	print(error)
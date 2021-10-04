extends Node

# size of opened app window
var wind_size: Vector2

# how far from player will trigger destroy for spawnable and spawn things
var range_limit
var range_spawn: Vector2

# used to set the mile points for spawning enemies
var size_division = 1000

# base speed for all enemies, speed range is calculated by using this
var base_speed = 100

# scale number to see what can eat
var eat_limit = 0.05

# the size in pixels
var base_char_size = 88

# ai enums
enum AI_Action {ATTACKING, FLEEING, MOVING}

# skill enums
enum Skill {DASHIN, DASHOUT, SUMMON, PUFF}

# mutation enums
enum Mutation {SPEED, MAGIC, GROWTH, HUNGER}

# joystick configuration
enum JsSides {LEFT, RIGHT}
enum JsSizes {SMALL, MEDIUM, BIG, HUGE}
var js_side = JsSides.RIGHT
var js_size = JsSizes.MEDIUM

# save location if exists
const SAVE_NAME_PATH = "savegame.tres"
const SAVE_FOLDER_PATH = "user://save"

# used to check if game was just started up
var just_started: bool = true

# stores information whatever we should continue a previous save
var continue_save: bool = false

func _ready():
	wind_size = get_viewport().get_visible_rect().size
	range_spawn.x = (Global.wind_size.x/2) + (Global.base_char_size*2)
	range_spawn.y = (Global.wind_size.y/2) + (Global.base_char_size*2)
	range_limit = Vector2(0, 0).distance_to(wind_size) * 1.05


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


func load_save() -> Resource:
	var res = null
	var dir = Directory.new()
	if dir.file_exists(Global.SAVE_FOLDER_PATH.plus_file(Global.SAVE_NAME_PATH)):
		res = load(Global.SAVE_FOLDER_PATH.plus_file(Global.SAVE_NAME_PATH))
	
	# when save is loaded it shouldnt check anymore
	continue_save = false
	return res


func delete_save():
	var dir = Directory.new()
	if dir.file_exists(Global.SAVE_FOLDER_PATH.plus_file(Global.SAVE_NAME_PATH)):
		dir.remove(Global.SAVE_FOLDER_PATH.plus_file(Global.SAVE_NAME_PATH))

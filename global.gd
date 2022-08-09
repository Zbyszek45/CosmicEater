extends Node

var initial_player_save = preload("res://resources/saves/initial_player_save.tres")
var initial_settings_save = preload("res://resources/saves/initial_settings.tres")

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

# loaded player save
var player_save: AlaPlayerSave

# ai enums
enum AI_Action {ATTACKING, FLEEING, MOVING}

# skill enums
enum Skill {PUSH, PULL, PUSHAOE, PULLAOE}

# mutation enums
enum Mutation {SPEED, MAGIC, GROWTH, HUNGER}

# joystick configuration
enum JsSides {LEFT, RIGHT}
enum JsSizes {SMALL, MEDIUM, BIG, HUGE}
var js_side = JsSides.RIGHT
var js_size = JsSizes.MEDIUM

# audio
var sound
var music

# save location if exists
const SAVE_NAME_PATH = "savegame.tres"
const SAVE_FOLDER_PATH = "user://save"
const PLAYER_SAVE_PATH = "player_save.tres"
const SETTINGS_SAVE_PATH = "settings_save.tres"

# used to check if game was just started up
var just_started: bool = true

# stores information whatever we should continue a previous save
var continue_save: bool = false

func _ready():
	wind_size = get_viewport().get_visible_rect().size
	range_spawn.x = Global.wind_size.x * 1.2
	range_spawn.y = Global.wind_size.y * 1.2
	range_limit = Vector2(0, 0).distance_to(wind_size) * 1.05
	load_player_save()
	load_settings_save()


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


func save_player():
	var dir = Directory.new()
	if not dir.dir_exists(Global.SAVE_FOLDER_PATH):
		dir.make_dir_recursive(Global.SAVE_FOLDER_PATH)
	
	ResourceSaver.save(Global.SAVE_FOLDER_PATH.plus_file(Global.PLAYER_SAVE_PATH), player_save)


func load_player_save():
	var res = null
	var dir = Directory.new()
	if dir.file_exists(Global.SAVE_FOLDER_PATH.plus_file(Global.PLAYER_SAVE_PATH)):
		res = load(Global.SAVE_FOLDER_PATH.plus_file(Global.PLAYER_SAVE_PATH))
	else:
		res = initial_player_save
	
	player_save = res


func save_settings():
	var new_save = AlaSettingsSave.new()
	new_save.joystick_side = js_side
	new_save.joystick_size = js_size
	new_save.sounds = sound
	new_save.music = music
	
	
	var dir = Directory.new()
	if not dir.dir_exists(Global.SAVE_FOLDER_PATH):
		dir.make_dir_recursive(Global.SAVE_FOLDER_PATH)
	
	ResourceSaver.save(Global.SAVE_FOLDER_PATH.plus_file(Global.SETTINGS_SAVE_PATH), new_save)


func load_settings_save():
	var res: AlaSettingsSave = null
	var dir = Directory.new()
	if dir.file_exists(Global.SAVE_FOLDER_PATH.plus_file(Global.SETTINGS_SAVE_PATH)):
		res = load(Global.SAVE_FOLDER_PATH.plus_file(Global.SETTINGS_SAVE_PATH))
	else:
		res = initial_settings_save
	
	js_side = res.joystick_side
	js_size = res.joystick_size
	sound = res.sounds
	music = res.music

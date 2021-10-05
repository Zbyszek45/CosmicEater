extends Node2D

onready var dashin_timer = $DashInTimer
onready var dashout_timer = $DashOutTimer

var skill_dashin: int = 1
var skill_dashout: int = 1
var skill_summmon: int = 1
var skill_puff: int = 1

var can_dashin: bool = false
var can_dashout: bool = false
var can_puff: bool = false

var attack_area
var flee_area

var dashin_frames = 2

signal dashin
signal dashout

func _ready():
	dashin_timer.connect("timeout", self, "on_DashInTimer_timout")
	dashout_timer.connect("timeout", self, "on_DashOutTimer_timout")


func _physics_process(delta):
	check_dashin()
	check_dashout()


func check_dashin():
	if can_dashin and attack_area.smaller_bodies.size() > 0:
		$AreaWatcherDynamic.global_position = attack_area.smaller_bodies[0].global_position
		if dashin_frames <= 0 and not $AreaWatcherDynamic.is_dangerous():
			can_dashin = false
			dashin_timer.start()
			dashin_frames = 2
			emit_signal("dashin", attack_area.smaller_bodies[0].global_position)
		else:
			dashin_frames -= 1
	else:
		dashin_frames = 2


func check_dashout():
	if can_dashout and flee_area.is_dangerous():
		if not $AreaWatcher.is_dangerous():
			emit_signal("dashout", $AreaWatcher.global_position)
		elif not $AreaWatcher2.is_dangerous():
			emit_signal("dashout", $AreaWatcher2.global_position)
		elif not $AreaWatcher3.is_dangerous():
			emit_signal("dashout", $AreaWatcher3.global_position)
		elif not $AreaWatcher4.is_dangerous():
			emit_signal("dashout", $AreaWatcher4.global_position)
		else:
			return
		
		can_dashout = false
		dashout_timer.start()


func on_DashInTimer_timout():
	can_dashin = true


func on_DashOutTimer_timout():
	can_dashout = true


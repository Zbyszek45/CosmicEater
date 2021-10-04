extends Node2D

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

func _ready():
	$DashInTimer.connect("timeout", self, "on_DashInTimer_timout")


func _physics_process(delta):
	if can_dashin and attack_area.smaller_bodies.size() > 0:
		$AreaWatcherDynamic.global_position = attack_area.smaller_bodies[0].global_position
		if dashin_frames <= 0 and not $AreaWatcherDynamic.is_dangerous():
			can_dashin = false
			$DashInTimer.start()
			dashin_frames = 2
			emit_signal("dashin", attack_area.smaller_bodies[0].global_position)
		else:
			dashin_frames -= 1


func on_DashInTimer_timout():
	can_dashin = true


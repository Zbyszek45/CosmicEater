extends Node2D

var support_scene = preload("res://gameplay/player/support/Support.tscn")

onready var dashin_timer = $DashInTimer
onready var dashout_timer = $DashOutTimer
onready var puff_timer = $PuffTimer
onready var puff_duration_timer = $PuffDurationTimer

var skill_dashin: int = 1
var skill_dashout: int = 1
var skill_summon: int = 10
var skill_puff: int = 1

var can_dashin: bool = false
var can_dashout: bool = false
var can_puff: bool = false

var attack_area
var flee_area

var dashin_frames = 2

signal dashin
signal dashout
signal puff
signal stop_puff
signal summon

func _ready():
	dashin_timer.connect("timeout", self, "on_DashInTimer_timout")
	dashout_timer.connect("timeout", self, "on_DashOutTimer_timout")
	puff_timer.connect("timeout", self, "on_PuffTimer_timout")
	puff_duration_timer.connect("timeout", self, "on_PuffDurationTimer_timeout")
	
	#tmp
	call_deferred("spawn_support")


func _physics_process(delta):
	check_dashin()
	check_dashout()
	check_puff()


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


func check_puff():
	if can_puff and flee_area.is_dangerous():
		emit_signal("puff", 2.0)
		puff_duration_timer.start()
		can_puff = false


func spawn_support():
	GameEvents.emit_signal("spawn_support", support_scene, skill_summon)


func on_DashInTimer_timout():
	can_dashin = true


func on_DashOutTimer_timout():
	can_dashout = true


func on_PuffTimer_timout():
	can_puff = true


func on_PuffDurationTimer_timeout():
	emit_signal("stop_puff")
	puff_timer.start()

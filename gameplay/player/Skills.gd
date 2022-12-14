extends Node2D


onready var push_timer = $PushTimer
onready var pull_timer = $PullTimer
onready var push_aoe_timer = $PushAoeTimer
onready var pull_aoe_timer = $PullAoeTimer
onready var update_skills_timer = $UpdateSkillsTimer
onready var push_aoe_particles = $PushAoeParticles
onready var pull_aoe_particles = $PullAoeParticles
onready var push_particles = $PushParticles
onready var pull_particles = $PullParticles


var skill_push: int = 0
var skill_pull: int = 0
var skill_push_aoe: int = 0
var skill_pull_aoe: int = 0


var time_reload_push_base = 10
var time_reload_pull_base = 10
var time_reload_push_aoe_base = 20
var time_reload_pull_aoe_base = 20

var time_reload_push
var time_reload_pull
var time_reload_push_aoe
var time_reload_pull_aoe


var push_force: int = 2500
var pull_force: int = 2500
var push_aoe_force: int = 1000
var pull_aoe_force: int = 1000


var flee_area

var mutation_magic_value


signal push
signal pull
signal push_aoe
signal pull_aoe

func _ready():
	push_timer.connect("timeout", self, "on_PushTimer_timout")
	pull_timer.connect("timeout", self, "on_PullTimer_timout")
	push_aoe_timer.connect("timeout", self, "on_PushAoeTimer_timout")
	pull_aoe_timer.connect("timeout", self, "on_PullAoeTimer_timout")
	
	
	update_skills_timer.connect("timeout", self, "on_update_skills_timer")
	
	GameEvents.connect("skill_selected", self, "_skill_selected")
	
	#set_reload_timers()


func _skill_selected(skill, levels):
	if skill == Global.Skill.PUSH:
		skill_push += levels
	elif skill == Global.Skill.PULL:
		skill_pull += levels
	elif skill == Global.Skill.PUSHAOE:
		skill_push_aoe += levels
	elif skill == Global.Skill.PULLAOE:
		skill_pull_aoe += levels
	
	set_reload_timers()
	_set_color()
	
	if skill == Global.Skill.PUSH:
		push_timer.start()
	elif skill == Global.Skill.PULL:
		pull_timer.start()
	elif skill == Global.Skill.PUSHAOE:
		push_aoe_timer.start()
	elif skill == Global.Skill.PULLAOE:
		pull_aoe_timer.start()
	


func set_reload_timers():
	time_reload_push = ((time_reload_push_base*100.0)/(100+skill_push)) as float
	time_reload_pull = ((time_reload_pull_base*100.0)/(100+skill_pull)) as float
	time_reload_push_aoe = ((time_reload_push_aoe_base*100.0)/(100+skill_push_aoe)) as float
	time_reload_pull_aoe = ((time_reload_pull_aoe_base*100.0)/(100+skill_pull_aoe)) as float
	
	
	time_reload_push = (time_reload_push * 100) / (100 + mutation_magic_value)
	time_reload_pull = (time_reload_pull * 100) / (100 + mutation_magic_value)
	time_reload_push_aoe = (time_reload_push_aoe * 100) / (100 + mutation_magic_value)
	time_reload_pull_aoe = (time_reload_pull_aoe * 100) / (100 + mutation_magic_value)
	
	push_timer.wait_time = time_reload_push
	pull_timer.wait_time = time_reload_pull
	push_aoe_timer.wait_time = time_reload_push_aoe
	pull_aoe_timer.wait_time = time_reload_pull_aoe
	
	GameEvents.emit_signal("skills_max_reload_time_update" \
	, time_reload_push, time_reload_pull, time_reload_push_aoe, time_reload_pull_aoe)


func _set_color():
	var change = 0.01
	var rg_push = 1.0 - (change * skill_push)
	if rg_push < 0: rg_push = 0.0
	var rg_pull = 1.0 - (change * skill_pull)
	if rg_pull < 0: rg_pull = 0.0
	var rg_push_aoe = 1.0 - (change * skill_push_aoe)
	if rg_push_aoe < 0: rg_push_aoe = 0.0
	var rg_pull_aoe = 1.0 - (change * skill_pull_aoe)
	if rg_pull_aoe < 0: rg_pull_aoe = 0.0
	
	push_particles.modulate = Color(rg_push, rg_push, 1, 1)
	pull_particles.modulate = Color(rg_pull, rg_pull, 1, 1)
	push_aoe_particles.modulate = Color(rg_push_aoe, rg_push_aoe, 1, 1)
	pull_aoe_particles.modulate = Color(rg_pull_aoe, rg_pull_aoe, 1, 1)


func on_PushTimer_timout():
	if get_tree().get_nodes_in_group("avoidable").size() > 0:
		var x = get_tree().get_nodes_in_group("avoidable")[0]
		
		# parrticles
		push_particles.look_at(x.global_position)
		push_particles.restart()
		push_particles.emitting = true
		
		var dir:Vector2 = x.global_position - global_position
		if x.has_method("push"):
			x.push(dir.normalized() * push_force)


func on_PullTimer_timout():
	if get_tree().get_nodes_in_group("attackable").size() > 0:
		var x = get_tree().get_nodes_in_group("attackable")[0]
		
		# parrticles
		pull_particles.look_at(x.global_position)
		pull_particles.restart()
		pull_particles.emitting = true
		
		var dir:Vector2 = global_position - x.global_position
		if x.has_method("push"):
			x.push(dir.normalized() * pull_force)


func on_PushAoeTimer_timout():
	push_aoe_particles.restart()
	push_aoe_particles.emitting = true
	for i in get_tree().get_nodes_in_group("avoidable"):
		var dir:Vector2 = i.global_position - global_position
		if i.has_method("push"):
			i.push(dir.normalized() * push_aoe_force)


func on_PullAoeTimer_timout():
	pull_aoe_particles.restart()
	pull_aoe_particles.emitting = true
	for i in get_tree().get_nodes_in_group("attackable"):
		var dir:Vector2 = global_position - i.global_position
		if i.has_method("push"):
			i.push(dir.normalized() * pull_aoe_force)


func on_update_skills_timer():
	GameEvents.emit_signal("skills_reload_time_update" \
	, push_timer.time_left, pull_timer.time_left, push_aoe_timer.time_left, pull_aoe_timer.time_left)


func on_load():
	set_reload_timers()
	_set_color()
	if skill_push > 0:
		push_timer.start()
	if skill_pull > 0:
		pull_timer.start()
	if skill_push_aoe > 0:
		push_aoe_timer.start()
	if skill_pull_aoe > 0:
		pull_aoe_timer.start()

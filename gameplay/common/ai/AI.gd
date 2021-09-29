extends Node2D
class_name AI

const AI_ATTACK = "attack_action"
const AI_FLEE = "flee_action"
const AI_MOVE = "move_action"

onready var flee_area = $FleeArea
onready var attack_area = $AttackArea
onready var action_timer = $ActionTimer

var first_action = ""
var second_action = ""
var third_action = ""

var attack_probality: float = 1.0
var flee_probality: float = 1.0

var bodies_attack = []
var bodies_flee = []

signal attack
signal flee
signal move

func _ready():
	action_timer.connect("timeout", self, "take_action")
	attack_area.connect("body_entered", self, "on_body_AttackArea_entered")
	flee_area.connect("body_entered", self, "on_body_FleeArea_entered")
	attack_area.connect("body_exited", self, "on_body_AttackArea_exited")
	flee_area.connect("body_exited", self, "on_body_FleeArea_exited")

func set_priority(first, second, third):
	if first != AI_ATTACK and first != AI_FLEE and first != AI_MOVE:
		Global.show_error("res://gameplay/common/ai/AI.gd", "first is not properly set")
	if second != AI_ATTACK and second != AI_FLEE and second != AI_MOVE:
		Global.show_error("res://gameplay/common/ai/AI.gd", "second is not properly set")
	if third != AI_ATTACK and third != AI_FLEE and third != AI_MOVE:
		Global.show_error("res://gameplay/common/ai/AI.gd", "thinrd is not properly set")
	
	first_action = first
	second_action = second
	third_action = third


func set_probality(_attack_probality, _flee_probality):
	attack_probality = _attack_probality as float
	flee_probality = _flee_probality as float


func set_action_time(time: float):
	action_timer.wait_time = time


func start_ai():
	action_timer.start()
	flee_area.monitoring = true
	attack_area.monitoring = true


func stop_ai():
	action_timer.stop()
	flee_area.monitoring = false
	attack_area.monitoring = false


func on_body_AttackArea_entered(body: Node):
	if body.has_method("get_scale"):
		if get_parent().can_eat(body.get_scale()):
			bodies_attack.append(body)
	else:
		Global.show_error("res://gameplay/common/ai/AI.gd", "Body don't have method: "+body.name)


func on_body_FleeArea_entered(body: Node):
	if body.has_method("can_eat"):
		if body.can_eat(get_parent().get_scale()):
			bodies_flee.append(body)
	else:
		Global.show_error("res://gameplay/common/ai/AI.gd", "Body don't have method: "+body.name)


func on_body_AttackArea_exited(body: Node):
	bodies_attack.erase(body)


func on_body_FleeArea_exited(body: Node):
	bodies_flee.erase(body)


func take_action():
	var should_stop = false
	var probality: float = randf()
	should_stop = call(first_action, probality)
	if should_stop:
		return
	should_stop = call(second_action, probality)
	if should_stop:
		return
	should_stop = call(third_action, probality)


func attack_action(probality):
	if bodies_attack.size() > 0:
		if probality < attack_probality:
			emit_signal("attack", bodies_attack[0])
		else:
			emit_signal("move")
		return true
	else:
		return false


func flee_action(probality):
	if bodies_flee.size() > 0:
		if probality < flee_probality:
			emit_signal("flee", bodies_flee[0])
		else:
			emit_signal("move")
		return true
	else:
		return false


func move_action(probality):
	emit_signal("move")

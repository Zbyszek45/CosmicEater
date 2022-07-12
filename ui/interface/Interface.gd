extends Control


onready var joystick = $JoystickAnchor/Joystick
onready var size_label = $HBoxContainer/SizeLabel
onready var time_label = $TimerLabel
onready var pause_button = $HBoxContainer/PauseButton
onready var push_button = $SkillsLeft/PushButton
onready var pull_button = $SkillsLeft/PullButton
onready var push_aoe_button = $SkillsRight/PushAoeButton
onready var pull_aoe_button = $SkillsRight/PullAoeButton

func _ready():
	GameEvents.connect("player_grew_up", self, "_update_size")
	GameEvents.connect("time_changed", self, "_update_time_label")
	pause_button.connect("pressed", self, "pause_game")
	GameEvents.connect("skills_reload_time_update", self, "update_skills_timers")
	GameEvents.connect("skills_max_reload_time_update", self, "update_max_skills_timers")
#	dashin_button.connect("pressed", self, "on_skill_pressed", [Global.Skill.DASHIN])
#	dashout_button.connect("pressed", self, "on_skill_pressed", [Global.Skill.DASHOUT])
#	puff_button.connect("pressed", self, "on_skill_pressed", [Global.Skill.PUFF])
#	summon_button.connect("pressed", self, "on_skill_pressed", [Global.Skill.SUMMON])
	
	if Global.js_side == Global.JsSides.LEFT:
		time_label.align = Label.ALIGN_RIGHT
	else:
		time_label.align = Label.ALIGN_LEFT


func _update_size(size: int, amount: float):
	size_label.text = "Size: " + str(size)


func _update_time_label(time):
	time_label.text = "Time: " + time


func pause_game():
	GameEvents.emit_signal("show_popup_pause")


func on_load(save: AlaGameSave):
	size_label.text = "Size: " + str(save.player_size)


func update_skills_timers(push_timeleft: float, pull_timeleft: float\
	, push_aoe_timeleft: float, pull_aoe_timeleft: float):
	push_button.progress.value = push_timeleft
	pull_button.progress.value = pull_timeleft
	push_aoe_button.progress.value = push_aoe_timeleft
	pull_aoe_button.progress.value = pull_aoe_timeleft


func update_max_skills_timers(push_timeleft, pull_timeleft,\
	push_aoe_timeleft, pull_aoe_timeleft):
	push_button.progress.max_value = push_timeleft
	pull_button.progress.max_value = pull_timeleft
	push_aoe_button.progress.max_value = push_aoe_timeleft
	pull_aoe_button.progress.max_value = pull_aoe_timeleft

#func on_skill_pressed(skill):
#	if skill == Global.Skill.DASHIN:
#		pass
#	elif skill == Global.Skill.DASHOUT:
#		pass
#	elif skill == Global.Skill.PUFF:
#		pass
#	elif skill == Global.Skill.SUMMON:
#		pass

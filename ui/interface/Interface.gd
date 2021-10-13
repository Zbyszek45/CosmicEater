extends Control


onready var joystick = $JoystickAnchor/Joystick
onready var size_label = $HBoxContainer/SizeLabel
onready var time_label = $TimerLabel
onready var pause_button = $HBoxContainer/PauseButton
onready var dashin_button = $SkillsLeft/DashInButton
onready var dashout_button = $SkillsLeft/DashOutButton
onready var puff_button = $SkillsRight/PuffButton
onready var summon_button = $SkillsRight/SummonButton

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


func update_skills_timers(dashin_timeleft: float, dashout_timeleft: float, puff_timeleft: float):
	dashin_button.progress.value = dashin_timeleft
	dashout_button.progress.value = dashout_timeleft
	puff_button.progress.value = puff_timeleft


func update_max_skills_timers(dashin_timeleft, dashout_timeleft, puff_timeleft):
	dashin_button.progress.max_value = dashin_timeleft
	dashout_button.progress.max_value = dashout_timeleft
	puff_button.progress.max_value = puff_timeleft

#func on_skill_pressed(skill):
#	if skill == Global.Skill.DASHIN:
#		pass
#	elif skill == Global.Skill.DASHOUT:
#		pass
#	elif skill == Global.Skill.PUFF:
#		pass
#	elif skill == Global.Skill.SUMMON:
#		pass

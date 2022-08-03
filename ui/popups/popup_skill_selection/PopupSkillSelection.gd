extends "res://ui/popups/popup_base/PopupBase.gd"

onready var push_skill_button = $MargCont/Vbox/Content/Row1/PushButton
onready var pull_skill_button = $MargCont/Vbox/Content/Row1/PullButton
onready var push_aoe_skill_button = $MargCont/Vbox/Content/Row2/PushAoeButton
onready var pull_aoe_skill_button = $MargCont/Vbox/Content/Row2/PullAoeButton

func _ready():
	push_skill_button.connect("pressed", self, "selected", [Global.Skill.PUSH])
	pull_skill_button.connect("pressed", self, "selected", [Global.Skill.PULL])
	push_aoe_skill_button.connect("pressed", self, "selected", [Global.Skill.PUSHAOE])
	pull_aoe_skill_button.connect("pressed", self, "selected", [Global.Skill.PULLAOE])


func selected(skill):
	GameEvents.emit_signal("skill_selected", skill, 1)
	emit_signal("finished")


func set_popup(skills: Dictionary):
	push_skill_button.number = skills[Global.Skill.PUSH]
	pull_skill_button.number = skills[Global.Skill.PULL]
	push_aoe_skill_button.number = skills[Global.Skill.PUSHAOE]
	pull_aoe_skill_button.number = skills[Global.Skill.PULLAOE]

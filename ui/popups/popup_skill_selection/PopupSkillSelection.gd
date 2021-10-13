extends "res://ui/popups/popup_base/PopupBase.gd"

onready var dashin_skill_button = $MargCont/Vbox/Content/Row1/DashInButton
onready var dashout_skill_button = $MargCont/Vbox/Content/Row1/DashOutButton
onready var puff_skill_button = $MargCont/Vbox/Content/Row2/PuffButton
onready var summon_skill_button = $MargCont/Vbox/Content/Row2/SummonButton

func _ready():
	dashin_skill_button.connect("pressed", self, "selected", [Global.Skill.DASHIN])
	dashout_skill_button.connect("pressed", self, "selected", [Global.Skill.DASHOUT])
	puff_skill_button.connect("pressed", self, "selected", [Global.Skill.PUFF])
	summon_skill_button.connect("pressed", self, "selected", [Global.Skill.SUMMON])


func selected(skill):
	unpause_tree()
	GameEvents.emit_signal("skill_selected", skill)
	emit_signal("finished")


func set_popup(skills: Dictionary):
	dashin_skill_button.number = skills[Global.Skill.DASHIN]
	dashout_skill_button.number = skills[Global.Skill.DASHOUT]
	puff_skill_button.number = skills[Global.Skill.PUFF]
	summon_skill_button.number = skills[Global.Skill.SUMMON]

extends "res://ui/popups/popup_base_accept/PopupBaseAccept.gd"

onready var coins_label = $MargCont/Vbox/Content/CoinsLabel
onready var time_label = $MargCont/Vbox/Content/TimeLabel
onready var mut_speed_label = $MargCont/Vbox/Content/MutationRow1/MutSpeedLabel
onready var mut_magic_label = $MargCont/Vbox/Content/MutationRow1/MutMagicLabel
onready var mut_growth_label = $MargCont/Vbox/Content/MutationRow2/MutGrowthLabel
onready var mut_hunger_label = $MargCont/Vbox/Content/MutationRow2/MutHungerLabel
onready var ski_push_label = $MargCont/Vbox/Content/SkillRow1/PushLabel
onready var ski_pull_label = $MargCont/Vbox/Content/SkillRow1/PullLabel
onready var ski_push_aoe_label = $MargCont/Vbox/Content/SkillRow2/PushAoeLabel
onready var ski_pull_aoe_label = $MargCont/Vbox/Content/SkillRow2/PullAoeLabel


func _ready():
	pass


func _on_accept():
	ScenesHandler.switch_scene(ScenesHandler.MENU)


func set_popup(stats: Dictionary):
	coins_label.text = String(stats["coins"])
	time_label.text = stats["time"]
	mut_speed_label.text = String(stats["mutations"][Global.Mutation.SPEED])
	mut_magic_label.text = String(stats["mutations"][Global.Mutation.MAGIC])
	mut_growth_label.text = String(stats["mutations"][Global.Mutation.GROWTH])
	mut_hunger_label.text = String(stats["mutations"][Global.Mutation.HUNGER])
	
	ski_push_label.text = String(stats["skills"][Global.Skill.PUSH])
	ski_pull_label.text = String(stats["skills"][Global.Skill.PULL])
	ski_push_aoe_label.text = String(stats["skills"][Global.Skill.PUSHAOE])
	ski_pull_aoe_label.text = String(stats["skills"][Global.Skill.PULLAOE])

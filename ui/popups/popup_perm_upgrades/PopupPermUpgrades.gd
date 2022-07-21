extends "res://ui/popups/popup_base/PopupBase.gd"

onready var accept_button = $MargCont/Vbox/Buttons/AcceptButton
onready var coins_label = $MargCont/Vbox/Content/Row1/CoinsLabel
onready var mutation_button = $MargCont/Vbox/Content/Row3/MutationButton
onready var skill_button = $MargCont/Vbox/Content/Row3/SkillButton
onready var mutation_cost_label = $MargCont/Vbox/Content/Row2/MutationCost
onready var skill_cost_label = $MargCont/Vbox/Content/Row2/SkillCost

enum Type {MUTATION, SKILL}

var mutation_cost := 0
var skill_cost := 0

func _ready():
	accept_button.connect("pressed", self, "on_accept_pressed")
	mutation_button.connect("pressed", self, "on_upgrade_pressed", [Type.MUTATION])
	skill_button.connect("pressed", self, "on_upgrade_pressed", [Type.SKILL])
	update_cost()
	update_coins()
	update_buttons()


func on_accept_pressed():
	Global.save_player()
	emit_signal("finished")


func on_upgrade_pressed(type):
	if type == Type.MUTATION:
		Global.mutation_upgrade += 1
		Global.coins -= mutation_cost
	elif type == Type.SKILL:
		Global.skill_upgrade += 1
		Global.coins -= skill_cost
	
	update_cost()
	update_coins()
	update_buttons()


func update_cost():
	mutation_cost = 20 * (Global.mutation_upgrade+1)
	skill_cost = 20 * (Global.skill_upgrade+1)
	mutation_cost_label.text = "Cost: " + String(mutation_cost)
	skill_cost_label.text = "Cost: " + String(skill_cost)


func update_coins():
	coins_label.text = "Coins: " + String(Global.coins)


func update_buttons():
	mutation_button.number = Global.mutation_upgrade
	skill_button.number = Global.skill_upgrade
	
	if Global.coins < mutation_cost:
		mutation_button.disable_extended()
	else:
		mutation_button.enable_extended()
	
	if Global.coins < skill_cost:
		skill_button.disable_extended()
	else:
		skill_button.enable_extended()

extends "res://ui/popups/popup_base/PopupBase.gd"

onready var accept_button = $MargCont/Vbox/Buttons/AcceptButton
onready var coin_label = $MargCont/Vbox/Content/RowLabel/CoinLabel
onready var cost_label = $MargCont/Vbox/Content/RowLabel/CostLabel
onready var button1 = $MargCont/Vbox/Content/Row1/Button1
onready var button2 = $MargCont/Vbox/Content/Row1/Button2
onready var button3 = $MargCont/Vbox/Content/Row2/Button3
onready var button4 = $MargCont/Vbox/Content/Row2/Button4

enum Type {SKILL, MUTATION}
export(Type) var type

export(int) var cost = 20


func _ready():
	accept_button.connect("pressed", self, "on_accept_pressed")
	cost_label.text = "Cost: " + String(cost)
	
	if type == Type.SKILL:
		button1.connect("pressed", self, "on_buttons_pressed", [Global.Skill.PUSH])
		button2.connect("pressed", self, "on_buttons_pressed", [Global.Skill.PULL])
		button3.connect("pressed", self, "on_buttons_pressed", [Global.Skill.PUSHAOE])
		button4.connect("pressed", self, "on_buttons_pressed", [Global.Skill.PULLAOE])
	elif type == Type.MUTATION:
		button1.connect("pressed", self, "on_buttons_pressed", [Global.Mutation.SPEED])
		button2.connect("pressed", self, "on_buttons_pressed", [Global.Mutation.MAGIC])
		button3.connect("pressed", self, "on_buttons_pressed", [Global.Mutation.GROWTH])
		button4.connect("pressed", self, "on_buttons_pressed", [Global.Mutation.HUNGER])
	
	update_info()


func on_buttons_pressed(selected):
	if type == Type.SKILL:
		if selected == Global.Skill.PULL:
			Global.player_save.skill_pull += 1
			
		elif selected == Global.Skill.PUSH:
			Global.player_save.skill_push += 1
			
		elif selected == Global.Skill.PULLAOE:
			Global.player_save.skill_pull_aoe += 1
			
		elif selected == Global.Skill.PUSHAOE:
			Global.player_save.skill_push_aoe += 1
			
	elif type == Type.MUTATION:
		if selected == Global.Mutation.GROWTH:
			Global.player_save.mut_growth += 1
			
		elif selected == Global.Mutation.HUNGER:
			Global.player_save.mut_hunger += 1
			
		elif selected == Global.Mutation.MAGIC:
			Global.player_save.mut_magic += 1
			
		elif selected == Global.Mutation.SPEED:
			Global.player_save.mut_speed += 1
		
	else:
		Global.show_error("res://ui/popups/popup_perm_upgrades/PopupPermUpgrades.gd", "Type doesn't exist")
		get_tree().quit()
	
	Global.player_save.coins -= cost
	
	update_info()


func update_info():
	# label
	coin_label.text = "Coins: " + String(Global.player_save.coins)
	
	# buttons
	if Global.player_save.coins < cost:
		button1.disable_extended()
		button2.disable_extended()
		button3.disable_extended()
		button4.disable_extended()
	
	if type == Type.SKILL:
		button1.number = Global.player_save.skill_push
		button2.number = Global.player_save.skill_pull
		button3.number = Global.player_save.skill_push_aoe
		button4.number = Global.player_save.skill_pull_aoe
	elif type == Type.MUTATION:
		button1.number = Global.player_save.mut_speed
		button2.number = Global.player_save.mut_magic
		button3.number = Global.player_save.mut_growth
		button4.number = Global.player_save.mut_hunger
	else:
		Global.show_error("res://ui/popups/popup_perm_upgrades/PopupPermUpgrades.gd", "Type doesn't exist")
		get_tree().quit()


func on_accept_pressed():
	Global.save_player()
	emit_signal("finished")

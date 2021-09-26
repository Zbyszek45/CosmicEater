extends Control

onready var label_fps = $VBoxContainer/FPSLabel
onready var label_ene_number_label = $VBoxContainer/EneNumberLabel
onready var button_add_enemies = $VBoxContainer/AddEnemies
onready var button_decrease_enemies = $VBoxContainer/DecreaseEnemies
onready var button_grow_small = $VBoxContainer/GrowSmall
onready var button_grow_big = $VBoxContainer/GrowBig


func _ready():
	button_add_enemies.connect("pressed", self, "on_AddEnemies_pressed")
	button_decrease_enemies.connect("pressed", self, "on_DecreaseEnemies_pressed")
	button_grow_small.connect("pressed", self, "on_GrowSmall_pressed")
	button_grow_big.connect("pressed", self, "on_GrowBig_pressed")
	GameEvents.connect("update_enemies_number", self, "enemies_number_label_update")


func _physics_process(delta):
	label_fps.text = "FPS: " + str(Engine.get_frames_per_second())


func on_AddEnemies_pressed():
	GameEvents.emit_signal("increase_enemies_number", 10)


func on_DecreaseEnemies_pressed():
	GameEvents.emit_signal("decrease_enemies_number", 10)


func on_GrowSmall_pressed():
	GameEvents.emit_signal("force_player_grow_up", 0.1)


func on_GrowBig_pressed():
	GameEvents.emit_signal("force_player_grow_up", 2.0)


func enemies_number_label_update(amount):
	label_ene_number_label.text = "Ene: " + str(amount)

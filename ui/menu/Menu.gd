extends Control

onready var start_button = $StartButton
onready var exit_button = $ExitButton
onready var settings_button = $SettingButton
onready var about_button = $AboutButton
onready var aipriority_button = $AIPriorityButton
onready var upgrades_button = $UpgradesButton

onready var help_button = $HelpButton


func _ready():
	start_button.connect("pressed", self, "on_StartButton_pressed")
	exit_button.connect("pressed", self, "on_ExitButton_pressed")
	settings_button.connect("pressed", self, "on_SettingsButton_pressed")
	about_button.connect("pressed", self, "on_AboutButton_pressed")
	aipriority_button.connect("pressed", self, "on_AIPriority_pressed")
	upgrades_button.connect("pressed", self, "on_UpgradesButton_pressed")
	
	help_button.connect("pressed", self, "on_HelpButton_pressed")


func on_StartButton_pressed():
	ScenesHandler.switch_scene(ScenesHandler.TRANSITION)


func on_ExitButton_pressed():
	get_tree().quit()


func on_SettingsButton_pressed():
	pass


func on_AboutButton_pressed():
	pass


func on_AIPriority_pressed():
	pass


func on_UpgradesButton_pressed():
	pass


func on_HelpButton_pressed():
	pass

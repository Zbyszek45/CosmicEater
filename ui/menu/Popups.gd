extends Node

var popup_save_continue: PackedScene = preload("res://ui/popups/popup_save_continue/PopupSaveContinue.tscn")
var popup_perm_upgrades_skills: PackedScene = preload("res://ui/popups/popup_perm_upgrades_skills/PopupPermUpgradesSkills.tscn")
var popup_perm_upgrades_mut: PackedScene = preload("res://ui/popups/popup_perm_upgrades_mut/PopupPermUpgradesMut.tscn")
var popup_information: PackedScene = preload("res://ui/popups/popup_information/PopupInformation.tscn")
var popup_settings: PackedScene = preload("res://ui/popups/popup_settings/PopupSettings.tscn")

var popup = null


func _ready():
	pass


func show_popup_save_continue(menu):
	if menu:
		popup = popup_save_continue.instance()
		menu.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://ui/menu/Popups.gd", "Menu is null")


func show_popup_perm_upgrades_skills(menu):
	if menu:
		popup = popup_perm_upgrades_skills.instance()
		menu.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://ui/menu/Popups.gd", "Menu is null")


func show_popup_perm_upgrades_mut(menu):
	if menu:
		popup = popup_perm_upgrades_mut.instance()
		menu.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://ui/menu/Popups.gd", "Menu is null")


func show_popup_information(menu):
	if menu:
		popup = popup_information.instance()
		menu.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://ui/menu/Popups.gd", "Menu is null")


func show_popup_settings(menu):
	if menu:
		popup = popup_settings.instance()
		menu.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://ui/menu/Popups.gd", "Menu is null")


func resume():
	if popup != null:
		popup.queue_free()
		popup = null

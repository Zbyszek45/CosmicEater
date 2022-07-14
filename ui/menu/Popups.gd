extends Node

var popup_save_continue: PackedScene = preload("res://ui/popups/popup_save_continue/PopupSaveContinue.tscn")
var popup_perm_upgrades: PackedScene = preload("res://ui/popups/popup_perm_upgrades/PopupPermUpgrades.tscn")

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


func show_popup_perm_upgrades(menu):
	if menu:
		popup = popup_perm_upgrades.instance()
		menu.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://ui/menu/Popups.gd", "Menu is null")


func resume():
	if popup != null:
		popup.queue_free()
		popup = null

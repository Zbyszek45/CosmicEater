extends Node

var mutation_speed_number: int = 0
var mutation_magic_number: int = 0
var mutation_growth_number: int = 0
var mutation_hunger_number: int = 0

# percentages
var speed_value = 2
var magic_value = 2
var growth_value = 2 #not percentages
var hunger_value = 2

signal mutation_new_speed
signal mutation_new_magic
signal mutation_new_growth
signal mutation_new_hunger

func _ready():
	GameEvents.connect("mutation_selected", self, "_mutation_selected")
	$GrowthTimer.connect("timeout", self, "grow_parent")


func _mutation_selected(mutation, levels):
	if mutation == Global.Mutation.SPEED:
		mutation_speed_number += levels
		emit_signal("mutation_new_speed", mutation_speed_number*speed_value)
	elif mutation == Global.Mutation.MAGIC:
		mutation_magic_number += levels
		emit_signal("mutation_new_magic", mutation_magic_number*magic_value)
	elif mutation == Global.Mutation.GROWTH:
		mutation_growth_number += levels
	elif mutation == Global.Mutation.HUNGER:
		mutation_hunger_number += levels
		emit_signal("mutation_new_hunger", mutation_hunger_number*hunger_value)


func grow_parent():
	emit_signal("mutation_new_growth", mutation_growth_number*growth_value)


func on_load():
	emit_signal("mutation_new_speed", mutation_speed_number*speed_value)
	emit_signal("mutation_new_magic", mutation_magic_number*magic_value)
	emit_signal("mutation_new_hunger", mutation_hunger_number*hunger_value)

extends "res://ui/popups/popup_base/PopupBase.gd"

onready var speed_mutation_button = $MargCont/Vbox/Content/Row1/SpeedMutButton
onready var magic_mutation_button = $MargCont/Vbox/Content/Row1/MagicMutButton
onready var growth_mutation_button = $MargCont/Vbox/Content/Row2/GrowthMutButton
onready var hunger_mutation_button = $MargCont/Vbox/Content/Row2/HungerMutButton

func _ready():
	speed_mutation_button.connect("pressed", self, "selected", [Global.Mutation.SPEED])
	magic_mutation_button.connect("pressed", self, "selected", [Global.Mutation.MAGIC])
	growth_mutation_button.connect("pressed", self, "selected", [Global.Mutation.GROWTH])
	hunger_mutation_button.connect("pressed", self, "selected", [Global.Mutation.HUNGER])


func selected(mutation):
	GameEvents.emit_signal("mutation_selected", mutation, 1)
	emit_signal("finished")


func set_popup(mutations: Dictionary):
	speed_mutation_button.number = mutations[Global.Mutation.SPEED]
	magic_mutation_button.number = mutations[Global.Mutation.MAGIC]
	growth_mutation_button.number = mutations[Global.Mutation.GROWTH]
	hunger_mutation_button.number = mutations[Global.Mutation.HUNGER]

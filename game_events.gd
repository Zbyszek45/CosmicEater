extends Node

signal increase_enemies_number
signal decrease_enemies_number

signal update_enemies_number

# used for debug to grow player
signal force_player_grow_up

# after player growth, parameters: size - new size, amount - how much in scale
signal player_grew_up

# show message with parameter as an resource
signal show_message

# stop and start spawning and clear spawned
signal stop_spawning_spawnable
signal start_spawning_spawnable

# time for interface
signal time_changed

# emited when pause popup shows
signal show_popup_pause
signal show_popup_mutation_selection
signal show_popup_skill_selection
signal show_end_game

# world level up
signal world_level_up

# to save game
signal save_game_state

# picked mutation
signal mutation_selected

# picked skill
signal skill_selected

# skills reload time changed
signal skills_reload_time_update
signal skills_max_reload_time_update

# player destroyed
signal end_game

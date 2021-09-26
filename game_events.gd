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

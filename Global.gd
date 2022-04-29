extends Node

#warning-ignore:unused_signal
signal found_exit
#warning-ignore:unused_signal
signal do_exit
#warning-ignore:unused_signal
signal found_key
#warning-ignore:unused_signal
signal swap_key
#warning-ignore:unused_signal
signal reload_level


const TILE_SIZE = 32
var game_rng := RandomNumberGenerator.new()
var game_rng_seed = "Random Seed" setget set_seed

var current_level = "1"

const LEVELS = ["1", "1.1", "1.2", "1.3", "2", "2.1", "2.2", "3", "4", "5", "99"]

#var ambience_player = AudioStreamPlayer.new()
#var ambience = "res://scenes/level/assets/ambience.ogg"

func _ready():
	pass
#	if File.new().file_exists(ambience):
#		var sfx = load(ambience) 
#		sfx.set_loop(true)
#		ambience_player.stream = sfx
#		ambience_player.play()


func set_seed(_seed) -> void:
	game_rng_seed = str(_seed)
	game_rng.set_seed(hash(game_rng_seed))


func randi_range(from: int, to: int) -> int:
	return(game_rng.randi_range(from, to))


func next_level():
	var current_idx = LEVELS.find(current_level)
	var next_idx = current_idx + 1
	if len(LEVELS) < next_idx + 1:
		current_level = LEVELS[-1]
	else:
		current_level = LEVELS[next_idx]
	return current_level

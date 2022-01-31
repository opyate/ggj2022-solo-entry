extends Node

#warning-ignore:unused_signal
signal found_exit
#warning-ignore:unused_signal
signal do_exit
#warning-ignore:unused_signal
signal found_key
#warning-ignore:unused_signal
signal swap_key

const TILE_SIZE = 32
var game_rng := RandomNumberGenerator.new()
var game_rng_seed = "Random Seed" setget set_seed

var level_number = 1

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


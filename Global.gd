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
const color_light: Color = Color("#1896eb")
const color_dark: Color = Color("#511900")
var current_level = "1"

const LEVELS = [
	"1", "1.1", "1.2", "1.3", 
	"2", "2.1", "2.2", 
	"3", "4", "5",
	"6", "6.1",
	"7", "7.1", "7.2",
	"99"
]


func set_seed(_seed) -> void:
	game_rng_seed = str(_seed)
	game_rng.set_seed(hash(game_rng_seed))


func randi_range(from: int, to: int) -> int:
	return(game_rng.randi_range(from, to))


func next_level():
	var current_idx = LEVELS.find(current_level)
	var next_idx = current_idx + 1
	if len(LEVELS) < next_idx + 1:
		current_level = LEVELS[0]
	else:
		current_level = LEVELS[next_idx]
	print("level = %s" % [current_level])
	return current_level

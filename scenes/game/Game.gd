extends Node2D

onready var level_container = $Level
onready var tween_fade_out = $TweenFadeOut
onready var tween_fade_in = $TweenFadeIn
var current_level
const FINAL_LEVEL = 99


func get_level(ln: int):
	return "res://scenes/level/%s/Level.tscn" % [ln]


func load_level():
	var level_scene_file = get_level(g.level_number)
	if File.new().file_exists(level_scene_file):
		current_level = load(level_scene_file).instance()
		level_container.add_child(current_level)
	else:
		level_scene_file = get_level(FINAL_LEVEL)
		current_level = load(level_scene_file).instance()
		level_container.add_child(current_level)


func _ready():
	load_level()
	
	#warning-ignore:return_value_discarded
	g.connect("do_exit", self, "_on_do_exit")
	#warning-ignore:return_value_discarded
	g.connect("found_key", self, "_on_found_key")
	#warning-ignore:return_value_discarded
	tween_fade_out.connect("tween_completed", self, "_on_tween_fade_out_completed")


func _on_tween_fade_out_completed(_obj, _nodepath):
	current_level.queue_free()
	g.level_number += 1
	load_level()
	tween_fade_in.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3)
	tween_fade_in.start()


func _on_do_exit():
	tween_fade_out.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.3)
	tween_fade_out.start()


func _on_found_key():
	# print("FOUND KEY!")
	pass


onready var tile = preload("res://scenes/tile/Tile.tscn")
func _readyx():
	randomize()
	var size = get_viewport().size
	var x = size.x
	var y = size.y
	
	for i in (x / g.TILE_SIZE):
		for j in (y / g.TILE_SIZE):
			var t = tile.instance()
			add_child(t)
			t.position = Vector2(i * 32, j * 32)
			print(g.randi_range(0, 1))
			if g.randi_range(0, 1) == 0:
				t.black()
			else:
				t.white()
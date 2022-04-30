extends Node2D

onready var level_container = $Level
onready var tween_fade_out = $TweenFadeOut
onready var tween_fade_in = $TweenFadeIn
var current_level_scene


func _ready():
	# debug
	for _i in range(8):
		g.next_level()
	load_level()
	
	#warning-ignore:return_value_discarded
	g.connect("do_exit", self, "_on_do_exit")
	#warning-ignore:return_value_discarded
	g.connect("found_key", self, "_on_found_key")
	#warning-ignore:return_value_discarded
	tween_fade_out.connect("tween_completed", self, "_on_tween_fade_out_completed")
	#warning-ignore:return_value_discarded
	g.connect("reload_level", self, "_on_reload_level")


func get_level(ln: String):
	return "res://scenes/level/%s/Level.tscn" % [ln]


func load_level():	
	var level_scene_file = get_level(g.current_level)
	if File.new().file_exists(level_scene_file):
		current_level_scene = load(level_scene_file).instance()
		level_container.add_child(current_level_scene)
	else:
		level_scene_file = get_level(g.LEVELS[-1])
		current_level_scene = load(level_scene_file).instance()
		level_container.add_child(current_level_scene)


func _on_tween_fade_out_completed(_obj, _nodepath):
	current_level_scene.queue_free()
	g.next_level()
	load_level()
	tween_fade_in.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3)
	tween_fade_in.start()


func _on_reload_level():
	current_level_scene.queue_free()
	load_level()


func _on_do_exit():
	tween_fade_out.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.3)
	tween_fade_out.start()


func _on_found_key():
	# print("FOUND KEY!")
	pass

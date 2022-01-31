extends Node2D

onready var dark_position = $DarkSpawn.position
onready var light_position = $LightSpawn.position
onready var exit_position = $ExitSpawn.position
onready var key_position = $KeySpawn.position


func _ready():
	#warning-ignore:return_value_discarded
	g.connect("found_key", self, "_on_found_key")
	
	var player_scene = load("res://scenes/player/Player.tscn")
	
	var dark_player = player_scene.instance()
	dark_player.make_dark()
	add_child(dark_player)
	dark_player.position = dark_position

	var light_player = player_scene.instance()
	light_player.make_light()
	add_child(light_player)
	light_player.position = light_position
	
	var exit = load("res://scenes/level/Exit.tscn").instance()
	add_child(exit)
	exit.position = exit_position
	
	var key = load("res://scenes/level/Key.tscn").instance()
	add_child(key)
	key.position = key_position


func _on_found_key():
	if has_node("Key"):
		self.call_deferred("remove_child", $Key)

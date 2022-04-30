extends Node2D

onready var tween = $Tween
onready var sprite = $Sprite

const start_scale = 0.8
const end_scale = 1.3

func _ready():
	scale = Vector2(start_scale, start_scale)
	rotation = g.game_rng.randf() * PI 
	var end_rotation = rotation + PI/2
	#warning-ignore:return_value_discarded
	tween.connect("tween_completed", self, "_on_tween_completed")
	
	tween.interpolate_property(sprite, "modulate:a", 1.0, 0.0, 0.2, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.interpolate_property(sprite, "scale", scale, Vector2(end_scale, end_scale), 0.2)
	tween.interpolate_property(sprite, "rotation", rotation, end_rotation, 0.2)
	tween.start()


func _on_tween_completed(_obj, _nodepath):
	queue_free()

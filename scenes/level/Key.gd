extends Node2D

onready var audio_rare = $AudioKeyRare
onready var audio = $AudioKey


func _ready():
	audio.play()


func _on_Area2D_body_entered(_body):
	g.emit_signal("found_key")
	_body.call_deferred("add_child", self)
	# put it on top of the character's head
	position = Vector2(0, -24)
	if g.game_rng.randi_range(0, 50) == 25:
		audio_rare.play()
	else:
		audio.play()

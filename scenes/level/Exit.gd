extends Particles2D


var blue_particle = preload("res://scenes/level/assets/particle.png")
onready var tween_shrink = $TweenShrink
onready var tween_grow = $TweenGrow
onready var audio = $AudioStreamPlayer


func _ready():
	#warning-ignore:return_value_discarded
	g.connect("found_key", self, "_on_found_key")
	#warning-ignore:return_value_discarded
	tween_shrink.connect("tween_completed", self, "_on_shrink")
	#warning-ignore:return_value_discarded
	audio.connect("finished", self, "_on_audio_finished")


func _on_found_key():
	tween_shrink.interpolate_property(self, "scale", Vector2.ONE, Vector2.ZERO, 0.3)
	tween_shrink.start()


func _on_shrink(_obj, _nodepath):
	texture = blue_particle
	tween_grow.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 0.3)
	tween_grow.start()


func _on_Area2D_body_entered(_body):
	# a player entered
	found_exit()


func _on_Area2D_area_entered(_area):
	# the key entered
	found_exit()


func found_exit():
#	print("Exit:found_exit")
	g.emit_signal("found_exit")
	audio.play()
	
	var s = 10.0
	tween_grow.interpolate_property(self, "scale", Vector2.ONE, Vector2(s,s), audio.stream.get_length()+0.5)
	tween_grow.interpolate_property(self, "rotation", 0.0, PI * 2, audio.stream.get_length() + 1)
	tween_grow.start()


func _on_audio_finished():
#	print("Exit:_on_audio_finished")
	g.emit_signal("do_exit")

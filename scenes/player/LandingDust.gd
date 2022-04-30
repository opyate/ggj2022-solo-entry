extends Node2D

onready var particles = $Particles2D

func _ready():
	particles.one_shot = true
	particles.emitting = true
	
	var timeout = particles.lifetime
	# var timeout = 1.0
	yield(get_tree().create_timer(timeout), "timeout")
	queue_free()

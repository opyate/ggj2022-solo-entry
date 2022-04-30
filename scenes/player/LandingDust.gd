extends Node2D

onready var particles = $Particles2D
var new_color

func _ready():
	print("particle color %s - %s" % [self, new_color])
	particles.process_material.color = new_color
	particles.one_shot = true
	particles.emitting = true
	
	var timeout = particles.lifetime
	# var timeout = 1.0
	yield(get_tree().create_timer(timeout), "timeout")
	queue_free()


func set_color(color: Color):
	#$Particles2D.process_material.color = new_color
	new_color = color

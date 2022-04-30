class_name Player
extends Actor

const FLOOR_DETECT_DISTANCE = 20.0

export(String) var action_suffix = ""

onready var sprite = $Sprite
onready var audio_footsteps = $AudioFootsteps
onready var audio_jump = $AudioJump
onready var key_tween = $KeyTween
onready var screen_size = get_viewport_rect().size
onready var key_scene = preload("res://scenes/level/Key.tscn")
onready var jumpsplosion_scene = preload("res://scenes/player/Jumpsplosion.tscn")
onready var landingdust_light_scene = preload("res://scenes/player/LandingDustLight.tscn")
onready var landingdust_dark_scene = preload("res://scenes/player/LandingDustDark.tscn")
var light_sprite = load("res://scenes/player/assets/light-player.png")
var dark_sprite = load("res://scenes/player/assets/dark-player.png")

var can_play_audio_footsteps = true
var can_play_audio_jump = true
var just_landed = false
var just_started_falling = false
var player_type = "-none-"

func make_dark():
	$Sprite.texture = dark_sprite
	player_type = "dark"
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(1, true)


func make_light():
	$Sprite.texture = light_sprite
	player_type = "light"
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)


func _ready():
	#warning-ignore:return_value_discarded
	g.connect("found_key", self, "_on_found_key")
	#warning-ignore:return_value_discarded
	audio_footsteps.connect("finished", self, "_on_audio_footsteps_finished")
	#warning-ignore:return_value_discarded
	audio_jump.connect("finished", self, "_on_audio_jump_finished")
	#warning-ignore:return_value_discarded
	g.connect("swap_key", self, "_on_swap_key")
	#warning-ignore:return_value_discarded
	g.connect("found_exit", self, "_on_found_exit")


func _on_found_exit():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)


func _on_swap_key():
	var has_key = false
	for c in get_children():
		if c.name == "Key":
			has_key = true
	
	if has_key:
		key_tween.interpolate_property($Key, "modulate:a", 1.0, 0.0, 0.3)
		key_tween.start()
		yield(get_tree().create_timer(0.3), "timeout")
		if not has_node("Key"):
			g.emit_signal("reload_level")
		elif $Key:
			$Key.queue_free()
	else:
		var key = key_scene.instance()
		key.modulate.a = 0.0
		key.position = Vector2(0, -24)
		call_deferred("add_child", key)
		key_tween.interpolate_property(key, "modulate:a", 0.0, 1.0, 0.3)
		key_tween.start()


func _on_audio_footsteps_finished():
	can_play_audio_footsteps = true


func _on_audio_jump_finished():
	can_play_audio_jump = true


func _on_found_key():
	# disable being able to collide with key on layer 3
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(2, false)


# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = false
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	
	if _velocity.y > 10:
		just_started_falling = true
	
	# don't fall to fast
	if _velocity.y > 600:
		_velocity.y = 600

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make it face left or right depending on the direction you move.
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1

	if abs(_velocity.x) > 0 and can_play_audio_footsteps and is_on_floor():
		can_play_audio_footsteps = false
		audio_footsteps.play()
	
	
	if position.x > screen_size.x:
		position.x = 0
	if position.x < 0:
		position.x = screen_size.x
	if position.y > screen_size.y:
		position.y = 0
	if position.y < 0:
		position.y = screen_size.y
	
	# detect when the character landed
	if is_on_floor() and just_started_falling:
		just_landed = true
	
	if just_landed:
		just_landed = false
		just_started_falling = false
		
		var landingdust
		if player_type == "dark":
			landingdust = landingdust_dark_scene.instance()
		else:
			landingdust = landingdust_light_scene.instance()
		landingdust.global_position = position + Vector2(0, 16.0)
		get_parent().add_child(landingdust)


func get_direction():
	var new_x =  Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix)
	var new_y = -1 if is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) else 0
#	if name == "Player":
#		print("%s, %s" % [new_x, new_y])
	return Vector2(new_x, new_y)


func _input(event):
	if event.is_action_pressed("jump" + action_suffix) and can_play_audio_jump:
		just_started_falling = true
		can_play_audio_jump = false
		audio_jump.play()
		var jumpsplosion = jumpsplosion_scene.instance()
		jumpsplosion.global_position = position + Vector2(0, 8)
		get_parent().add_child(jumpsplosion)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity


func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new

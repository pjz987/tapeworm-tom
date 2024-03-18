class_name TapewormTom
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var death_sound_player = $DeathSoundPlayer
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var footstep_sound_player = $FootstepSoundPlayer

@export var acceleration = 512
@export var jump_force = -256
@export var max_speed = 128
@export var friction = 0.2

var reset_position: Vector2
var dead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	reset_position = global_position

func _physics_process(delta):
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed('ui_accept'):
		print(coyote_jump_timer.time_left)
		if is_on_floor() or coyote_jump_timer.time_left > 0.0:
			print(coyote_jump_timer.time_left)
			velocity.y = jump_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis('move_left', 'move_right')
	if direction:
		velocity.x += direction * acceleration * delta
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	if not dead:
		var was_on_floor = is_on_floor()
		move_and_slide()
		var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
		if just_left_edge:
			coyote_jump_timer.start()
		if is_on_floor() and not was_on_floor:
			play_footstep()
	
	update_animations(direction)

func update_animations(direction):
	if direction:
		animation_player.play('walk')
		sprite_2d.scale.x = direction
	else:
		animation_player.play('idle')
	if not is_on_floor():
		animation_player.play('jump')

func die():
	death_sound_player.play(0.18)
	dead = true
	await get_tree().create_tween().tween_property(self, 'modulate', Color('#ffffff00'), 0.5).finished
	global_position = reset_position
	await get_tree().create_tween().tween_property(self, 'modulate', Color.WHITE, 0.25).finished
	velocity = Vector2.ZERO
	dead = false

func _on_hitbox_body_entered(body):
	if not dead and not body.dead:
		body.die()
		velocity.y = jump_force


func _on_hurtbox_body_entered(body):
	if velocity.y <= 0.01:
		die()

func play_footstep():
	const timestamps = [0.04, 0.35, 0.7, 1.05, 1.41, 1.73, 2.08, 2.42, 2.75]
	var timestamp = timestamps.pick_random()
	footstep_sound_player.play(timestamp)
	await get_tree().create_timer(0.3).timeout
	footstep_sound_player.stop()
	

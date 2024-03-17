class_name WhiteBloodCell
extends CharacterBody2D

@onready var death_sound_player = $DeathSoundPlayer

@export var fall_acceleration = 512
var dead = false

func _physics_process(delta):
	if dead:
		velocity.y += fall_acceleration * delta
		move_and_slide()

func die():
	death_sound_player.play(0.15)
	dead = true
	set_collision_mask_value(4, false)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

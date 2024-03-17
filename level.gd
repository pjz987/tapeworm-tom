class_name Level
extends Node2D

#@export var next_level_packed: PackedScene
@export var next_level_path: String
#var next_level
#
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color.BLACK
	get_tree().create_tween().tween_property(self, 'modulate', Color.WHITE, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_end_zone_body_entered(body):
	get_tree().create_tween().tween_property(self, 'modulate', Color.BLACK, 1.0)
	await get_tree().create_timer(1.0).timeout
	#get_tree().change_scene_to_packed(next_level_packed)
	get_tree().change_scene_to_file(next_level_path)


func _on_exit_area_2d_body_entered(body):
	await get_tree().create_tween().tween_property(self, 'modulate', Color.BLACK, 1.0).finished
	get_tree().quit()


func _on_play_again_area_2d_body_entered(body):
	await get_tree().create_tween().tween_property(self, 'modulate', Color.BLACK, 1.0).finished
	get_tree().change_scene_to_file('res://title_screen.tscn')

extends Control

var transitioning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not transitioning:
		transitioning = true
		await get_tree().create_tween().tween_property(self, 'modulate', Color.BLACK, 0.5).finished
		get_tree().change_scene_to_file("res://level.tscn")

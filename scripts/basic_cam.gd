extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("rotate_left"):
		rotate_y(-1 * delta)
	if Input.is_action_pressed("rotate_right"):
		rotate_y(1 * delta)

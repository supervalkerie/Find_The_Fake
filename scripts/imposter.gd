class_name Imposter
extends Entity

signal notify_visibility(text: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_new_position()
	is_imposter = true

func _process(delta: float) -> void:
	_move_entity(delta)
	_detect_mouse_input()

func _recieve_visible() -> void:
	notify_visibility.emit("Entity visible!")
	#print("Entity visible!")

func _recieve_not_visible() -> void:
	notify_visibility.emit("Entity not visible...")
	#print("Entity not visible...")

class_name Entity
extends Node3D

@onready var timer: Timer = $Timer

var current_position : Vector3
var new_position : Vector3

var is_close : bool = false
var is_moving : bool = false
var done_moving : bool = false

const MOVEMENT_SPEED : float = 0.5
const MOVEMENT_DIST : int = 3
const TIMER_WAIT : float = 5

# Set the current position at start
func _ready() -> void:
	_set_new_position()
	current_position = self.position
	print("Setting current position")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Constantly check if distance is close enough to stop moving
	is_close = _determine_distance()
	
	# If it should move, and not close enough, move it and set it's new current position
	if is_moving and not is_close:
		#translate(new_position * MOVEMENT_SPEED * delta) - Works on first pass, then doesn't work on 2nd.
		#position.move_toward(new_position, delta * MOVEMENT_SPEED) - Doesn't work at all
		
		# This works, using translate to the new position didn't work, and would move it away? I assume I just don't
		# understand how the position.translate works
		position += position.direction_to(new_position) * MOVEMENT_SPEED * delta
		current_position = self.position
		print("Moving")
		return
	
	done_moving = true
	if done_moving and is_moving:
		is_moving = false
		done_moving = false
		timer.one_shot = true
		timer.start(TIMER_WAIT)
		print("Finished moving, starting timer again.")

# Randomly set a new position, and start moving.
func _set_new_position() -> void:
	new_position.x = randf_range(-2, 2)
	new_position.z = randf_range(-2, 2)
	is_moving = true
	print("Set new position" + str(new_position))

func _determine_distance() -> bool:
	if current_position.distance_to(new_position) <= 0.1:
		return true
	return false

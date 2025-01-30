class_name Entity
extends Node3D

@onready var timer: Timer = $Timer
@onready var nav: NavigationAgent3D = $NavigationAgent3D

@export var navMarker : Node3D

var current_position : Vector3
var new_position : Vector3

var is_close : bool = false
var is_moving : bool = false
var done_moving : bool = false

const MOVEMENT_SPEED : float = 2
const MOVEMENT_DIST : int = 5
const TIMER_WAIT : float = 5

# Set the current position at start
func _ready() -> void:
	#_set_new_position()
	nav.path_desired_distance = 0.5
	nav.target_desired_distance = 0.5
	nav.target_position = navMarker.position
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#_move_entity(delta)
	var current_agent_position: Vector3 = global_position
	if current_agent_position.distance_to(navMarker.position) >= 0.5:
		var next_path_position: Vector3 = nav.get_next_path_position()
		position += position.direction_to(next_path_position) * MOVEMENT_SPEED * delta
	pass

# Randomly set a new position, and start moving.
func _set_new_position() -> void:
	current_position = self.position
	new_position.x = randf_range(-MOVEMENT_DIST, MOVEMENT_DIST)
	new_position.z = randf_range(-MOVEMENT_DIST, MOVEMENT_DIST)
	is_moving = true
	#print("Set new positions - New Pos: " + str(new_position) + " Current Pos: " + str(current_position))

func _determine_distance() -> bool:
	if current_position.distance_to(new_position) <= 0.1:
		return true
	return false

func _move_entity(delta: float) -> void:
	# Constantly check if distance is close enough to stop moving
	is_close = _determine_distance()
	
	# If it should move, and not close enough, move it and set it's new current position
	if is_moving and not is_close:
		# This works, using translate to the new position didn't work, and would move it away? I assume I just don't
		# understand how the position.translate works... Anyways, check conditions and move, then return out or move onto
		# the done moving phase.
		position += position.direction_to(new_position) * MOVEMENT_SPEED * delta
		current_position = self.position
		#print("Moving")
		return
	
	done_moving = true
	if done_moving and is_moving:
		is_moving = false
		done_moving = false
		timer.one_shot = true
		timer.start(TIMER_WAIT)
		#print("Finished moving, starting timer again.")

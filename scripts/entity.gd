class_name Entity
extends Node3D

@onready var timer: Timer = $Timer
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var mannequin: MeshInstance3D = $findtheimposter_character/metarig/Skeleton3D/Mannequin

#@export var navMarker : Node3D

var current_position : Vector3
var new_position : Vector3

var is_close : bool = false
var is_moving : bool = false
var done_moving : bool = false
var is_mouse_hovering : bool = false
var is_imposter : bool = false
var is_marked : bool = true # Have to set this to true so it's inverted correctly in the marking function.

var nav_targets : Array
var nav_target : Node3D

const MOVEMENT_SPEED : float = 2
const TIMER_WAIT : float = 5
const M_ENTITY = preload("res://assets/materials/M_entity.tres")
const M_IMPOSTER = preload("res://assets/materials/M_imposter.tres")

# Set the current position at start
func _ready() -> void:
	_set_new_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_move_entity(delta)
	_detect_mouse_input()

# Randomly set a new position, and start moving.
func _set_new_position() -> void:
	nav.path_desired_distance = 0.5
	nav.target_desired_distance = 0.5
	nav_targets = get_tree().get_nodes_in_group("nav_targets")
	nav_target = nav_targets.pick_random()
	print(nav_target)
	nav.target_position = nav_target.position
	is_moving = true

func _determine_distance() -> bool:
	if position.distance_to(nav.target_position) <= 0.15:
		return true
	return false

func _move_entity(delta: float) -> void:
	is_close = _determine_distance()
	
	if is_moving and not is_close:
		var next_path_position: Vector3 = nav.get_next_path_position()
		position += position.direction_to(next_path_position) * MOVEMENT_SPEED * delta
		look_at(transform.origin + -position.direction_to(next_path_position) * delta, Vector3.UP)
		return
	
	done_moving = true
	if done_moving and is_moving:
		is_moving = false
		done_moving = false
		timer.one_shot = true
		timer.start(TIMER_WAIT)
		#print("Finished moving, starting timer again.")

func _detect_mouse_input() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_mouse_hovering:
		print("Detected mouse click!")
		is_marked = !is_marked
		_mark_entity()
		if is_imposter:
			print("YOU GOT THE IMPOSTAH!")
		is_mouse_hovering = false

func _on_mouse_entered() -> void:
	is_mouse_hovering = true

func _on_mouse_exited() -> void:
	is_mouse_hovering = false

func _mark_entity() -> void:
	if not is_marked:
		mannequin.set_surface_override_material(0, M_IMPOSTER)
	if is_marked:
		mannequin.set_surface_override_material(0, M_ENTITY)

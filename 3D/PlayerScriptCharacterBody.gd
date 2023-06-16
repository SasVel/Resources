extends CharacterBody3D
class_name Player

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var mesh = $MeshInstance3D

@export var START_SPEED = 5.0
@export var MAX_SPEED = 12.0
@export var ACCELERATION = 0.6
@export var FRICTION = 1
@export_range(0.0, 1, 0.1) var rotation_speed = 0.2

var lastDirection = Vector3.ZERO
var CURR_SPEED = START_SPEED : set = set_curr_speed
var rotationInDegrees = 0

func set_curr_speed(val):
	CURR_SPEED = clampf(val, START_SPEED, MAX_SPEED)

enum {
	IDLE,
	MOVE,
	ATTACK
}
var state = IDLE

var direction
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	direction = Vector3(Input.get_action_strength("player_left") - Input.get_action_strength("player_right"), 
						0, 
						Input.get_action_strength("player_forward") - Input.get_action_strength("player_backward"))
	
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(lastDirection.x, lastDirection.z), rotation_speed)
	
	if direction == Vector3.ZERO:
		state = IDLE
	else:
		state = MOVE
	
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state()
		ATTACK:
			attack_state()
	
	move_and_slide()

func idle_state():
	CURR_SPEED -= FRICTION
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	velocity.z = move_toward(velocity.z, 0, FRICTION * 2)
	
func move_state():
	CURR_SPEED += ACCELERATION
	if lastDirection != direction:
		CURR_SPEED = START_SPEED

	velocity.x = direction.x * CURR_SPEED
	velocity.z = direction.z * CURR_SPEED * 1.5
	
	lastDirection = direction
	
func attack_state():
	pass

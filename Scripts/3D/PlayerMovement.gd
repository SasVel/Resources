extends CharacterBody3D
class_name Player

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var mesh = $MeshInstance3D

@export var START_SPEED = 5.0
@export var MAX_SPEED = 12.0
@export var ACCELERATION = 0.6
@export var FRICTION = 1
@export_range(0.0, 1, 0.1) var rotation_speed = 0.2

var lastDirection = Vector2.ZERO
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

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_backward")
	if input_dir == Vector2.ZERO:
		state = IDLE
	else:
		state = MOVE
	
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state(input_dir)
		ATTACK:
			attack_state()
	
	move_and_slide()

func idle_state():
	CURR_SPEED -= FRICTION
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	velocity.z = move_toward(velocity.z, 0, FRICTION * 2)
	
func move_state(input_dir):
	#movement
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	CURR_SPEED += ACCELERATION
	if lastDirection != input_dir:
		CURR_SPEED = START_SPEED
		
		if input_dir.y != 0:
			if input_dir.y == 1:
				rotationInDegrees = 180
			else:
				rotationInDegrees = 0
		else:
			rotationInDegrees = -90 * input_dir.x

	mesh.rotation.y = lerp_angle(mesh.rotation.y, deg_to_rad(rotationInDegrees), rotation_speed)
	
	velocity.x = direction.x * CURR_SPEED
	velocity.z = direction.z * CURR_SPEED * 2
	
	lastDirection = input_dir
	
func attack_state():
	pass

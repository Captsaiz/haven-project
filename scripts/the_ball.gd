extends CharacterBody2D


const MAX_SPEED = 300.0
const ACCELERATION = 20.0
const FRICTION = 10.0
const JUMP_VELOCITY = -500.0
var LAST_JUMP_VELOCITY: float = 0.0

func jump() -> void:
	# Add jump
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		LAST_JUMP_VELOCITY = JUMP_VELOCITY

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_pressed("ui_accept"): jump()
	
	if is_on_floor():
		LAST_JUMP_VELOCITY /= 2
		velocity.y = LAST_JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_accept") and is_on_floor(): jump()
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	var target_velocity = direction * MAX_SPEED
	if direction:
		velocity.x = move_toward(velocity.x, target_velocity, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	move_and_slide()
	

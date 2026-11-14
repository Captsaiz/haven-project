extends CharacterBody2D

@onready var floor_ray: RayCast2D = $RayCast2D
@onready var my_sprite: Sprite2D = $Sprite2D

const MAX_SPEED = 300.0
const ACCELERATION = 20.0
const FRICTION = 10.0
const JUMP_VELOCITY = -500.0
const BOUNCE_DIVIDER = 2.0
const MIN_BOUNCE_VELOCITY = 100.0 # Stops tiny endless micro-bounces

var LAST_JUMP_VELOCITY: float = 0.0
var PLATFORM_Y: float = 0.0
var ORIGIN_PLATFORM_Y: float = 0.0
var LAND_VELOCITY_Y: float = 0.0
var SPIN_INERTIA: float = 0.0

func _ready() -> void:
	my_sprite.change_image(0) # setup the_ball texture

func jump() -> void:
	if is_on_floor():
		ORIGIN_PLATFORM_Y = global_position.y
	
	velocity.y = JUMP_VELOCITY
	LAST_JUMP_VELOCITY = JUMP_VELOCITY
	LAND_VELOCITY_Y = 0.0 # Cancel bounce when manually jumping
	
	print("jump pos:" + str(PLATFORM_Y - global_position.y)) # DEBUG


func process_rotate() -> void:
	
	if is_on_floor():
		SPIN_INERTIA = remap(velocity.x, -MAX_SPEED, MAX_SPEED, -5, 5)
		
	rotation_degrees += SPIN_INERTIA	

func _physics_process(delta: float) -> void:
	
	# Update PLATFORM_Y dynamically with array detecting the platform below
	if floor_ray.is_colliding():
		PLATFORM_Y = floor_ray.get_collision_point().y
		print("update: " + str(PLATFORM_Y))
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0: # Get the fastest before touching the floor velocity
			LAND_VELOCITY_Y = velocity.y

	# Apply bounce on when touching the floor
	if is_on_floor() and LAND_VELOCITY_Y > MIN_BOUNCE_VELOCITY:
		velocity.y = -LAND_VELOCITY_Y / BOUNCE_DIVIDER 
		LAND_VELOCITY_Y = 0.0 # Reset so it doesn't accidentally bounce again

	# Jump if on the floor OR within a tiny Sabove PLATFORM_Y while falling
	var near_platform := (PLATFORM_Y - global_position.y) < 45 and velocity.y >= 0 # Avoid jump being fully unavailable
	if Input.is_action_pressed("ui_accept") and (is_on_floor() or near_platform):
		SPIN_INERTIA = remap(velocity.x, -MAX_SPEED, MAX_SPEED, -5, 5)
		jump()

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	var target_velocity := direction * MAX_SPEED
	
	if direction:
		velocity.x = move_toward(velocity.x, target_velocity, ACCELERATION) # speeding up 
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION) # speeding down
	
	move_and_slide()
	process_rotate()

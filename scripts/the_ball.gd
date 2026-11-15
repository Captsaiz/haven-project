extends CharacterBody2D

@onready var floor_ray: RayCast2D = $RayCast2D
@onready var my_sprite: Sprite2D = $Sprite2D



const FRICTION = 10.0
const BOUNCE_DIVIDER = 2.0
const MIN_BOUNCE_VELOCITY = 100.0 # Stops tiny endless micro-bounces

var ACCELERATION: float = 20.0 # beautiful global var's
var MAX_SPEED: float = 300.0
var JUMP_VELOCITY: float = -600.0
var LAST_JUMP_VELOCITY: float = 0.0
var PLATFORM_Y: float = 0.0
var ORIGIN_PLATFORM_Y: float = 0.0
var LAND_VELOCITY_Y: float = 0.0
var SPIN_INERTIA: float = 0.0
var SPAWN_POSITION: Vector2
var DIRECTION: int

func _ready() -> void:
	my_sprite.change_image(2) # setup the_ball texture
	SPAWN_POSITION = global_position

func jump() -> void:
	if is_on_floor():
		ORIGIN_PLATFORM_Y = global_position.y

	velocity.y = JUMP_VELOCITY
	LAST_JUMP_VELOCITY = JUMP_VELOCITY
	LAND_VELOCITY_Y = 0.0 # Cancel bounce when manually jumping
	
	print("jump pos:" + str(PLATFORM_Y - global_position.y)) # DEBUG

func dead_ball_effect(type_sprite: int) -> void:
	if type_sprite == 1:
		JUMP_VELOCITY = -800
		jump()
		JUMP_VELOCITY = -600
		
	if type_sprite == 2:
		MAX_SPEED = 1000.0
		var boost_dir = DIRECTION if DIRECTION != 0 else sign(velocity.x)
		if boost_dir == 0:
			boost_dir = 1.0 # Default right if completely still
			
		velocity.x = 1000.0 * boost_dir
		

func process_rotate() -> void:
	
	if is_on_floor():
		SPIN_INERTIA = remap(velocity.x, -MAX_SPEED, MAX_SPEED, -5, 5)
		
	rotation_degrees += SPIN_INERTIA	

func _physics_process(delta: float) -> void:
	if abs(velocity.x) <= 300.0:
		MAX_SPEED = 300.0
	
	# Update PLATFORM_Y dynamically with array detecting the platform below
	if floor_ray.is_colliding():
		PLATFORM_Y = floor_ray.get_collision_point().y
		print("update: " + str(PLATFORM_Y))
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0: # Get the fastest before touching the floor velocity
			LAND_VELOCITY_Y = velocity.y
	
	var platform_below = floor_ray.get_collider()
	if platform_below and platform_below.is_in_group("dead_ball") and is_on_floor():
		var type_sprite = platform_below.get_node("Sprite2D").current_costume
		dead_ball_effect(type_sprite)
		
	
	# Apply bounce on when touching the floor
	if is_on_floor() and LAND_VELOCITY_Y > MIN_BOUNCE_VELOCITY:
		velocity.y = -LAND_VELOCITY_Y / BOUNCE_DIVIDER 
		LAND_VELOCITY_Y = 0.0 # Reset so it doesn't accidentally bounce again

	# Jump if on the floor OR within a tiny Sabove PLATFORM_Y while falling
	var near_platform := (PLATFORM_Y - global_position.y) < 50 and velocity.y >= 0 # Avoid jump being fully unavailable
	if Input.is_action_pressed("ui_accept") and (is_on_floor() or near_platform) and floor_ray.is_colliding():
		if platform_below and platform_below.is_in_group("dead_ball") and platform_below.get_node("Sprite2D").current_costume != 0:
			var type_sprite = platform_below.get_node("Sprite2D").current_costume
			dead_ball_effect(type_sprite)
		else:
			jump()
			
		SPIN_INERTIA = remap(velocity.x, -MAX_SPEED, MAX_SPEED, -5, 5)
		

	# Horizontal movement
	DIRECTION = Input.get_axis("ui_left", "ui_right")
	var target_velocity := DIRECTION * MAX_SPEED
	
	if DIRECTION:
		velocity.x = move_toward(velocity.x, target_velocity, ACCELERATION) # speeding up 
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION) # speeding down
	
	move_and_slide()
	process_rotate()


func obstacle_death() -> void:
	set_physics_process(false) # disable _physic_process
	visible = false
	
	get_tree().call_group("dead_ball", "create_clone", $Sprite2D.current_costume, position, )
	
	$death_timer.start()
	
func _on_death_timer_timeout() -> void:
	global_position = SPAWN_POSITION
	
	SPIN_INERTIA = 0.0
	velocity = Vector2.ZERO
	
	set_physics_process(true)
	visible = true
	

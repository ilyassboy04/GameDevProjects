extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_wall_sliding = false
var jump_counter = 0

var state = false
@onready var collision_shape_2d = $CollisionShape2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_down = $RayCastDown

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	jump()
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	#sprite flip
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	#movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	wall_slide(delta)
	animation(direction)
	player_state()
	phasing()
	
	
	#vel.y < 0 = opp
func wall_slide(delta):
	if is_on_wall_only():
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
			is_wall_sliding = true
			print("wallslide confirm")
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += (gravity*delta)*2
		velocity.y = min(velocity.y,gravity)
		
		
func jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and jump_counter < 1:
		velocity.y = JUMP_VELOCITY
		jump_counter += 1
	elif is_on_floor():
		jump_counter = 0
		
func white_animation(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("White_Idle")
		else:
			animated_sprite_2d.play("White_Run")
	elif jump_counter == 1:
		animated_sprite_2d.play("White_Double_Jump")
	else:
		animated_sprite_2d.play("White_Jump")

func black_animation(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("Black_Idle")
		else:
			animated_sprite_2d.play("Black_Run")
	elif jump_counter == 1:
		animated_sprite_2d.play("Black_Double_Jump")
	else:
		animated_sprite_2d.play("Black_Jump")
		
func player_state():
	if Input.is_action_just_pressed("click") and state == false:
		state = true
	elif Input.is_action_just_pressed("click") and state == true:
		state = false
	
func state_checker():
	if state == false:
		print("false")
	elif state == true:
		print("true")

func animation(direction):
	if state == false:
		white_animation(direction)
	else:
		black_animation(direction)
		
func phasing():
	if state == true:
		set_collision_layer_value(1,false)
		set_collision_mask_value(1,false)
		set_collision_layer_value(2,true)
		set_collision_mask_value(2,true)
	else:
		set_collision_layer_value(1,true)
		set_collision_mask_value(1,true)
		set_collision_layer_value(2,false)
		set_collision_mask_value(2,false)
		
#git change test

extends KinematicBody2D



var jump_force = -800
var gravity = 2000
var velocity = Vector2.ZERO
var facing_direction = Vector2.RIGHT
onready var hand_rot = $HandRot
onready var player = $Player
var facingLeft = false

func _ready():
	# Set initial velocity to zero
	velocity = Vector2.ZERO

func _process(delta):
	# Reset horizontal velocity
	velocity.x = 0

	# Capture input for horizontal movement
	if Input.is_action_pressed("move_right"):
		velocity.x += PlayerStats.PLAYER_SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x -= PlayerStats.PLAYER_SPEED

	# Capture input for jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	LookAtMouse()
	HandleAnimation()
	# Move the character
	velocity = move_and_slide(velocity, Vector2.UP)


func LookAtMouse(): 
	var mouse_pos = get_global_mouse_position()
	
	if mouse_pos.x < global_position.x:
		facingLeft = true
		facing_direction.x = -1
	elif mouse_pos.x > global_position.x:
		facing_direction.x = 1
		facingLeft = false
	if facing_direction.x == -1:
		transform.x.x = -1  # Flip the entire character to the left
	else:
		transform.x.x = 1


func HandleAnimation():
	if velocity.x == 0:
		player.play("stand_idle")
	else:
		
		if facingLeft:
			if velocity.x < 0:
				player.play("stand_walk")
			else: 
				player.play("stand_walkback")
		else:
			if velocity.x > 0:
				player.play("stand_walk")
			else: 
				player.play("stand_walkback")

extends KinematicBody2D

var jump_force = -800
var gravity = 2000
var velocity = Vector2.ZERO
var facing_direction = Vector2.RIGHT
onready var hand_rot = $HandRot
onready var player = $Player
var facingLeft = false
var isRolling = false

# Variables
var is_dodging = false
var dodge_speed = 600
var dodge_duration = 0.5
var dodge_timer = 0.0
var dodge_direction = Vector2.ZERO

var can_dodge = true
var dodge_cooldown = 1.0
var cooldown_timer = 0.0

func _ready():
	# Set initial velocity to zero
	velocity = Vector2.ZERO

func _process(delta):
	# Reset horizontal velocity
	if not is_dodging:
		velocity.x = 0
	
	if is_dodging:
		update_dodge(delta)
	else:
		# Capture input for horizontal movement
		if !isRolling and Input.is_action_pressed("move_right"):
			velocity.x += PlayerStats.PLAYER_SPEED
		if !isRolling and Input.is_action_pressed("move_left"):
			velocity.x -= PlayerStats.PLAYER_SPEED
		
		# Capture input for dodging
		if can_dodge and Input.is_action_just_pressed("dodge"):
			start_dodge()

	# Handle cooldown
	if not can_dodge:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_dodge = true

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
	if is_dodging:
		player.play("dodge")
	elif velocity.x == 0:
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

func start_dodge():
	var mouse_pos = get_global_mouse_position()
	var input_direction = (mouse_pos - global_position).normalized()
	
	# Make sure dodge direction is either left or right
	if input_direction.x != 0:
		is_dodging = true
		dodge_timer = dodge_duration
		dodge_direction = Vector2(input_direction.x, 0).normalized()
		player.play("dodge")
		can_dodge = false
#		cooldown_timer = dodge_cooldown
#		print("Dodge started: direction ", dodge_direction)

func update_dodge(delta):
	dodge_timer -= delta
	if dodge_timer <= 0:
		is_dodging = false
#		print("Dodge ended")
	else:
		velocity.x = dodge_direction.x * dodge_speed
		move_and_slide(velocity)
#		print("Dodging: velocity ", velocity)

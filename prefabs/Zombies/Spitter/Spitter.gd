extends KinematicBody2D

var targetPlayer = null
onready var enemy_sprite = $EnemySprite
var moveSpeed = rand_range(200, 450)
var runSpeed = 0
var direction : Vector2
var velocity = Vector2.ZERO
var canMove = true

export var attackRate : float
var attackCooldown : float = 0

var isEscape = false

export var healingRate : float = 0.5
var healCounter = 0

var lastTargetPos : Vector2 = position
var alreadySelectTargetPos : bool = false

func _ready():
	set_physics_process(false)

func _process(delta):
	if isEscape:
		if targetPlayer != null:
#			direction = (targetPlayer.position + Vector2(rand_range(-300,300),0))  - position
			if !alreadySelectTargetPos:
				ChooseRandomPos()
			CheckIfArriveInLastTargetPos()
#			print("Xpos: " + str(position.x) + " - targetX: " + str(targetPlayer.position.x))
			direction.y = 0  # Restrict movement to the horizontal axis
	else:	
		if targetPlayer != null:
			direction = targetPlayer.position - position
			direction.y = 0  # Restrict movement to the horizontal axis

	if direction.x < 0:
		enemy_sprite.flip_h = false
	else:
		enemy_sprite.flip_h = true

func _physics_process(delta):
	if canMove:
		velocity = direction.normalized() * (moveSpeed + runSpeed)
		velocity.y = 0  # Ensure vertical velocity is zero
#	else:
#		enemy_sprite.play("idle")

	velocity = move_and_slide(velocity)

func ChooseRandomPos():
	randomize()
	var random_offset = Vector2(rand_range(-50, 150), 0)
	lastTargetPos = Vector2(global_position.x - RandomPoint(), 0)
	direction = lastTargetPos
	alreadySelectTargetPos = true
	print("New target position: " + str(lastTargetPos))

func RandomPoint():
	randomize()
	var pos : int = rand_range(0, 1)
	var val : int
	if pos == 0: val = -50
	else: val = 50
	return val

func CheckIfArriveInLastTargetPos():
	if position.x == lastTargetPos.x:
		lastTargetPos = targetPlayer.position
		alreadySelectTargetPos = false


func _on_HitCollider_body_entered(body):
	if body.is_in_group("Player"):
		ChooseRandomPos()

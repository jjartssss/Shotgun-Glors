extends KinematicBody2D

var targetPlayer = null
onready var enemy_sprite = $EnemySprite
var moveSpeed = rand_range(200, 450)

var direction : Vector2
var velocity = Vector2.ZERO
var canMove = true

export var attackRate : float
var attackCooldown : float = 0

func _ready():
	set_physics_process(false)

func _process(delta):
	if targetPlayer != null:
		direction = targetPlayer.position - position
		direction.y = 0  # Restrict movement to the horizontal axis

	if direction.x < 0:
		enemy_sprite.flip_h = true
	else:
		enemy_sprite.flip_h = false

func _physics_process(delta):
	if canMove:
		velocity = direction.normalized() * moveSpeed
		velocity.y = 0  # Ensure vertical velocity is zero
#	else:
#		enemy_sprite.play("idle")

	velocity = move_and_slide(velocity)

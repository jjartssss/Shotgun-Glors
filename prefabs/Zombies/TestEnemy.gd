extends KinematicBody2D

var targetPlayer = null
onready var enemy_sprite = $EnemySprite
export var moveSpeed = 300

var direction : Vector2
var velocity = Vector2.ZERO

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
	velocity = direction.normalized() * moveSpeed
	velocity.y = 0  # Ensure vertical velocity is zero

	if velocity.x != 0:
		enemy_sprite.play("walk")
	else:
		enemy_sprite.play("idle")

	velocity = move_and_slide(velocity)

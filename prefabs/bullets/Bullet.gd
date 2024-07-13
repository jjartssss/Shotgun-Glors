extends Area2D
class_name RegularBullet
export var speed = 3500
var bulletDamage : int
var direction = Vector2.ZERO

export var alreadyHit = false

func _ready():
	set_process(true)

func _process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func set_direction(new_direction):
	direction = new_direction.normalized()
	rotation = direction.angle()  # Update the rotation to match the direction

func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Destructible"):
		queue_free()

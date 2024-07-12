extends Area2D
class_name RegularBullet
export var speed = 3500
var bulletDamage : int
var direction = Vector2.ZERO

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

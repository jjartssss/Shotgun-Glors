extends KinematicBody2D

var gravity = 2000
var velocity = Vector2.ZERO
var acidArea = preload("res://prefabs/Zombies/Spitter/AcidArea.tscn")

func _ready():
	# Set initial velocity to zero
	velocity = Vector2.ZERO



func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Ground"):
		var acid = acidArea.instance()
		var root = get_tree().current_scene
		root.add_child(acid)
		acid.position = global_position
		queue_free()

extends "res://scripts/States/States.gd"


var playerInAttackRange = false
var target = null
onready var attack_ray_cast_left = $"../../attackRayCastLeft"
onready var attack_ray_cast_right = $"../../attackRayCastRight"

func enter():
	.enter()
	owner.set_physics_process(true)
	animSprite.play("walk")
	playerInAttackRange = false
	get_parent().get_parent().canMove = true

func exit():
	.exit()
	owner.set_physics_process(false)


func _on_AttackDetectM1_body_entered(body):
	if body.is_in_group("Player"):
		playerInAttackRange = true
		print("Player in attack range " + body.name)

func transition():
	if attack_ray_cast_left.is_colliding():
		var collider = attack_ray_cast_left.get_collider()
		if collider.is_in_group("Player"):
			playerInAttackRange = true
			print("Ey, detected player!")
		else:
			playerInAttackRange = false
	elif attack_ray_cast_right.is_colliding():
		var collider = attack_ray_cast_right.get_collider()
		if collider.is_in_group("Player"):
			playerInAttackRange = true
			print("Ey, detected player!")
		else:
			playerInAttackRange = false
	else:
		playerInAttackRange = false
	
	if playerInAttackRange:
		animSprite.frame = 0
		get_parent().change_state("Attack_m1")

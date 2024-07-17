extends "res://scripts/States/States.gd"
onready var ray_cast_left = $"../../rayCastLeft"
onready var ray_cast_right = $"../../rayCastRight"


var player_detected = false
var target = null
var parentEnemy

# Vars for Escape
export(NodePath) var healthPath
var healthManager : EnemyHealth

func _ready():
	parentEnemy = get_parent().get_parent()
	healthManager = get_node(healthPath)

func enter():
	.enter()
	owner.set_physics_process(true)
	animSprite.frame = 0
	animSprite.play("idle")
	player_detected = false
	parentEnemy.attackCooldown = 0
	get_parent().get_parent().canMove = false

func _on_ChaseDetect_body_entered(body):
	if body.is_in_group("Player"):
		player_detected = true
		target = body

func transition():
	if ray_cast_left.is_colliding():
		var collider = ray_cast_left.get_collider()
		if collider.is_in_group("Player"):
			player_detected = true
			target = collider
			print("Ey, detected player!")
		else:
			player_detected = false
	elif ray_cast_right.is_colliding():
		var collider = ray_cast_right.get_collider()
		if collider.is_in_group("Player"):
			player_detected = true
			target = collider
			print("Ey, detected player!")
		else:
			player_detected = false
	else:
		player_detected = false
		
	CheckHealth()
	
	if parentEnemy.attackCooldown >= parentEnemy.attackRate and player_detected:
		get_parent().change_state("ChaseNormal")
		get_parent().target = target
		get_parent().get_parent().targetPlayer = target
		parentEnemy.attackCooldown = 0
	else:
		parentEnemy.attackCooldown += 0.05

func CheckHealth():
	if healthManager.healthCurrent <= (healthManager.healthMax / 2):
		get_parent().change_state("Escape")

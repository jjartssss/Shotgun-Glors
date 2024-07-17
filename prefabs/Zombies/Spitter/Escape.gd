extends "res://scripts/States/States.gd"


var playerInAttackRange = false
var target = null
onready var attack_ray_cast_left = $"../../attackRayCastLeft"
onready var attack_ray_cast_right = $"../../attackRayCastRight"

var parentEnemy



# Vars for Escape
export(NodePath) var healthPath
var healthManager : EnemyHealth

func _ready():
	healthManager = get_node(healthPath)

func enter():
	.enter()
	owner.set_physics_process(true)
	animSprite.play("run")
	playerInAttackRange = false
	parentEnemy = get_parent().get_parent()
	parentEnemy.canMove = true
	parentEnemy.isEscape = true
	parentEnemy.runSpeed = 300

func exit():
	.exit()
	owner.set_physics_process(false)


func _on_AttackDetectM1_body_entered(body):
	if body.is_in_group("Player"):
		playerInAttackRange = true
		print("Player in attack range " + body.name)

func transition():
	if parentEnemy.healCounter >= parentEnemy.healingRate:
		parentEnemy.healCounter = 0
#		print(str(healthManager.healthCurrent))
		healthManager.Heal(5)
	else:
		parentEnemy.healCounter += .05
	CheckHealth()


func CheckHealth():
	if healthManager.healthCurrent >= (healthManager.healthMax / 2 + (healthManager.healthMax / 3)):
		get_parent().change_state("Idle")
		parentEnemy.runSpeed = 0
		parentEnemy.isEscape = false



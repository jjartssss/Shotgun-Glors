extends "res://scripts/States/States.gd"


var playerInAttackRange = false
var attackFinished = false
var target = null

func enter():
	.enter()
	owner.set_physics_process(true)
	animSprite.frame = 0
	attackFinished = false
	playerInAttackRange = false
	animSprite.play("attackm1")

func exit():
	.exit()
	owner.set_physics_process(false)

func _on_AttackDetectM1_body_exited(body):
	if body.is_in_group("Player"):
		playerInAttackRange = false

#
func transition():
	if attackFinished:
		get_parent().change_state("Idle")


func _on_EnemySprite_animation_finished():
	if animSprite.animation == "attackm1":
		attackFinished = true

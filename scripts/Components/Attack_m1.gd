extends "res://scripts/States/States.gd"


var playerInAttackRange = false
var attackFinished = false
var target = null
onready var animation_player = $"../../attackAnimationPlayer"
var acidBullet = preload("res://prefabs/Zombies/Spitter/AerialProjectile.tscn")
func enter():
	.enter()
	owner.set_physics_process(true)
	animSprite.frame = 0
	attackFinished = false
	playerInAttackRange = false
#	animSprite.play("attackm1")
	animation_player.play("attackm1")

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


#func _on_EnemySprite_animation_finished():
#	if animSprite.animation == "attackm1":
#		animation_player.play("def")
#		attackFinished = true


func ShootProjectile():
	var target = get_parent().target
	if target != null:
		var acid = acidBullet.instance()
		var root = get_tree().current_scene
		root.add_child(acid)
		acid.position = Vector2(target.position.x, target.position.y - 900)

func AttackFinished():
	attackFinished = true

#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "attackm1":
#		attackFinished = true

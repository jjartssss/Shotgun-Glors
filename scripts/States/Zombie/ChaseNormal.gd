extends "res://scripts/States/States.gd"

func enter():
	.enter()
	owner.set_physics_process(true)
	animSprite.play("idle")


func exit():
	.exit()
	owner.set_physics_process(false)

extends Node2D

onready var particles_2d = $Particles2D


func _on_Timer_timeout():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	particles_2d.emitting = false
	queue_free()

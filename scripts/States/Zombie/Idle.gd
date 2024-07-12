extends "res://scripts/States/States.gd"


var player_detected = false
var target = null
func _on_ChaseDetect_body_entered(body):
	if body.is_in_group("Player"):
		player_detected = true
		target = body
func transition():
	if player_detected:
		get_parent().change_state("ChaseNormal")
		get_parent().target = target
		get_parent().get_parent().targetPlayer = target

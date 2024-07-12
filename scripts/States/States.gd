extends Node
class_name State

onready var txtState = owner.find_node("txtState")

func _ready():
	set_physics_process(false)

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass

func _physics_process(delta):
	transition()
	txtState.text = name

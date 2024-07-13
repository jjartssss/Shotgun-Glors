extends Area2D
class_name Pickable

export(Resource) var whatGun
export var gunSprite : Texture
onready var gun_sprite = $GunSprite
onready var lbl_text = $lblText

func _ready():
	if gunSprite != null:
		gun_sprite.texture = gunSprite

func _on_Pickable_body_entered(body):
	if body.is_in_group("Player"):
		lbl_text.visible = true
		if Input.is_action_just_pressed("interact"):
			if PlayerStats.GunsInHand.size() < 2:
				print("Item picked")
			else:
				print("Already has two guns")


func _on_Pickable_body_exited(body):
	if body.is_in_group("Player"):
		lbl_text.visible = false

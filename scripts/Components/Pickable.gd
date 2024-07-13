extends Area2D
class_name Pickable

export(Resource) var whatGun
export var gunSprite : Texture
onready var gun_sprite = $GunSprite
onready var lbl_text = $lblText
var gameManager : GameManager
var canPickup = false

func _ready():
	if gunSprite != null:
		gun_sprite.texture = gunSprite

func _on_Pickable_body_entered(body):
	if body.is_in_group("Player"):
		lbl_text.visible = true
		canPickup = true


func _input(event):
	if canPickup:
		if Input.is_action_just_pressed("interact"):
			print("working ba? " + str(PlayerStats.GunsInHand.size()))
			if PlayerStats.GunsInHand.size() < 2:
				AddToGunCollection(whatGun)
			else:
				print("Already has two guns")



func _on_Pickable_body_exited(body):
	if body.is_in_group("Player"):
		lbl_text.visible = false
		canPickup = false
	
func AddToGunCollection(gun : GunResource):
	PlayerStats.GunsInHand.append(gun)
	print(gun.GunName + " is added to collection")
	var root = get_tree().current_scene
	gameManager = root.find_node("GameManager")
	gameManager.UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite,PlayerStats.GunsInHand[1].GunSprite)
	queue_free()

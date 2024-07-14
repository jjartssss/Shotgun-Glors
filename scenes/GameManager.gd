extends Node2D
class_name GameManager

onready var txt_health = $"../Control/CanvasLayer/BulletsAndHealth/txtHealth"
onready var txt_bullet = $"../Control/CanvasLayer/BulletsAndHealth/txtBullet"

onready var gun_one = $"../Control/CanvasLayer/Guns/GunOne"
onready var gun_two = $"../Control/CanvasLayer/Guns/GunTwo"
onready var gun_three = $"../Control/CanvasLayer/Guns/GunThree"

onready var g_1 = $"../Control/CanvasLayer/Guns/g1"
onready var g_2 = $"../Control/CanvasLayer/Guns/g2"
onready var g_3 = $"../Control/CanvasLayer/Guns/g3"


func UpdateBulletUI():
	txt_bullet.text = "Bullet: " + str(PlayerStats.GunCurrentBullet) + " / " + str(PlayerStats.GunMaxBullet)

func UpdateGunCollection(GunOne : Texture, GunTwo : Texture, GunThree : Texture):
	
	if GunOne != null:
		gun_one.texture = GunOne
	if GunTwo != null:
		gun_two.texture = GunTwo
	else:
		gun_two.texture = null
	if GunThree != null:
		gun_three.texture = GunThree
	else:
		gun_three.texture = null

func UpdateWeaponUI():
	if PlayerStats.GunsInHand.size() == 1:
		UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite, null, null)
	elif PlayerStats.GunsInHand.size() == 2:
		UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite,PlayerStats.GunsInHand[1].GunSprite, null)
	elif PlayerStats.GunsInHand.size() > 2:
		UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite,PlayerStats.GunsInHand[1].GunSprite, PlayerStats.GunsInHand[2].GunSprite)


func SwitchGuns(whatGun: int):
	OffAllGunSelected()
	match(whatGun):
		0:
			g_1.visible = true
		1:
			g_2.visible = true
		2:
			g_3.visible = true

func OffAllGunSelected():
	g_1.visible = false
	g_2.visible = false
	g_3.visible = false

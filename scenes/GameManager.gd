extends Node2D
class_name GameManager

onready var txt_health = $"../Control/CanvasLayer/BulletsAndHealth/txtHealth"
onready var txt_bullet = $"../Control/CanvasLayer/BulletsAndHealth/txtBullet"

onready var gun_one = $"../Control/CanvasLayer/Guns/GunOne"
onready var gun_two = $"../Control/CanvasLayer/Guns/GunTwo"
onready var g_1 = $"../Control/CanvasLayer/Guns/g1"
onready var g_2 = $"../Control/CanvasLayer/Guns/g2"


func UpdateBulletUI():
	txt_bullet.text = "Bullet: " + str(PlayerStats.GunCurrentBullet) + " / " + str(PlayerStats.GunMaxBullet)

func UpdateGunCollection(GunOne : Texture, GunTwo : Texture):
	if GunOne != null:
		gun_one.texture = GunOne
	if GunTwo != null:
		gun_two.texture = GunTwo
	else:
		gun_two.texture = null

func SwitchGuns(whatGun: int):
	if whatGun == 0:
		g_1.visible = true
		g_2.visible = false
	else:
		g_1.visible = false
		g_2.visible = true

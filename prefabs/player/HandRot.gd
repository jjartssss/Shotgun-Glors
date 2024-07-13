extends Position2D

var facing_direction = Vector2.RIGHT

export(PackedScene) var ProjectileScene
onready var hand = $Hand
onready var shotgunFX = preload("res://prefabs/FX/ShotgunFX.tscn")
# CHANGE THIS LATER - 
onready var bullet_pos = $bulletPos

# Gun Resource
export(Array, Resource) var gunResources: Array
onready var animation_player = $"../AnimationPlayer"

var numOfBullets = 1
var accuracy = 25
var isAutomatic = false
var root
var GameManager : GameManager

var CurrentGunResource : GunResource

var canShoot = true
var shootTimer = 0
var isReloading = false


# Variables for dropping Gun
var pickableGun = load("res://scripts/Components/Pickable.tscn")



func _ready():
	# Connect input event if necessary
	set_process_input(true)
	root = get_tree().current_scene
	GameManager = root.find_node("GameManager") # need for updating UI
	SwitchGun(0)
	
	# For Testing
	for gun in gunResources:
		if gun is GunResource:
			AddToGunCollection(gun)
	CurrentGunResource = PlayerStats.GunsInHand[0]
	GameManager.UpdateGunCollection(CurrentGunResource.GunSprite, null, null)
	
func PickupGun():
	if PlayerStats.GunsInHand.size() >= 2:
		print("Already have 2 Guns")
	else: 
		print("Gun pickup")

func AddToGunCollection(gun : GunResource):
	PlayerStats.GunsInHand.append(gun)
	print(gun.GunName + " is added to collection")
	if PlayerStats.GunsInHand.size() >= 2:
		GameManager.UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite,PlayerStats.GunsInHand[1].GunSprite, null)
		pass


func SwitchGun(whatGun : int):
	if PlayerStats.GunsInHand.size() > whatGun:
		var first_gun = PlayerStats.GunsInHand[whatGun]
		GameManager.SwitchGuns(whatGun)
		if first_gun is GunResource:
			print("Selected Gun Name: ", first_gun.GunName)
			# SET GUN RESOURCE TO CURRENT GUN
			CurrentGunResource = first_gun
			# Change Gun Bullet User Interface by changing the global script player stats
			UpdateBulletUI()
		else:
			print("First element is not a GunResource.")
	else:
		print("No guns available in the gunResources array.")

func UpdateBulletUI():
	PlayerStats.GunCurrentBullet = CurrentGunResource.BulletLeft
	PlayerStats.GunMaxBullet = CurrentGunResource.BulletMax
	GameManager.UpdateBulletUI()

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var angle = direction.angle()

	if mouse_pos.x < global_position.x:
		facing_direction.x = -1
	elif mouse_pos.x > global_position.x:
		facing_direction.x = 1
	
	if facing_direction.x == -1:
		scale.x = -1  # Flip the entire character to the left
		scale.y = -1
		rotation = -angle
	else:
		scale.x = 1
		scale.y = 1
		rotation = angle
	if !canShoot:
		shootTimer += delta
		if shootTimer > CurrentGunResource.FireRate:
			canShoot = true



func _input(event):
#	if event is InputEventMouseButton and event.pressed:
#		if event.button_index == BUTTON_LEFT:
#			for i in range(numOfBullets):
#				fire_projectile(get_global_mouse_position())
	if PlayerStats.GunCurrentBullet > 0 :
		if CurrentGunResource.AutoFire :
			if Input.is_action_pressed("shoot") and canShoot:
				canShoot = false
				shootTimer = 0
				AddBulletEffects()
				CurrentGunResource.BulletLeft -= 1
				UpdateBulletUI()
				animation_player.stop()
				isReloading = false
				for i in range(CurrentGunResource.BulletCount):
					fire_projectile(get_global_mouse_position())
		else:
			if event and Input.is_action_just_pressed("shoot") and canShoot:
				canShoot = false
				shootTimer = 0
				AddBulletEffects()
				CurrentGunResource.BulletLeft -= 1
				UpdateBulletUI()
				animation_player.stop()
				isReloading = false
				for i in range(CurrentGunResource.BulletCount):
					fire_projectile(get_global_mouse_position())

	if CurrentGunResource.GunName == "ShotGun" and Input.is_action_just_pressed("reload") and CurrentGunResource.BulletLeft < CurrentGunResource.BulletMax:
#		hand.play("reload")
		animation_player.play("reload")
		isReloading = true
	
	if Input.is_action_just_pressed("weapon_one") and !isReloading:
		SwitchGun(0)
	if Input.is_action_just_pressed("weapon_two") and !isReloading:
		SwitchGun(1)
	if Input.is_action_just_pressed("weapon_three") and !isReloading:
		SwitchGun(2)
	
	if Input.is_action_just_pressed("drop_item") and CurrentGunResource.GunName != "ShotGun":
		DropGun()

func DropGun():
	var droppedGun: Pickable = pickableGun.instance()
	root.add_child(droppedGun)
	droppedGun.position = global_position
	droppedGun.whatGun = CurrentGunResource
	droppedGun.gunSprite = CurrentGunResource.GunSprite
	droppedGun.whatGun.BulletLeft = CurrentGunResource.BulletLeft
	droppedGun.gun_sprite.texture = CurrentGunResource.GunSprite
	
	PlayerStats.GunsInHand.erase(CurrentGunResource)
	SwitchGun(0)
	print(PlayerStats.GunsInHand)
	if PlayerStats.GunsInHand.size() == 1:
		GameManager.UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite, null, null)
	elif PlayerStats.GunsInHand.size() == 2:
		GameManager.UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite,PlayerStats.GunsInHand[1].GunSprite, null)
	elif PlayerStats.GunsInHand.size() > 2:
		GameManager.UpdateGunCollection(PlayerStats.GunsInHand[0].GunSprite,PlayerStats.GunsInHand[1].GunSprite, PlayerStats.GunsInHand[2].GunSprite)
	 

func AddBulletEffects():
	randomize()
	var shotgunEffects = shotgunFX.instance()
	root.add_child(shotgunEffects)
	shotgunEffects.global_position = bullet_pos.global_position


func fire_projectile(target_position):
	hand.play("shoot")
	
	var projectile : RegularBullet = ProjectileScene.instance()
	root.add_child(projectile)
	
	projectile.global_position = bullet_pos.global_position
	projectile.speed = CurrentGunResource.BulletSpeed
	projectile.bulletDamage = CurrentGunResource.BulletDamage
	
	var direction = target_position - global_position + Vector2(rand_range(-CurrentGunResource.BulletAccuracy, CurrentGunResource.BulletAccuracy), rand_range(-CurrentGunResource.BulletAccuracy, CurrentGunResource.BulletAccuracy))
	projectile.set_direction(direction)


func _on_Hand_animation_finished():
	if hand.animation == "shoot":
		hand.play("idle")
#	if hand.animation == "reload":
#		if PlayerStats.GunUsing == 0:
#			CurrentGunResource.BulletLeft = CurrentGunResource.BulletMax
#			UpdateBulletUI()
#		isReloading = false
#		hand.play("idle")
	


func AddOneBullet():
	if CurrentGunResource.BulletLeft < CurrentGunResource.BulletMax:
		CurrentGunResource.BulletLeft += 1
		UpdateBulletUI()
	else:
		StopReloading()
		isReloading = false


func StopReloading():
	if animation_player.is_playing():
		animation_player.play("stop")
		animation_player.stop()
		print("animation stop")

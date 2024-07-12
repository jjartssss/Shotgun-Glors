extends Position2D

var facing_direction = Vector2.RIGHT

export(PackedScene) var ProjectileScene
onready var hand = $Hand
onready var shotgunFX = preload("res://prefabs/FX/ShotgunFX.tscn")
# CHANGE THIS LATER - 
onready var bullet_pos = $bulletPos

# Gun Resource
export(Array, Resource) var gunResources: Array

var numOfBullets = 1
var accuracy = 25
var isAutomatic = false
var root
func _ready():
	# Connect input event if necessary
	set_process_input(true)
	root = get_tree().current_scene
#	for gun in gunResources:
#		if gun is GunResource:
#			print("Gun Name: ", gun.GunName, ", Damage: ", gun.BulletDamage)
	

func SwitchGun(whatGun : int):
	if gunResources.size() > whatGun:
		var first_gun = gunResources[whatGun]
		
		if first_gun is GunResource:
			print("Selected Gun Name: ", first_gun.GunName)
			print("Selected Gun Damage: ", first_gun.BulletDamage)
			numOfBullets = first_gun.BulletCount
			accuracy = first_gun.BulletAccuracy
			isAutomatic = first_gun.AutoFire
			# Change Gun Bullet User Interface by changing the global script player stats
			
		else:
			print("First element is not a GunResource.")
	else:
		print("No guns available in the gunResources array.")



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

func _input(event):
#	if event is InputEventMouseButton and event.pressed:
#		if event.button_index == BUTTON_LEFT:
#			for i in range(numOfBullets):
#				fire_projectile(get_global_mouse_position())
	if isAutomatic:
		if Input.is_action_pressed("shoot"):
			AddBulletEffects()
			for i in range(numOfBullets):
				fire_projectile(get_global_mouse_position())
	else:
		if event and Input.is_action_just_pressed("shoot"):
			AddBulletEffects()
			for i in range(numOfBullets):
				fire_projectile(get_global_mouse_position())


	if event and Input.is_action_just_pressed("reload"):
		hand.play("reload")
	
	if event and Input.is_action_just_pressed("weapon_one"):
		SwitchGun(0)
	if event and Input.is_action_just_pressed("weapon_two"):
		SwitchGun(1)
	

func AddBulletEffects():
	randomize()
	var shotgunEffects = shotgunFX.instance()
	root.add_child(shotgunEffects)
	shotgunEffects.global_position = bullet_pos.global_position


func fire_projectile(target_position):
	hand.play("shoot")
	
	var projectile = ProjectileScene.instance()
	root.add_child(projectile)
	
	projectile.global_position = bullet_pos.global_position
	
	
	var direction = target_position - global_position + Vector2(rand_range(-accuracy, accuracy), rand_range(-accuracy, accuracy))
	projectile.set_direction(direction)


func _on_Hand_animation_finished():
	if hand.animation == "shoot":
		hand.play("idle")
	if hand.animation == "reload":
		hand.play("idle")
	

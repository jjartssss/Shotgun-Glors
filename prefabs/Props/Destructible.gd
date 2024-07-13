extends Area2D


export(NodePath) var hitCollisionPath
var hitCollider : CollisionShape2D

export(NodePath) var healthPath
var healthManager : EnemyHealth

export(NodePath) var animationPath
var animPlayer : AnimationPlayer


# Blood effect
var bloodEffect = load("res://prefabs/FX/Zombie/BloodSplatter1.tscn")
export var particleEffect : PackedScene
export var hasParticleEffect : bool
export var hasDropLoot : bool
export(Array, Resource) var loots : Array

var pickable = load("res://scripts/Components/Pickable.tscn")

var alreadyDropLoot = false

func _ready(): 
	if hitCollisionPath != null:
		hitCollider = get_node(hitCollisionPath)
	if healthPath != null:
		healthManager = get_node(healthPath)
	if animationPath != null:
		animPlayer = get_node(animationPath)

func AddParticle(area):
	var particle = particleEffect.instance()
	get_tree().current_scene.add_child(particle)
	particle.global_position = area.global_position
	particle.rotation = global_position.angle_to_point(area.global_position)
	if area.global_position.x > global_position.x:
		particle.scale.x = 1
	else:
		particle.scale.x = -1

func DropLoot():
	randomize()
	var chosen : int = rand_range(0, loots.size()-1)
	print(str(chosen))
	var gunResource : GunResource = loots[chosen]
	
	var itemDrop : Pickable = pickable.instance()
	itemDrop.whatGun = gunResource
	itemDrop.gunSprite = gunResource.GunSprite
#	itemDrop.gun_sprite.texture = itemDrop.gunSprite
	itemDrop.position = global_position
	get_tree().current_scene.add_child(itemDrop)
	

func _on_Destructible_area_entered(area):
	if area.is_in_group("Bullet"):
		if !area.alreadyHit:
			area.alreadyHit = true
			
			if hasParticleEffect:
				AddParticle(area)
			
			if !alreadyDropLoot and hasDropLoot and healthManager.healthCurrent < 0:
				DropLoot()
				alreadyDropLoot = true
			
			animPlayer.play("hit")
			var bullet : RegularBullet = area
			healthManager.DamageHealth(bullet.bulletDamage)
			print("Damage taken " + str(bullet.bulletDamage))
			area.queue_free()

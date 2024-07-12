extends Area2D


export(NodePath) var hitCollisionPath
var hitCollider : CollisionShape2D

export(NodePath) var healthPath
var healthManager : EnemyHealth

export(NodePath) var animationPath
var animPlayer : AnimationPlayer


# Blood effect
var bloodEffect = load("res://prefabs/FX/Zombie/BloodSplatter1.tscn")


func _ready(): 
	if hitCollisionPath != null:
		hitCollider = get_node(hitCollisionPath)
	if healthPath != null:
		healthManager = get_node(healthPath)
	if animationPath != null:
		animPlayer = get_node(animationPath)


func _on_HitCollider_area_entered(area):
	if area.is_in_group("Bullet"):
		var bloodInstance = bloodEffect.instance()
		get_tree().current_scene.add_child(bloodInstance)
		bloodInstance.global_position = area.global_position
#		bloodInstance.rotation = global_position.angle_to_point(area.global_position)
		if area.global_position.x > global_position.x:
			bloodInstance.scale.x = 1
		else:
			bloodInstance.scale.x = -1
		
		animPlayer.play("hit_normal")
		var bullet : RegularBullet = area
		healthManager.DamageHealth(bullet.bulletDamage)
		print("Damage taken " + str(bullet.bulletDamage))
		area.queue_free()

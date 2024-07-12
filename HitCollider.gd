extends Area2D


export(NodePath) var hitCollisionPath
var hitCollider : CollisionShape2D

export(NodePath) var healthPath
var healthManager : EnemyHealth

func _ready(): 
	if hitCollisionPath != null:
		hitCollider = get_node(hitCollisionPath)
	if healthPath != null:
		healthManager = get_node(healthPath)


func _on_HitCollider_area_entered(area):
	if area.is_in_group("Bullet"):
		var bullet : RegularBullet = area
		healthManager.DamageHealth(bullet.bulletDamage)
		print("Damage taken " + str(bullet.bulletDamage))
		area.queue_free()

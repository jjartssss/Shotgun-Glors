extends Node2D
class_name EnemyHealth

export var healthMax : int
export var healthCurrent : int

export var showHealthBar : bool


func DamageHealth(damage:int):
	healthCurrent -= damage
	if healthCurrent <= 0:
		get_parent().queue_free() # remove unit

func Heal(heal: int):
	healthCurrent += heal
	if healthCurrent > healthMax:
		healthCurrent = healthMax 



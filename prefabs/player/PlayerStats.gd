extends Node

var PLAYER_MAX_HEALTH = 100
var PLAYER_CURRENT_HEALTH = 100

var PLAYER_SPEED = 700

export(Array, Resource) var GunsInHand: Array

var GunUsing = 0
var FirstGun : String = "Shotgun"
var SecondGun : String = "none"

# Default values
var GunCurrentBullet : int = 4
var GunMaxBullet : int = 4



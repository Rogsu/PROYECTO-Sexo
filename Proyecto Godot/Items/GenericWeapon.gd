extends Area2D

var player: KinematicBody2D

export var damage = 0
export var knockback = 0
export var stun = [0,0]
export var burnChance = 0

func _ready():
	yield(get_parent(),"ready")
	player = get_node("/root/TestZone/Player")

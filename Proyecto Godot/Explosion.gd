extends Area2D

export var damage = 0
var knockback = 400
var slow = [1,0]
var burnChance = 0
var stun = [0,0]
var explosion = [0,0]


func _on_Explosion_area_entered(area):
	queue_free()

extends "res://Items/Ammo/GenericBullet.gd"

func _on_Nail_area_entered(area):
	queue_free()

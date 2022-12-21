extends "res://Items/Ammo/GenericBullet.gd"

func _on_Bullet_area_entered(area):
	queue_free()

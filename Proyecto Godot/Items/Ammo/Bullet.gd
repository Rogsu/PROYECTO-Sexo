extends Area2D

var direction = Vector2()

var parentWeapon = load("res://Items/Revolver.tscn").instance()

var damage = parentWeapon.damage
var speed = 1000
var knockback = parentWeapon.knockback
var isActive = 1

func _ready():
	rotate(direction.angle())

func _physics_process(delta):
	damage = parentWeapon.damage
	if(isActive):
		global_position += speed * delta * direction
		if(parentWeapon.position.distance_to(position) > 1200):
			queue_free()


func _on_Bullet_area_entered(area):
	queue_free()

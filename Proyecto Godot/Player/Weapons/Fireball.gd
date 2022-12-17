extends Area2D

var direction = Vector2()

export var speed = 300
export var damage = 1
export var knockback = 1000

func _ready():
	rotate(direction.angle())

func _physics_process(delta):
	global_position += speed * delta * direction

func _on_Fireball_body_entered(body):
	queue_free()


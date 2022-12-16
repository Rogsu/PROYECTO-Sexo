extends Area2D


var speed = 150
var direction = Vector2()

func _ready():
	rotate(direction.angle())

func _physics_process(delta):
	global_position += speed * delta * direction





func _on_Fireball_body_entered(body):
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

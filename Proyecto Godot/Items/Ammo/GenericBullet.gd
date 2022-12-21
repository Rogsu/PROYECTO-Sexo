extends Area2D

var direction = Vector2()

var damage 
export var speed = 1
var knockback 
var isActive = 1

func _ready():
	rotate(direction.angle())

func _physics_process(delta):
	if(isActive):
		# Movimiento
		var direct_state = get_world_2d().direct_space_state
		var collision = direct_state.intersect_ray(global_position, global_position + speed * delta * direction)
		if(collision): 
			global_position = collision.position
		else: 
			global_position += speed * delta * direction



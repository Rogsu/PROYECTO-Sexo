extends Area2D

var direction = Vector2()

var damage = 0
export var speed = 1
var slow: Array = [1,0] # [Potencia de slow (1 a 0), Duracion de slow]
var stun = [0,0] # Duracion de stun
var burnChance = 0 # Del 0 al 1
var knockback = 0
var explosion = [0,0] 
var critChance = 0

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



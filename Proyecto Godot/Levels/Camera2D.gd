extends Camera2D

export var NOISE_SHAKE_SPEED: float = 30.0
export var SHAKE_DECAY_RATE: float = 3.0

onready var noise = OpenSimplexNoise.new()

var noise_i: float = 0.0
var shake_strength: float = 0.0

var player: KinematicBody2D

func _ready():
	yield(get_parent(),"ready")
	player = get_node("/root/TestZone/Player")
	randomize()
	noise.seed = randi()
	noise.period = 2
	
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("TileMap").cell_size
	# position marca arriba a la izq y end marca abajo a la izq
	limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y

func _physics_process(delta):
	global_position.x = clamp(lerp(global_position.x,player.global_position.x,0.2),-1023,1280)
	global_position.y = clamp(lerp(global_position.y,player.global_position.y,0.2),-820,660)
	
	# Decrementa la intensidad
	shake_strength = lerp(shake_strength, 0, SHAKE_DECAY_RATE * delta)
	offset = get_noise_offset(delta, NOISE_SHAKE_SPEED, shake_strength)

func get_noise_offset(delta, speed, strength):
	# noise_i cumple la funcion de moverse a traves del noise a la 
	# velocidad indicada por speed
	noise_i += delta * speed
	# Asigno 1 y 100 en los valores de X del noise para que los datos obtenidos
	# para X y para Y no se relacionen
	return Vector2(
		noise.get_noise_2d(1, noise_i) * strength,
		noise.get_noise_2d(100, noise_i) * strength
	)

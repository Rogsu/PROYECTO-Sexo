extends Position2D


onready var player = get_parent().get_node("Player")

func _ready():
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("TileMap").cell_size
	# position marca arriba a la izq y end marca abajo a la izq
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y

func _physics_process(delta):
	global_position = lerp(global_position,player.global_position,0.2)

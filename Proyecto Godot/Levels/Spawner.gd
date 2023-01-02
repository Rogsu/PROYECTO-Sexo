extends Path2D

onready var camera = get_parent().get_node("Camera2D")

func _physics_process(delta):
	global_position = camera.global_position


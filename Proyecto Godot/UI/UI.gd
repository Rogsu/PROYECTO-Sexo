extends CanvasLayer

var total_spawns = 0
var current_value = 0

signal next_wave

func _physics_process(delta):
	$Container/TextureProgress.value = current_value
	$Container/TextureProgress.max_value = total_spawns


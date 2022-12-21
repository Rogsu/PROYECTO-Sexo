extends CanvasLayer

var total_spawns = 0
var current_value = 0

signal next_wave

func _physics_process(delta):
	$Container/TextureProgress.value = current_value
	$Container/TextureProgress.max_value = total_spawns
	$Container/Percentage.text = str(int(round((float(current_value) / total_spawns) * 100))) + "%"
	if(current_value == total_spawns): 
		emit_signal("next_wave")
		current_value = 0


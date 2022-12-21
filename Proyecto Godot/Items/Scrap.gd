extends Area2D

var scrap_lvl = 1
var scrap_value = 5
var attracted = false
var player_pos = Vector2()

func _ready():
	match scrap_lvl:
		1:
			pass
		2:
			scrap_value *= 10
			set_modulate(Color(0,0,1,1)) # Azul
		3:
			scrap_value *= 100
			set_modulate(Color(0.541176,0.168627,0.886275,1)) # Violeta

func _physics_process(delta):
	player_pos = get_parent().get_node("Player").position
	if(attracted):
		global_position = lerp(global_position,player_pos,0.1)





func _on_Scrap_body_entered(body):
	queue_free()

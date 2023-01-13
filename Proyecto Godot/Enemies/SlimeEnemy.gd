extends "res://Enemies/GenericEnemy.gd"

var attacked = false

func _physics_process(delta):
	match state:
		PURSUE: 
			# SI EL PLAYER ESTÁ MUY CERCA, ATACA
			if(position.distance_to(player_pos) < 100): state = ATTACK
			
		ATTACK: 
			# LO MISMO QUE EL PURSUE PERO CON MAS VELOCIDAD Y CON UNA PEQUEÑA ESPERA AL CHOCAR CON EL PLAYER
			player_pos = get_parent().get_node("Player").position
			if($WaitTimer.time_left == 0): move_and_slide(global_position.direction_to(player_pos) * speed * 2)
			if(position.distance_to(player_pos) >= 100): state = PURSUE
			if(attacked == false): 
				if(position.distance_to(player_pos) <= 10): attacked = true
				for i in get_slide_count():
					var collision = get_slide_collision(i)
					if(collision.collider && collision.collider.name == "Player"): attacked = true
			if(attacked): 
				$WaitTimer.start(attack_cd)
				attacked = false


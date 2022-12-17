extends "res://Enemies/GenericEnemy.gd"

enum {ATTACK}

var is_colliding = false

func _physics_process(delta):
	match state:
		PURSUE: 
			# SI EL PLAYER ESTÁ MUY CERCA, ATACA
			if(position.distance_to(player_pos) < 100): state = ATTACK
			
		ATTACK: 
			# LO MISMO QUE EL PURSUE PERO CON MAS VELOCIDAD Y CON UNA PEQUEÑA ESPERA AL CHOCAR CON EL PLAYER
			player_pos = get_parent().get_node("Player").position
			if(($WaitTimer.time_left == 0) && (!is_colliding)): moveToPoint(player_pos,7)
			if((position.distance_to(player_pos) >= 100) && (!is_colliding)): state = PURSUE

func _on_CollisionArea_body_entered(body):
	if(state == ATTACK): $WaitTimer.start(attack_cd)
	if(body.name == "Player"): is_colliding = true

func _on_Hitbox_body_exited(body):
	if(body.name == "Player"): is_colliding = false

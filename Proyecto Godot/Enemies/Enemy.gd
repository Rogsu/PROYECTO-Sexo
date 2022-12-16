extends KinematicBody2D

enum {
	PURSUE,
	ATTACK,
	KNOCKED
}

const speed = 10
var state = PURSUE
var initial_pos = Vector2()
var patrol_moving = false
var patrol_restart = false
var randX = 0
var randY = 0
var new_pos = Vector2()
var player_pos = Vector2()
var hp = 5

var knock_dir = Vector2()
var knock_str = 0

func _ready():
	randomize()
	initial_pos = position
	player_pos = get_parent().get_node("Player").position

func _physics_process(delta):
	match state:
		PURSUE: 
			# PERSEGUIR AL PLAYER SI ESTÁ ADENTRO DEL AREA, SINO VUELVE A PATROL
			player_pos = get_parent().get_node("Player").position
			moveToPoint(player_pos,1)
			# SI EL PLAYER ESTÁ MUY CERCA, ATACA
			if(position.distance_to(player_pos) < 100): state = ATTACK
			
		ATTACK: 
			# LO MISMO QUE EL PURSUE PERO CON MAS VELOCIDAD Y CON UNA PEQUEÑA ESPERA AL CHOCAR CON EL PLAYER
			player_pos = get_parent().get_node("Player").position
			if($WaitTimer.time_left == 0): moveToPoint(player_pos,7)
			if(position.distance_to(player_pos) >= 100): state = PURSUE
		
		KNOCKED:
			# APLICAR KNOCKBACK Y DECREMENTARLO DE FORMA "REALISTA" 
			global_position += delta * knock_str * knock_dir
			knock_str = knock_str/1.1 
			if(knock_str < 10):
				if(hp <= 0): queue_free() 
				state = PURSUE


func moveToPoint(pos: Vector2, speed: int):
	position = position.move_toward(pos,speed)
	
	if(position == pos):
		$WaitTimer.start(1.5)

func _on_WaitTimer_timeout():
	patrol_moving = false


func _on_CollisionArea_body_entered(body):
	if(state == ATTACK): $WaitTimer.start(0.75)
	

func _on_CollisionArea_area_entered(area):
	state = KNOCKED
	knock_dir = area.position.direction_to(position)
	knock_str = 200
	$AnimationPlayer.play("Flash")
	
	hp -= 1
	$EnemyHealthBar.value -= 1
	

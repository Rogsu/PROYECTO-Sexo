extends KinematicBody2D

enum {
	PATROL,
	BACKTOORIGIN,
	PURSUE,
	ATTACK,
	STUNNED,
	KNOCKED
}

const speed = 10
var state = PATROL
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
		PATROL: 
			# SI NO HAY MOVIMIENTO Y NO SE ALEJO MUCHO DEL PUNTO INICIAL, GENERAR UN NUEVO PUNTO ALEATORIO AL CUAL MOVERSE
			if((position.distance_to(initial_pos) < 200) && !patrol_moving): 
				randX = randi()%50 * sign(rand_range(-1,1))
				randY = randi()%50 * sign(rand_range(-1,1))
				new_pos = Vector2(position.x + randX + 50*sign(randX) , position.y + randY + 50*sign(randY))
				patrol_moving = true
			
			# SI NO HAY MOVIMIENTO Y SE ALEJÓ MUCHO DEL PUNTO INICIAL, CAMBIAR A ESTADO DE REGRESO
			elif(position.distance_to(initial_pos) >= 200 && !patrol_moving): state = BACKTOORIGIN
			
			# SI HAY MOVIMIENTO Y NO ESTÁ EN ESPERA, MOVERSE AL PUNTO ALEATORIO
			if(patrol_moving && $WaitTimer.time_left == 0): moveToPoint(new_pos,1)
		
		BACKTOORIGIN:
			# VOLVER AL PUNTO INICIAL
			moveToPoint(initial_pos,1)
		
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
			print(knock_str)
			if(knock_str < 10):
				if(hp <= 0): queue_free() 
				state = PATROL


func moveToPoint(pos: Vector2, speed: int):
	position = position.move_toward(pos,speed)
	
	if(position == pos):
		if(state == BACKTOORIGIN): state = PATROL
		$WaitTimer.start(1.5)

func _on_Area2D_body_entered(body):
	if(body.name == "Player"): state = PURSUE


func _on_Area2D_body_exited(body):
	if(body.name == "Player"): state = PATROL
	$WaitTimer.start(1.5)


func _on_WaitTimer_timeout():
	patrol_moving = false


func _on_CollisionArea_body_entered(body):
	if(state == ATTACK): $WaitTimer.start(0.75)
	

func _on_CollisionArea_area_entered(area):
	state = KNOCKED
	knock_dir = area.position.direction_to(position)
	knock_str = 400
	
	hp -= 1
	$EnemyHealthBar.value -= 1
	

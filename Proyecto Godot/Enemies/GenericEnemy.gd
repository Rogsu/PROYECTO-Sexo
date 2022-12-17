extends KinematicBody2D

enum {
	PURSUE = -2,
	KNOCKED = -1
}

export var speed = 1
export var hp = 1
export var knockback_resistance: float = 1 
export var attack_cd: float = 1 # Funciona como velocidad de ataque, mientras mas se acerque a 0 el valor, mas rapido ataca

var state = PURSUE
var initial_pos = Vector2()
var patrol_moving = false
var patrol_restart = false
var randX = 0
var randY = 0
var new_pos = Vector2()
var player_pos = Vector2()

var knock_dir = Vector2()
var knock_str = 0

func _ready():
	randomize()
	initial_pos = position
	player_pos = get_parent().get_node("Player").position
	$EnemyHealthBar.max_value = hp
	$EnemyHealthBar.value = hp

func _physics_process(delta):
	match state:
		PURSUE: 
			# PERSEGUIR AL PLAYER SI ESTÁ ADENTRO DEL AREA, SINO VUELVE A PATROL
			player_pos = get_parent().get_node("Player").position
			moveToPoint(player_pos,speed)
	
		KNOCKED:
			# APLICAR KNOCKBACK Y DECREMENTARLO DE FORMA "REALISTA" 
			global_position += delta * knock_str * knock_dir
			knock_str = knock_str/1.1 
			if(knock_str < 5):
				if(hp <= 0): queue_free() 
				state = PURSUE


func moveToPoint(pos: Vector2, speed: int):
	position = position.move_toward(pos,speed)

func _on_WaitTimer_timeout():
	patrol_moving = false

func _on_CollisionArea_area_entered(area):
	state = KNOCKED
	knock_dir = area.position.direction_to(position)
	$AnimationPlayer.play("Flash")
	
	knock_str = area.knockback * knockback_resistance
	hp -= area.damage
	$EnemyHealthBar.value -= area.damage
	

extends KinematicBody2D

enum {
	PURSUE = -2,
	KNOCKED = -1
}

export var speed = 1
export var hp = 1
export var cant_scrap = 1
export var knockback_resistance: float = 1 
export var attack_cd: float = 1 # Funciona como velocidad de ataque, mientras mas se acerque a 0 el valor, mas rapido ataca

var state = PURSUE
var player_pos = Vector2()

var scrap = preload("res://Scrap.tscn")

var knock_dir = Vector2()
var knock_str = 0

func _ready():
	randomize()
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
				if(hp <= 0): 
					spawnScrap(cant_scrap)
					queue_free() 
				state = PURSUE


func moveToPoint(pos: Vector2, speed: int):
	position = position.move_toward(pos,speed)

func _on_Hitbox_area_entered(area):
	state = KNOCKED
	knock_dir = area.position.direction_to(position)
	$AnimationPlayer.play("Flash")
	
	knock_str = area.knockback * knockback_resistance
	hp -= area.damage
	$EnemyHealthBar.value -= area.damage

func spawnScrap(cant_scrap):
	while(cant_scrap >= 1):
		while(cant_scrap >= 10):
			while(cant_scrap >= 100):
				var scrap_instance = scrap.instance()
				scrap_instance.scrap_lvl = 3
				scrap_instance.global_position = randomNearPos()
				get_parent().add_child(scrap_instance)
				cant_scrap -= 100
			var scrap_instance = scrap.instance()
			scrap_instance.scrap_lvl = 2
			scrap_instance.global_position = randomNearPos()
			get_parent().add_child(scrap_instance)
			cant_scrap -= 10
		var scrap_instance = scrap.instance()
		scrap_instance.scrap_lvl = 1
		scrap_instance.global_position = randomNearPos()
		get_parent().add_child(scrap_instance)
		cant_scrap -= 1

func randomNearPos():
	var randX = global_position.x + rand_range(0,60)*sign(randi())
	var randY = global_position.y + rand_range(0,60)*sign(randi())
	return Vector2(randX,randY)

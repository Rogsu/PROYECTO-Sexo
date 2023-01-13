extends Node2D

onready var spawner = $Spawner/PathFollow2D
onready var slime = preload("res://Enemies/SlimeEnemy.tscn")
onready var tank = preload("res://Enemies/TankEnemy.tscn")
onready var global = get_node("/root/Global")

var player: KinematicBody2D
var wave = 1
var spawn_info = []
var total_spawns = 0
var game_time = 0

var spawn_min_pos_x = -1417
var spawn_min_pos_y = -1026
var spawn_max_pos_x = 1678
var spawn_max_pos_y = 840

func _ready():
	player = global.playerCharacter.instance()
	add_child(player)
	player.global_position = Vector2(0,0)

	setSpawns()
	randomize()

func _physics_process(delta):
	spawner.offset = randi()
	game_time += 1 * delta
	
	setSpawns()

func _on_Timer_timeout():
	var random_pos
	var enemy
	
	# Seleccionar un enemigo de spawn_info dependiendo de sus chances de spawnear
	var rand_num = rand_range(0,1)
	var running_total = 0
	var selected = false
	var k = 0 # k sirve para recorrer spawn_info
	while(!selected):
		running_total = running_total + spawn_info[k][3]
		if rand_num <= running_total:
			enemy = spawn_info[k][0].instance()
			selected = true
			k -= 1
		k += 1
	
	# Verificar que el enemigo se encuentre fuera de la camara
	while(!(int(spawner.global_position.x) in range(spawn_min_pos_x,spawn_max_pos_x)) || !(int(spawner.global_position.y) in range(spawn_min_pos_y,spawn_max_pos_y))):
		spawner.offset = randi()
	
	enemy.global_position = spawner.global_position
	add_child(enemy)

	# Spawnear varios enemigos
	for i in range(0, spawn_info[k][1]):
		var another_enemy = enemy.duplicate()

		# En posiciones aleatorias
		if(spawn_info[k][2]):
			spawner.offset = randi()
			while(!(int(spawner.global_position.x) in range(spawn_min_pos_x,spawn_max_pos_x)) || !(int(spawner.global_position.y) in range(spawn_min_pos_y,spawn_max_pos_y))):
				spawner.offset = randi()
			another_enemy.global_position = spawner.global_position

		# En el mismo lugar
		else:
			another_enemy.global_position = randomNearPos(enemy.global_position)

		add_child(another_enemy)

func setSpawns():
	
	# [ENEMIGOS, CANTIDAD DE SPAWN, MODO (0 = mismo lugar, 1 = aleatorio), CHANCES DE SPAWN
	match int(game_time):
		0:
			spawn_info = [[slime, 5, 1, 0.7],[tank, 3, 0, 0.3]]
			$Timer.wait_time = 2
			
		10:
			spawn_info = [[slime, 1, 1, 0.5],[tank, 1, 1, 0.5]]
			$Timer.wait_time = 1
			
		20:
			spawn_info = [[slime, 3, 1, 1]]
			$Timer.wait_time = 5
			
		30:
			spawn_info = [[tank, 2, 1, 1]]
			$Timer.wait_time = 0.5
			
		40:
			spawn_info = [[slime, 5, 1, 1]]
			$Timer.wait_time = 3

func isSpawnerEmpty():
	var empty = true
	for i in spawn_info:
		if(i[1] != 0): empty = false
	return empty

func randomNearPos(pos):
	var randX = pos.x + rand_range(50,100)*sign(randi())
	var randY = pos.y + rand_range(50,100)*sign(randi())
	return Vector2(randX,randY)


func _on_UI_next_wave():
	wave += 1
	setSpawns()

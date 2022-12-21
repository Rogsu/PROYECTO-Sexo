extends Node2D

onready var spawner = $Spawner/PathFollow2D
onready var player = $Player
onready var slime = preload("res://Enemies/SlimeEnemy.tscn")
onready var tank = preload("res://Enemies/TankEnemy.tscn")

var wave = 1
var spawn_info = []
var total_spawns = 0


func _ready():
	randomize()
	setWaveSpawns()
	getTotalSpawns()

func _physics_process(delta):
	spawner.offset = randi()

func _on_Timer_timeout():
	if(isSpawnerEmpty() == false):
		var random_pos
		var enemy
		var cant = 0

		# Tomar de spawn_info un enemigo que aun tenga que ser spawneado
		while(cant == 0): 
			random_pos = randi() % spawn_info.size()
			enemy = spawn_info[random_pos][0].instance()
			cant = spawn_info[random_pos][1]

		spawn_info[random_pos][1] -= spawn_info[random_pos][2] # Restarle a la cant total la cant de spawns
		enemy.global_position = spawner.global_position
		add_child(enemy)

		# Spawnear varios enemigos a la vez
		for i in range(0, spawn_info[random_pos][2] - 1): 
			var another_enemy = enemy.duplicate()
			add_child(another_enemy)
			another_enemy.global_position = randomNearPos(enemy.global_position)
			

func setWaveSpawns():
	
	# [ENEMIGOS, CANTIDAD TOTAL, CANTIDAD DE SPAWN]
	
	match wave:
		1:
			spawn_info = [[slime, 5, 1]]
			$Timer.wait_time = 1
		2:
			spawn_info = [[slime, 10, 1],[tank, 2, 1]]
			$Timer.wait_time = 0.75
		3:
			spawn_info = [[slime, 15, 3]]
			$Timer.wait_time = 10
		4:
			spawn_info = [[tank, 10, 2]]
			$Timer.wait_time = 0.5
		5:
			spawn_info = [[slime, 20, 5]]
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

func getTotalSpawns():
	total_spawns = 0
	for i in spawn_info.size():
		total_spawns += spawn_info[i][1]
	$UI.total_spawns = total_spawns


func _on_UI_next_wave():
	wave += 1
	setWaveSpawns()
	getTotalSpawns()

extends Node2D

onready var spawner = $Spawner/PathFollow2D
onready var player = $Player
onready var slime = preload("res://Enemies/SlimeEnemy.tscn")

func _physics_process(delta):
	spawner.offset = randi()
	$TileMap.get_used_rect() 

func _on_Timer_timeout():
	var enemy = slime.instance()
	enemy.global_position = spawner.global_position
	add_child(enemy)

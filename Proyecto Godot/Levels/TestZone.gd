extends Node2D

onready var camera = $Camera2D
onready var spawner = $Camera2D/Path2D/PathFollow2D
onready var player = $Player
onready var slime = preload("res://Enemies/SlimeEnemy.tscn")

func _physics_process(delta):
	camera.global_position = player.global_position
	spawner.offset = randi()


func _on_Timer_timeout():
	var enemy = slime.instance()
	enemy.global_position = spawner.global_position
	add_child(enemy)

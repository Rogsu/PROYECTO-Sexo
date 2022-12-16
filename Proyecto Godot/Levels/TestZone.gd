extends Node2D

onready var camera = $Camera2D
onready var spawner = $Camera2D/Path2D/PathFollow2D
onready var player = $Player
onready var slime = preload("res://Enemies/Enemy.tscn")

func _physics_process(delta):
	camera.global_position = player.global_position
	spawner.offset = randi()



func _on_Timer_timeout():
	var enemy = slime.instance()
	add_child(enemy)
	enemy.global_position = spawner.global_position
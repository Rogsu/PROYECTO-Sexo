extends Node

onready var player = get_parent()

func passive1(level):
	match level:
		1:
			player.statsData.addKnockback = 100
		2:
			player.statsData.addKnockback = 200
		3:
			player.statsData.addKnockback = 300

func passive2(level):
	match level:
		1:
			player.statsData.addDamage = 100
		2:
			player.statsData.addDamage = 200
		3:
			player.statsData.addDamage = 300

func passive3(level):
	match level:
		1:
			player.SPEED += 100
		2:
			player.SPEED += 200
		3:
			player.SPEED += 300

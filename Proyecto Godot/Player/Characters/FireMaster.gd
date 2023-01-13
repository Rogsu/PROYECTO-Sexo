extends "res://Player/KinematicBody2D.gd"

func _physics_process(delta):
	# Esto debe modificarse cuando se tenga una barra de vida
	if(hp >= 999): passive2(p2lvl)
	else: statsData.addAttackSpeed = 1

func passive1(level):
	match level:
		1:
			statsData.addBurnChance += 0.1
		2:
			statsData.addBurnChance += 0.1
		3: 
			statsData.addBurnChance += 0.15

func passive2(level):
	match level:
		1:
			statsData.addAttackSpeed += 0.1
		2:
			statsData.addAttackSpeed += 0.1
		3: 
			statsData.addAttackSpeed += 0.1

func passive3(level):
	match level:
		1:
			statsData.revives += 1
		2:
			pass
		3: 
			statsData.revives += 1

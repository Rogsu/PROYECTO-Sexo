extends "res://Player/KinematicBody2D.gd"

# var originalMaxHp = max_hp

func passive1(level):
	match level:
		1:
			statsData.addStun = [0.05,2]
		2:
			statsData.addStun = [0.1,3]
		3: 
			statsData.addStun = [0.2,4]

# Falta la vida maxima
func passive2(level):
	match level:
		1:
			# max_hp -= originalMaxHp / 100 * 5
			statsData.critChance += 10.15
		2:
			# max_hp -= originalMaxHp / 100 * 5
			statsData.critChance += 0.15
		3: 
			# max_hp -= originalMaxHp / 100 * 10
			statsData.critChance += 0.2

func passive3(level):
	match level:
		1:
			statsData.addHurtDamage += 0.05
			statsData.addSpeed += 0.1
		2:
			statsData.addHurtDamage += 0.05
			statsData.addSpeed += 0.1
		3: 
			statsData.addHurtDamage += 0.05
			statsData.addSpeed += 0.15

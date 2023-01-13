extends "res://Player/KinematicBody2D.gd"

func passive1(level):
	match level:
		1:
			statsData.addSlow = [0.9,10]
		2:
			statsData.addSlow = [0.8,10]
		3: 
			statsData.addSlow = [0.7,10]

func passive2(level):
	match level:
		1:
			pass
		2:
			pass
		3: 
			pass

func passive3(level):
	match level:
		1:
			statsData.addAttackSpeed += -0.05
			statsData.addDamage += 0.1
		2:
			statsData.addAttackSpeed += -0.1
			statsData.addDamage += 0.2
		3: 
			statsData.addAttackSpeed += -0.15
			statsData.addDamage += 0.35

extends "res://Player/KinematicBody2D.gd"

func passive1(level):
	# Esto debe aplicarse cuando el player tenga hp
	match level:
		1:
			statsData.addSpeed += -0.05
			statsData.damageReduction += 0.1
		2:
			statsData.addSpeed += -0.05
			statsData.damageReduction += 0.1
		3: 
			statsData.addSpeed += -0.05
			statsData.damageReduction += 0.2

func passive2(level):
	match level:
		1:
			statsData.addSpeed += -0.05
			statsData.thorns += 0.2
		2:
			statsData.addSpeed += -0.05
			statsData.thorns += 0.2
		3: 
			statsData.addSpeed += -0.05
			statsData.thorns += 0.2

func passive3(level):
	match level:
		1:
			#max_hp += 25
			pass
		2:
			#max_hp += 25
			pass
		3: 
			#max_hp += 50
			pass


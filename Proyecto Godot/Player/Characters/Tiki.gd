extends "res://Player/KinematicBody2D.gd"

func passive1(level):
	match level:
		1:
			statsData.addEssence += 0.1
		2:
			statsData.addEssence += 0.1
		3: 
			statsData.addEssence += 0.2

func passive2(level):
	match level:
		1:
			statsData.addMagicDamage += 0.05
		2:
			statsData.addMagicDamage += 0.05
		3: 
			statsData.addMagicDamage += 0.1

func passive3(level):
	match level:
		1:
			pass
		2:
			pass
		3: 
			pass

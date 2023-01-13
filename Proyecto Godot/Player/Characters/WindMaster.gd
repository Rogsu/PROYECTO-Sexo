extends "res://Player/KinematicBody2D.gd"

func passive1(level):
	match level:
		1:
			statsData.addSpeed += 0.1
		2:
			statsData.addSpeed += 0.1
		3: 
			statsData.addSpeed += 0.3

func passive2(level):
	match level:
		1:
			statsData.addRadius += 0.3
		2:
			statsData.addRadius += 0.2
		3: 
			statsData.addRadius += 0.3

func passive3(level):
	match level:
		1:
			statsData.addBulletSpeed += 0.1
			statsData.addDamage += 0.05
		2:
			statsData.addBulletSpeed += 0.1
			statsData.addDamage += 0.05
		3: 
			statsData.addBulletSpeed += 0.15
			statsData.addDamage += 0.05

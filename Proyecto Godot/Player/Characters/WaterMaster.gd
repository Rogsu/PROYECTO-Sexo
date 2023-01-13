extends "res://Player/KinematicBody2D.gd"

onready var passiveTimer = $PassiveTimer
onready var cooldownTimer = $CooldownTimer
var passiveDuration = 0
var passiveWaitTime = 0

func _ready():
	passiveTimer.connect("timeout",self,"stopInvulnerability")

func _physics_process(delta):
	# El 999 debe ser reemplazado por la vida maxima del jugador
	if(hp < 999 && hp > 0): hp += (999 / 100 * (statsData.addHpRegen + hpRegen)) * delta
	if((hp < 999 / 100) && (cooldownTimer.wait_time == 0)):
		passiveTimer.wait_time = passiveDuration
		passiveTimer.start()
		cooldownTimer.wait_time = passiveWaitTime
		cooldownTimer.start()
		print(cooldownTimer.wait_time)
		$CollisionShape2D.disabled = true
		$CollectArea/CollisionShape2D.disabled = true

func stopInvulnerability():
	$CollisionShape2D.disabled = false
	$CollectArea/CollisionShape2D.disabled = false

func passive1(level):
	match level:
		1:
			statsData.addHpRegen += 5
		2:
			statsData.addHpRegen += 5
		3: 
			statsData.addHpRegen += 7.5

func passive2(level):
	match level:
		1:
			statsData.explosion = [10.2,0.2]
		2:
			statsData.explosion = [0.3,0.3]
		3: 
			statsData.explosion = [0.5,0.5]

func passive3(level):
	match level:
		1:
			passiveDuration = 1.5
			passiveWaitTime = 180
		2:
			passiveDuration = 3
			passiveWaitTime = 160
		3: 
			passiveDuration = 5
			passiveWaitTime = 120

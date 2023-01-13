extends KinematicBody2D

enum {
	PURSUE,
	KNOCKED,
	ATTACK
}

export var speed = 1
export var hp = 1
export var cant_scrap = 1
export var knockback_resistance: float = 1 
export var attack_cd: float = 1 # Funciona como velocidad de ataque, mientras mas se acerque a 0 el valor, mas rapido ataca
export var damage = 0

onready var player = get_parent().get_node("Player")
onready var ui = get_parent().get_node("UI")

var state = PURSUE
var player_pos = Vector2()
var is_colliding = false
var linear_velocity = Vector2()
var original_speed: float
var burning = false

var essence = preload("res://Items/Essence.tscn")

var knock_dir = Vector2()
var knock_str = 0

var burnTimer = Timer.new()
var slowTimer = Timer.new()
var stunTimer = Timer.new()

func _ready():
	randomize()
	player_pos = player.position
	$EnemyHealthBar.max_value = hp
	$EnemyHealthBar.value = hp
	original_speed = speed
	
	setTimers()

func _physics_process(delta):
	if(burning): 
		hp -= (($EnemyHealthBar.max_value / 100 * 20)/4) * delta
		$EnemyHealthBar.value = round(hp)
		if(hp<0): 
			queue_free()
			spawnScrap(cant_scrap)

	
	match state:
		PURSUE: 
			# PERSEGUIR AL PLAYER SI ESTÁ ADENTRO DEL AREA, SINO VUELVE A PATROL
			player_pos = player.position
			linear_velocity = global_position.direction_to(player_pos) * speed
			move_and_slide(linear_velocity)
	
		KNOCKED:
			# APLICAR KNOCKBACK Y DECREMENTARLO DE FORMA "REALISTA" 
			linear_velocity = knock_str * knock_dir
			knock_str = knock_str/1.1 
			if(knock_str < 5):
				if(hp <= 0): 
					spawnScrap(cant_scrap)
					queue_free() 
				state = PURSUE
			move_and_slide(linear_velocity)

func spawnScrap(cant_essence):
	while(cant_essence >= 1):
		while(cant_essence >= 10):
			while(cant_essence >= 100):
				var essence_instance = essence.instance()
				essence_instance.essence_lvl = 3
				essence_instance.global_position = randomNearPos()
				get_parent().add_child(essence_instance)
				cant_essence -= 100
			var essence_instance = essence.instance()
			essence_instance.essence_lvl = 2
			essence_instance.global_position = randomNearPos()
			get_parent().add_child(essence_instance)
			cant_essence -= 10
		var essence_instance = essence.instance()
		essence_instance.essence_lvl = 1
		essence_instance.global_position = randomNearPos()
		get_parent().add_child(essence_instance)
		cant_essence -= 1

func randomNearPos():
	var randX = global_position.x + rand_range(0,60)*sign(randi())
	var randY = global_position.y + rand_range(0,60)*sign(randi())
	return Vector2(randX,randY)

func generateTimer(wait_time,func_name):
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.wait_time = wait_time
	timer.connect("timeout", self, func_name)
	timer.start()
	return timer

func _on_Hitbox_area_entered(area):
	if(hp>0):
		state = KNOCKED
		knock_dir = area.global_position.direction_to(global_position)
		$AnimationPlayer.play("Flash")
		
		knock_str = area.knockback * knockback_resistance
		
		# Slow
		if(area.slow[0] < 1):
			speed *= area.slow[0]
			slowTimer.wait_time = area.slow[1]
			slowTimer.start()
		
		# Stun
		if(area.stun[0] > 0):
			var rand = rand_range(0,1)
			if(area.stun[0] > rand):
				speed = 0
				stunTimer.wait_time = area.stun[1]
				stunTimer.start()
		
		# Burn
		if(area.burnChance > 0):
			var rand = rand_range(0,1)
			if(area.burnChance > rand):
				modulate = Color.orange
				burning = true
				burnTimer.wait_time = 4
				burnTimer.start()
		
		# Explosion
		if(area.explosion[0] > 0):
			var rand = rand_range(0,1)
			if(area.explosion[0] > rand):
				var explosion = load("res://Explosion.tscn").instance()
				add_child(explosion)
				explosion.damage = area.damage / 100 * area.explosion[1]
		
		# Critical
		if(area.critChance > 0):
			var rand = rand_range(0,1)
			if(area.critChance > rand): area.damage *= 2
		
		$EnemyHealthBar.value -= area.damage
		hp -= area.damage
		
	else: queue_free()

func resetSpeed():
	speed = original_speed

func stopBurn():
	burning = false
	modulate = Color.white

func setTimers():
	burnTimer.one_shot = true
	slowTimer.one_shot = true
	stunTimer.one_shot = true
	add_child(burnTimer)
	add_child(slowTimer)
	add_child(stunTimer)
	burnTimer.connect("timeout", self, "stopBurn")
	slowTimer.connect("timeout", self, "resetSpeed")
	stunTimer.connect("timeout", self, "resetSpeed")

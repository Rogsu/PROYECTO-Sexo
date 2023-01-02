extends KinematicBody2D

enum {FREE, KNOCKBACK, DEATH, DASH}

export var SPEED = 400.0

var linear_velocity = Vector2()
var state = FREE
var fireball = load("res://Player/Weapons/Fireball.tscn")
var scrap = 0
var can_shoot = true
var is_dead = false
var alpha = 0
var fadeInTimer

onready var gameOverMsg = get_node("/root/TestZone/Camera2D/GameOver")
onready var death_sound = preload("res://Sounds/OminousChatter.ogg")
onready var camera = get_parent().get_node("Camera2D")

var weapon = 0 
#ID DEL ARMA DEL JUGADOR:
#0: Sin arma
#1: Fireball (solo debug)
#2: Antorcha de Acetileno (primer arma melee)
#3: Nail Gun 
#4: ...
var last_weapon_picked_up = 0
var amount_of_weapons = 0
var directionAngle = 1

func _physics_process(delta):
	match state:
		FREE:
			var direction = Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down"))
			if direction:
				linear_velocity = direction.normalized() * SPEED
			else:
				linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED/8)
				linear_velocity.y = move_toward(linear_velocity.y, 0, SPEED/8)
			
			move_and_slide(linear_velocity)
			# Animacion
			if(Input.is_action_just_pressed("ui_down")):
				$AnimatedSprite.play("down")
			if(Input.is_action_just_pressed("ui_up")):
				$AnimatedSprite.play("up")
			if(Input.is_action_just_pressed("ui_left")):
				$AnimatedSprite.play("left")
			if(Input.is_action_just_pressed("ui_right")):
				$AnimatedSprite.play("right")

			#Esto es para que el jugador siempre mire hacia donde apunte el mouse: tiene prioridad por sobre la tecla apretada
			if(get_global_mouse_position().x < position.x):
				directionAngle = 3
				match weapon:
					2:
						$AntorchaAcetileno.position.x = -20
						$AntorchaAcetileno.scale.x = -1
					3:
						$NailGun.position.x = -18
						$NailGun.scale.x = -1
					4:
						$Revolver.position.x = -20
						$Revolver.scale.x = -1
			elif(get_global_mouse_position().x > position.x):
				directionAngle = 4
				match weapon:
					2:
						$AntorchaAcetileno.position.x = 20
						$AntorchaAcetileno.scale.x = 1
					3:
						$NailGun.position.x = 18
						$NailGun.scale.x = 1
					4:
						$Revolver.position.x = 20
						$Revolver.scale.x = 1

			if(amount_of_weapons > 2):
				dropWeapon()
			elif(last_weapon_picked_up != weapon):
				match last_weapon_picked_up:
					2:
						$AntorchaAcetileno.visible = false
						if($AntorchaAcetileno.get_node("TorchSound").is_playing() && $AntorchaAcetileno.isActive):
							$AntorchaAcetileno.get_node("TorchSound").set_stream(load("res://Sounds/TorchStop.ogg"))
							$AntorchaAcetileno.get_node("TorchSound").play()
						$AntorchaAcetileno.isActive = 0
					3:
						$NailGun.visible = false
					4:
						$Revolver.visible = false

			if(Input.is_action_just_pressed("swapWeapon")):
				var aux = weapon
				weapon = last_weapon_picked_up
				last_weapon_picked_up = aux
				match weapon:
					2:
						$AntorchaAcetileno.visible = true
					3:
						$NailGun.visible = true
					4:
						$Revolver.visible = true
			
			# Disparo
			if(Input.is_mouse_button_pressed(1)):
				match weapon:
					1:
						if(can_shoot):
							can_shoot = false
							generateTimer(0.3,"shootAgain")
							var spell = fireball.instance()
							spell.direction = position.direction_to(get_global_mouse_position())
							spell.position = position
							get_parent().add_child(spell)
					2:
						if(!$AntorchaAcetileno.isActive):
							$AntorchaAcetileno.get_node("TorchSound").set_stream(load("res://Sounds/TorchStart.ogg"))
							$AntorchaAcetileno.get_node("TorchSound").play()
						$AntorchaAcetileno.isActive = true
					3:
						if(!$NailGun.isShooting): camera.shake_strength = 5
						$NailGun.shoot()
					4:
						if(!$Revolver.isShooting): camera.shake_strength = 10
						$Revolver.shoot()
			if(!Input.is_mouse_button_pressed(1)):
				match weapon:
					2:
						if($AntorchaAcetileno.isActive):
							$AntorchaAcetileno.get_node("TorchSound").set_stream(load("res://Sounds/TorchStop.ogg"))
							$AntorchaAcetileno.get_node("TorchSound").play()
							$AntorchaAcetileno.isActive = 0
		DEATH:
			if(!is_dead):
				$Sprite.texture = load("res://Sprites/TumbaPiedra.png")
				$Sprite.scale = Vector2(2, 2)
				$Balls.visible = false
				match weapon:
					2:
						$AntorchaAcetileno.visible = false
					3:
						$NailGun.visible = false
					4:
						$Revolver.visible = false
				gameOverMsg.visible = true
				gameOverMsg.self_modulate = Color(0.73, 0, 0, alpha)
				playSound(death_sound)
				generateTimer(0.1, "fadeInGameOverMsg")
				is_dead = true

func playSound(sound):
	sound.instance()
	add_child(sound)
	sound.play()

func generateTimer(wait_time,func_name):
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.wait_time = wait_time
	timer.connect("timeout", self, func_name)
	timer.start()
	return timer

func shootAgain():
	can_shoot = true

func _on_CollectArea_area_entered(area):
	area.attracted = !area.attracted

func _on_CollectArea_area_exited(area):
	area.attracted = !area.attracted

func fadeInGameOverMsg():
	alpha += 0.05
	gameOverMsg.self_modulate = Color(1, 0, 0, alpha)
	if(alpha >= 1):
		fadeInTimer.queue_free()
		
func dropWeapon():
	match weapon:
		2:
			$AntorchaAcetileno.isPickedUp = false
		3:
			$NailGun.isPickedUp = false
		4:
			$Revolver.isPickedUp = false
	amount_of_weapons -= 1

extends KinematicBody2D

enum {FREE, KNOCKBACK, DEATH, DASH}

export var SPEED = 400.0

var linear_velocity = Vector2()
var state = FREE
var fireball = load("res://Player/Weapons/Fireball.tscn")
var scrap = 0
var ammo = 7
var can_shoot = true
var is_ult_on_cooldown = false
var is_reloading = false
var ultTimer

onready var ultCooldown = get_node("/root/TestZone/Anchor/Camera2D/UltCooldown")

func _physics_process(delta):
	match state:
		FREE:
			var direction = Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down"))
			if direction:
				linear_velocity = direction.normalized() * SPEED
			else:
				linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED/8)
				linear_velocity.y = move_toward(linear_velocity.y, 0, SPEED/8)
			move_and_slide(linear_velocity);
			
			if(Input.is_action_just_pressed("ui_down")):
				$AnimatedSprite.play("down")
			if(Input.is_action_just_pressed("ui_up")):
				$AnimatedSprite.play("up")
			if(Input.is_action_just_pressed("ui_left")):
				$AnimatedSprite.play("left")
			if(Input.is_action_just_pressed("ui_right")):
				$AnimatedSprite.play("right")
			
			showAmmo(ammo)
			
			# Disparo
			if(Input.is_mouse_button_pressed(1)):
				if(can_shoot && ammo > 0):
					can_shoot = false
					generateTimer(0.3,"shootAgain")
					var spell = fireball.instance()
					spell.direction = position.direction_to(get_global_mouse_position())
					spell.position = position
					get_parent().add_child(spell)
					ammo-=1
			
			# Ulti
			if(Input.is_mouse_button_pressed(BUTTON_RIGHT)):
				if(!is_ult_on_cooldown):
					for i in range(0, 10):
						var spell = fireball.instance()
						spell.direction = Vector2(cos(i * ((PI*2) / 10)), sin(i * ((PI*2) / 10)))
						spell.position = position
						get_parent().add_child(spell)
					is_ult_on_cooldown = true;
					ultTimer = generateTimer(5,"ultAgain")

			# Recarga
			if(( ammo == 0 || Input.is_action_just_pressed("reloadKey") ) && !is_reloading):
				ammo = 0
				generateTimer(2,"reload")
				$Reloading.visible = 1
				is_reloading = true

	# Mostrar cooldown de la ulti
	if(is_ult_on_cooldown):
		ultCooldown.set_text(str(int(ultTimer.get_time_left())+1))

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

func reload():
	ammo = 7
	$Reloading.visible = 0
	is_reloading = false

func ultAgain():
	is_ult_on_cooldown = false
	ultCooldown.set_text("")

func showAmmo(ammo):
	match ammo:
		0:
			$Balls.set_text("")
		1:
			$Balls.set_text("ð")
		2:
			$Balls.set_text("ðð")
		3:
			$Balls.set_text("ððð")
		4:
			$Balls.set_text("ðððð")
		5:
			$Balls.set_text("ððððð")
		6:
			$Balls.set_text("ðððððð")
		7:
			$Balls.set_text("ððððððð")

func _on_CollectArea_area_entered(area):
	area.attracted = !area.attracted

func _on_CollectArea_area_exited(area):
	area.attracted = !area.attracted

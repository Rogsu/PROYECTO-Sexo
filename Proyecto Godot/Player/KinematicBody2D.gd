extends KinematicBody2D

enum {FREE, KNOCKBACK, DEATH, DASH}

const SPEED = 300.0
var linear_velocity = Vector2()
var state = FREE
var fireball = load("res://Player/Weapons/Fireball.tscn")
var scrap = 0

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
			
			if(Input.is_mouse_button_pressed(1)):
				var spell = fireball.instance()
				spell.direction = position.direction_to(get_global_mouse_position())
				spell.position = position
				get_parent().add_child(spell)
				



func _on_CollectArea_area_entered(area):
	area.attracted = !area.attracted


func _on_CollectArea_area_exited(area):
	area.attracted = !area.attracted

extends "res://Items/GenericWeapon.gd"

var isPickedUp = false
var isShooting = false

var nail = load("res://Items/Ammo/Nail.tscn")

func _physics_process(delta):
	if(isPickedUp):
		get_node("Msg").visible = false
	else:
		if(get_parent().name == "Player"):
			get_parent().remove_child(self)
			player.get_parent().add_child(self)
			get_node("Msg").visible = true
			if(scale.x == -1): scale.x = 1
			position = player.position
		if(Input.is_action_just_pressed("grabWeapon") && player.position.distance_to(position) < 50):
			isPickedUp = true
			position.x = 18
			position.y = 10
			get_parent().remove_child(self)
			player.add_child(self)
			player.amount_of_weapons += 1
			if(player.amount_of_weapons > 2):
				player.dropWeapon()
			else:
				player.last_weapon_picked_up = player.weapon
			player.weapon = 3
			

func shoot(statsData):
	if(!isShooting):
		isShooting = true
		var timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.wait_time = 0.1/statsData.addAttackSpeed
		timer.connect("timeout", self, "shootAgain")
		timer.start()
		var bullet = nail.instance()
		bullet.direction = player.position.direction_to(get_global_mouse_position())
		bullet.position = position
		bullet.damage = damage + (damage * statsData.addDamage)
		bullet.knockback = knockback + (knockback * statsData.addKnockback)
		bullet.slow = statsData.addSlow
		bullet.stun = [stun[0] + statsData.addStun[0], stun[1] + statsData.addStun[1]]
		bullet.burnChance = burnChance + statsData.addBurnChance
		bullet.explosion = statsData.explosion
		bullet.critChance = statsData.critChance
		get_parent().add_child(bullet)
		get_node("NailSound").play()

func shootAgain():
	isShooting = false

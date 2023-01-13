extends "res://Items/GenericWeapon.gd"

var isPickedUp = false
var isShooting = false

var bullet = load("res://Items/Ammo/Bullet.tscn")

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
			position.y = 5
			get_parent().remove_child(self)
			player.add_child(self)
			if(player.amount_of_weapons > 2):
				player.dropWeapon()
			else:
				player.last_weapon_picked_up = player.weapon
			player.weapon = 4

func shoot(statsData):
	if(!isShooting):
		isShooting = true
		var timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.wait_time = 1/statsData.addAttackSpeed
		timer.connect("timeout", self, "shootAgain")
		timer.start()
		var bulletInstance = bullet.instance()
		bulletInstance.direction = player.position.direction_to(get_global_mouse_position())
		bulletInstance.position = position
		bulletInstance.damage = damage + (damage * statsData.addDamage)
		bulletInstance.knockback = knockback + (knockback * statsData.addKnockback)
		bulletInstance.slow = statsData.addSlow
		bulletInstance.stun = [stun[0] + statsData.addStun[0], stun[1] + statsData.addStun[1]]
		bulletInstance.burnChance = burnChance + statsData.addBurnChance
		bulletInstance.explosion = statsData.explosion
		bulletInstance.critChance = statsData.critChance
		get_parent().add_child(bulletInstance)

func shootAgain():
	isShooting = false

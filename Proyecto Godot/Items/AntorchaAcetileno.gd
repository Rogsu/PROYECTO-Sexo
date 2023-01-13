extends Area2D

var damage = 0
var knockback = 1000
var slow = [1,0] # [Potencia de slow (1 a 0), Duracion de slow]
var stun = 0 # Duracion de stun
var isActive = 0
var isPickedUp = false

var player: KinematicBody2D

onready var sound = get_node("TorchSound")

func _ready():
	yield(get_parent(),"ready")
	player = get_node("/root/TestZone/Player")

func _physics_process(delta):
	if(isPickedUp):
		get_node("Msg").visible = false
		if(isActive):
			damage = 1
			get_node("Torch/FireContainer").visible = true
			if(!sound.is_playing()):
				sound.set_stream(load("res://Sounds/TorchIdle.ogg"))
				sound.play()
		else:
			damage = 0
			get_node("Torch/FireContainer").visible = false
	else:
		if(get_parent().name == "Player"):
			get_parent().remove_child(self)
			player.get_parent().add_child(self)
			get_node("Msg").visible = true
			if(scale.x == -1): scale.x = 1
			position = player.position
		if(Input.is_action_just_pressed("grabWeapon") && player.position.distance_to(position) < 50):
			isPickedUp = true
			position.x = 20
			position.y = 0
			get_parent().remove_child(self)
			player.add_child(self)
			player.amount_of_weapons += 1
			if(player.amount_of_weapons > 2):
				player.dropWeapon()
			else:
				player.last_weapon_picked_up = player.weapon
			player.weapon = 2
		

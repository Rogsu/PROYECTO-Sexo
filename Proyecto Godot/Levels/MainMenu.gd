extends Control

# Esto es una variable medio global, guardada en el script Global.gd
onready var global = get_node("/root/Global")

func _on_PlayButton_button_up():
	$MenuContainer.visible = !$MenuContainer.visible
	$CharacterContainer.visible = !$CharacterContainer.visible

func _on_QuitButton_button_up():
	get_tree().quit()

func _on_ReturnButton_button_up():
	$MenuContainer.visible = !$MenuContainer.visible
	$CharacterContainer.visible = !$CharacterContainer.visible


func _on_TikiButton_button_up():
	global.playerCharacter = load("res://Player/Characters/Tiki.tscn")
	get_tree().change_scene_to(load("res://Levels/TestZone.tscn"))


func _on_WindButton_button_up():
	global.playerCharacter = load("res://Player/Characters/WindMaster.tscn")
	get_tree().change_scene_to(load("res://Levels/TestZone.tscn"))


func _on_FireButton_button_up():
	global.playerCharacter = load("res://Player/Characters/FireMaster.tscn")
	get_tree().change_scene_to(load("res://Levels/TestZone.tscn"))


func _on_WaterButton_button_up():
	global.playerCharacter = load("res://Player/Characters/WaterMaster.tscn")
	get_tree().change_scene_to(load("res://Levels/TestZone.tscn"))


func _on_IceButton_button_up():
	global.playerCharacter = load("res://Player/Characters/IceMaster.tscn")
	get_tree().change_scene_to(load("res://Levels/TestZone.tscn"))


func _on_EarthButton_button_up():
	global.playerCharacter = load("res://Player/Characters/EarthMaster.tscn")
	get_tree().change_scene_to(load("res://Levels/TestZone.tscn"))


func _on_ElectricButton_button_up():
	global.playerCharacter = load("res://Player/Characters/ElectricMaster.tscn")
	get_tree().change_scene_to(load("res://Levels/TestZone.tscn"))

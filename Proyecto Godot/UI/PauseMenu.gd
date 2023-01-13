extends Node

var player: KinematicBody2D

func _ready():
	yield(get_parent(),"ready")
	player = get_parent().get_node("Player") 
	
func _input(event):
	if(Input.is_action_just_pressed("ui_accept")): 
		get_tree().paused = !get_tree().paused
		$PauseContainer.visible = !$PauseContainer.visible
		$Overlay.visible = !$Overlay.visible

func _on_ContinueButton_button_up():
	$PauseContainer.visible = !$PauseContainer.visible
	$Overlay.visible = !$Overlay.visible
	get_tree().paused = !get_tree().paused

func _on_CharButton_button_up():
	$CharacterContainer.visible = !$CharacterContainer.visible
	$PauseContainer.visible = !$PauseContainer.visible

func _on_QuitButton_button_up():
	get_tree().quit()

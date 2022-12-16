extends Node

func _input(event):
	if(Input.is_action_just_pressed("ui_accept")): 
		get_tree().paused = !get_tree().paused
		$CenterContainer.visible = !$CenterContainer.visible
		$Overlay.visible = !$Overlay.visible

func _on_ContinueButton_button_up():
	$CenterContainer.visible = !$CenterContainer.visible
	$Overlay.visible = !$Overlay.visible
	get_tree().paused = !get_tree().paused


func _on_QuitButton_button_up():
	get_tree().quit()

extends Button



func _on_button_up():
	get_tree().paused = false
	print(get_tree().current_scene)
	get_tree().reload_current_scene()
	


extends Button

@export_file var next_scene_path: String = ""
# switch to gamescene when start is pressed
func _on_button_up():
	if next_scene_path == "":
		print_debug("next_scene_path is not set")
		return
	get_tree().change_scene_to_file(next_scene_path)


	
	

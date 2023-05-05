extends Panel

func load_panel(weapon: base_range_weapon):
	$Sprite2D.texture = weapon.texture
	print_debug("loaded")
	print(weapon.name)


func _on_weapon_button_pressed():
	print_debug("test")

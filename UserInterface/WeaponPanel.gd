extends Panel

signal weapon_pressed

@export var index: int
var filled = false

func load_panel(weapon: base_range_weapon):
	$Sprite2D.texture = weapon.texture
	filled = true

func unload_panel():
	$Sprite2D.texture = null
	filled = false

func _on_weapon_button_pressed():
	if not filled:
		return
	emit_signal("weapon_pressed", index)

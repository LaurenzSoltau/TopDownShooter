extends Button

signal weapon_bought

@export var weapon_index: int



func _on_pressed():
	emit_signal("weapon_bought", weapon_index)

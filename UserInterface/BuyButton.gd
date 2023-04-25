extends Button

signal upgrade_bought
@export var upgrade_index: int



func _on_pressed():
	emit_signal("upgrade_bought", upgrade_index)

extends Button

signal upgrade_bought
var upgrade_number

func _on_pressed():
	if upgrade_number == null:
		print_debug("No Upgradenumber")
	upgrade_bought.emit(upgrade_number)

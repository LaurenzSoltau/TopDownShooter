extends Button

signal upgrade_bought

func _on_pressed():
	upgrade_bought.emit(self)

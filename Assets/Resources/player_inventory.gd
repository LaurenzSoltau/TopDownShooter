extends Resource

var weapons = []
var slots = 8
signal weapon_added


func add_weapon(weapon):
	if slots == 0:
		print_debug("Slots sind voll")
		return
	slots -= 1
	weapons.append(weapon)
	emit_signal("weapon_added")
	
	


func remove_weapon(index):
	if weapons.is_empty():
		print_debug("no weapons to remove")
		return
	weapons.remove_at(index)


func upgrade_weapon():
	pass

func stop_all_weapons():
	for weapon in weapons:
		weapon.stop()

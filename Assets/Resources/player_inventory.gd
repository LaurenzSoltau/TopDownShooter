extends Resource

var weapons = []
var slots = 8
signal weapon_added
signal weapon_removed


func add_weapon(weapon):
	if slots == 0:
		print_debug("Slots sind voll")
		return
	slots -= 1
	weapons.append(weapon)
	emit_signal("weapon_added", weapon)
	
	


func remove_weapon(index):
	if weapons.is_empty():
		print_debug("no weapons to remove")
		return
	slots += 1
	emit_signal("weapon_removed", index)
	weapons.remove_at(index)

func remove_weapon_by_name(weapon):
	if weapons.is_empty():
		print_debug("no weapons to remove")
		return
	var index = weapons.find(weapon)
	remove_weapon(index)


func upgrade_weapon():
	pass

func stop_all_weapons():
	for weapon in weapons:
		weapon.stop()

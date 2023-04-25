extends ColorRect

@onready var level_upgrades = preload("res://Assets/Resources/level_upgrades.tres")

var upgrades: Array
@onready var upgrade_containers = $HBoxContainer.get_children()

func new_shop():
	upgrades = get_upgrades(3)
	assign_upgrades(upgrades)


func get_upgrades(amount: int):
	var created_upgrades = []
	for i in amount:
		var new_upgrade
		var rand_int
		while (new_upgrade in created_upgrades or new_upgrade == null):
			rand_int = randi() % level_upgrades.upgrades.size()
			new_upgrade = level_upgrades.upgrades[rand_int]
		created_upgrades.append(level_upgrades.upgrades[rand_int])
		print(created_upgrades)
	return created_upgrades


func assign_upgrades(upgrades: Array):
	var counter = 0
	for container in upgrade_containers:
		container.get_child(0).text = upgrades[counter]["name"]
		var description = container.get_child(1).text % [upgrades[counter]["tier_multiplier"], upgrades[counter]["stat"]]
		container.get_child(1).text = description
		counter += 1




extends ColorRect

@onready var level_upgrades = preload("res://Assets/Resources/level_upgrades.tres")
var player_stats
var upgrades: Array
@onready var upgrade_containers = $HBoxContainer.get_children()

func new_shop():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	$AnimationPlayer.current_animation = "SlideIn"
	$AnimationPlayer.play()
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
	return created_upgrades


func assign_upgrades(upgrades: Array):
	var counter = 0
	for container in upgrade_containers:
		var vContainer = container.get_child(0).get_child(0)
		vContainer.get_child(0).text = upgrades[counter]["name"]
		var description = "Fügt %s zu %s hinzu." % [upgrades[counter]["tier_multiplier"], upgrades[counter]["stat"]]
		vContainer.get_child(1).text = description
		counter += 1

func upgrade_bought(index):
	print(index)
	$AnimationPlayer.current_animation = "SlideOut"
	$AnimationPlayer.play()
	get_tree().paused = false



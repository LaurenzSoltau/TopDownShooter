extends Node

class_name Wave

# count of enemy types
@export var count1: int
@export var count2: int
@export var count3: int
@export var count4: int
@export var count5: int

var enemy_counts: Array
var type_code: Array
var total_enemies: int
@export var second_between_spawns: float = 1.5

func _ready():
	# get the array with the enemy counts
	enemy_counts.append(count1)
	enemy_counts.append(count2)
	enemy_counts.append(count3)
	enemy_counts.append(count4)
	enemy_counts.append(count5)
	# get sum of all enemies
	var accum = 0
	for count in enemy_counts:
		accum += count
	total_enemies = accum
	#create the type code
	
	for i in enemy_counts.size():
		for j in enemy_counts[i]:
			type_code.append(i)



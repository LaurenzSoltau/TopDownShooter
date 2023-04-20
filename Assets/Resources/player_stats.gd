extends Resource

class_name PlayerStats
signal stat_changed

# health related stats
@export var max_health: int = 10
@export var health: int = 10
@export var health_regen: int = 0

# utility related stats
@export var attack_range: int = 300
@export var movement_speed: int = 400


# damage related stats
@export var damage_percent: int = 0
@export var range_damage: int = 0


#exp related stats
@export var level: int = 1
@export var xp_needed: float = 100
@export var xp: float = 0


# collectibles
@export var money: int = 0

var stats = {}
func _init():
	load_in_stats_dic()



# sets a stat and excpect the stat name and the new value of the stat
# also emits signal with dictionary with all stats passed
func add_stat(stat_name: String, addition, emit_signal: bool):
	stats[stat_name] += addition
	if emit_signal:
		emit_signal("stat_changed", stats)
	

func set_stat(stat_name: String, new_value, emit_signal: bool):
	stats[stat_name] = new_value
	if emit_signal:
		emit_signal("stat_changed", stats)



#load all stats in stats dictionary
func load_in_stats_dic():
	stats["max_health"] = max_health
	stats["health"] = health
	stats["health_regen"] = health_regen
	stats["attack_range"] = attack_range
	stats["movement_speed"] = movement_speed
	stats["damage_percent"] = damage_percent
	stats["range_damage"] = range_damage
	stats["level"] = level
	stats["xp_needed"] = xp_needed
	stats["xp"] = xp
	stats["money"] = money







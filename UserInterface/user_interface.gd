extends Control

@onready var scene_tree: = get_tree()
@onready var pause_overlay: ColorRect = get_node("PauseOverlay")
@onready var score_label: Label = get_node("money")
@onready var hp_label: Label = get_node("hp_bar/hp")
@onready var hp_bar: ProgressBar = get_node("hp_bar")
@onready var xp_label: Label = get_node("xp_bar/level")
@onready var xp_bar: ProgressBar = get_node("xp_bar")
@onready var level_upgrades = load("res://Assets/Resources/level_upgrades.tres")
@onready var inv_overlay = get_node("InvOverlay")
@onready var menu_slide_sound: AudioStreamPlayer2D = get_node("MenuSlide")
@onready var wave_spawner = get_node("/root/game/WaveSpawner")
var player_stats: Resource
var vendor: Node
var no_input = false

var paused: = false:
	set(value):
		paused = on_pause_mode_change(value)

func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	player_stats.connect("stat_changed", update_interface)
	wave_spawner.connect("new_wave", wave_changed)
	update_interface(player_stats.stats)
	vendor = get_node("/root/game/Vendor")
	vendor.connect("shop_opened", shop_opened)


func update_interface(stats):
	# update money
	score_label.text = "Money: %s" % stats["money"]
	# update hp bar
	hp_label.text = "%s/%s" % [stats["health"], stats["max_health"]]
	hp_bar.max_value = stats["max_health"]
	update_progress_bar(hp_bar, stats["health"], 0.05)
	# update xp
	xp_label.text = "Level %s" % stats["level"]
	xp_bar.max_value = stats["xp_needed"]
	update_progress_bar(xp_bar, stats["xp"], 0.5)


func _unhandled_input(event):
	if no_input:
		return
	if event.is_action_pressed("close"):
		if inv_overlay.visible:
			block_input(0.5)
			inv_overlay.deload()
		elif $WeaponShop.visible:
			block_input(0.5)
			$WeaponShop.close_shop()
		elif paused:
			paused = false
		else:
			paused = true
	if event.is_action_pressed("pause") and not $UpgradeOverlay.visible and not $InvOverlay.visible and not $WeaponShop.visible:
		self.paused = not paused
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("stats") and not $UpgradeOverlay.visible and not pause_overlay.visible and not $WeaponShop.visible:
		if inv_overlay.visible:
			inv_overlay.deload()
		else:
			inv_overlay.load()
		block_input(0.5)
	if event.is_action_pressed("interact") and $WeaponShop.visible:
		$WeaponShop.close_shop()


func on_pause_mode_change(value):
	scene_tree.paused = value
	pause_overlay.visible = value
	return value

# this functions smoothly changes the value of a progress bar
func update_progress_bar(progressbar, end, duration):
	var tween = get_tree().create_tween()
	tween.tween_property(progressbar, "value", end, duration)

func shop_opened():
	if not $UpgradeOverlay.visible and not get_tree().paused:
		if $WeaponShop.new_shop():
			block_input(0.5)
		
		
		

func play_slide_sound():
	await get_tree().create_timer(0.2).timeout
	menu_slide_sound.play()

func wave_changed(wave):
	$Label.text = "Wave: %s" % str(wave + 1)

func block_input(time):
	no_input = true
	await get_tree().create_timer(time).timeout
	no_input = false
	

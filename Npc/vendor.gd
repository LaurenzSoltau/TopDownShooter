extends AnimatedSprite2D

@onready var weapons = WeaponScenes.weapons
var player_in_area: = false
var user_interface: Node
signal shop_opened


func _ready():
	global_position = Vector2(randi_range(-500, 500), randi_range(-500, 500))
	


func _unhandled_key_input(event):
	if event.is_action_pressed("interact") and player_in_area:
		open_shop()


func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		player_in_area = true


func _on_area_2d_area_exited(area):
	if area.is_in_group("player"):
		player_in_area = false

func open_shop():
	emit_signal("shop_opened")


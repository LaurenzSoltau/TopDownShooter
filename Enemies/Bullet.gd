extends Area2D

var damage = 0
var velocity = Vector2.ZERO

func _process(delta):
	position = position + velocity * delta


func _on_area_entered(area):
	if area.is_in_group("player"):
		area.got_hit(damage)
		queue_free()

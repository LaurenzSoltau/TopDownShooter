extends Area2D

var damage = 0
var velocity = Vector2.ZERO

func _process(delta):
	position = position + velocity * delta
	if global_position.x > 1000 or global_position.x < -1000:
		queue_free()
	if global_position.y > 1000 or global_position.y < -1000:
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("player"):
		area.got_hit(damage)
		queue_free()

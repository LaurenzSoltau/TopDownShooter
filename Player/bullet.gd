extends RigidBody2D


var damage = 2

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()





func _on_body_entered(body):
	if body.has_method("got_hit"):
		body.got_hit(damage)
	queue_free()

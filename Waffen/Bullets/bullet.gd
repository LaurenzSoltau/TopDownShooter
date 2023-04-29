extends RigidBody2D


var damage: float
var point_of_origin

func init(pBase_damage):
	damage = pBase_damage
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


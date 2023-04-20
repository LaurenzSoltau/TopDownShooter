extends RigidBody2D

var base_damage: float
var damage

func init(pBase_damage):
	base_damage = pBase_damage
	#remote later
	damage = base_damage
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


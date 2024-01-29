extends RigidBody3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.health += 1
		queue_free()

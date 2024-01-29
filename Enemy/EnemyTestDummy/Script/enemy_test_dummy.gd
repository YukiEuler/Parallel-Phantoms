extends CharacterBody3D

var health = 2

@warning_ignore("unused_parameter")
func _process(delta):
	if health <= 0:
		queue_free()

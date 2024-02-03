extends Area3D
@export var damage = 1
func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= damage 
		body.knock_time = 25

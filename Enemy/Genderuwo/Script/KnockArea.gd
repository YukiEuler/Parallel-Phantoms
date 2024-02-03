extends StaticBody3D

@onready var player = get_tree().root.find_child("Player", true, false)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_body_entered(body):
	if body.is_in_group("Player"):
		if not (player.SPEED == player.BLOCKING_SPEED):
			body.health -= 1
		player.knock_dir = -position.direction_to(body.position)
		player.knock_time = 25

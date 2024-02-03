extends CharacterBody3D

var direct
var SPEED = 4.0
var health = 1
var knock_time = 0
@onready var player = get_tree().root.find_child("Player", true, false)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")
	set_as_top_level(true)
	velocity.y = -0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		queue_free()
	
func _physics_process(delta):
	var direction = position.direction_to(direct)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	model_rotation(delta)
	var cek = move_and_collide(velocity * delta)
	if cek and cek.get_collider().name != 'StaticBody3D':
		print(cek.get_collider().name)
	if cek and cek.get_collider().name == 'Player':
		queue_free()
		player.health -= 1

func model_rotation(delta):
	#rotation model
	if velocity.x != 0.0 or velocity.z != 0.0:
		self.rotation.y = lerp_angle(self.rotation.y, atan2(velocity.x, velocity.z), delta * 10)

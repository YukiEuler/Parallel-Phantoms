extends CharacterBody3D

var health = 1
var SPEED = 0

const NORMAL_SPEED = 1.0
const CHASE_SPEED = 3.0
const STOP_SPEED = 0.0

const ANGULAR_MOVEMENT = 10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var tick = 100
var knock_time = 0
var input_dir
var direction
var distance
var pos_before
var angle_before
var player_body = null

@onready var player = get_tree().root.find_child("Player", true, false)
@onready var model = $Model

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass
	if health <= 0:
		queue_free()
		
func _physics_process(delta):
	if player.off_menu:
		pass
		
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if player_body:
		SPEED = CHASE_SPEED
		direction = position.direction_to(player_body.position)
		if not angle_before:
			angle_before = atan2(direction.x, direction.z)
		var temp = (self.position.x-player_body.position.x)**2 + (self.position.z-player_body.position.z)**2
		if (temp < distance and pos_before != player_body.position) or (abs(angle_before-atan2(direction.x, direction.z)) >= 0.1 and abs(temp-distance) < 0.5):
			direction *= -1
		pos_before = player_body.position
		angle_before = atan2(direction.x, direction.z)
		distance = temp
	else:
		if tick == 100:
			input_dir = Vector3(randf_range(-1, 1), randf_range(-1, 1) , randf_range(-1, 1))
			direction = (transform.basis * Vector3(input_dir.x, input_dir.z, input_dir.y)).normalized()
			SPEED = STOP_SPEED
		elif tick == 500:
			tick = 0
			SPEED = NORMAL_SPEED
		tick += 1
		
	if player.knock_time > 0:
		SPEED = STOP_SPEED
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	model_rotation(delta)
	move_and_slide()
	
func model_rotation(delta):
	#rotation model
	if velocity.x != 0.0 or velocity.z != 0.0 and player.off_menu:
		model.rotation.y = lerp_angle(model.rotation.y, atan2(velocity.x, velocity.z), delta * ANGULAR_MOVEMENT)

func _on_player_body_entered(body):
	if body.is_in_group("Player"):
		if not (player.SPEED == player.BLOCKING_SPEED):
			body.health -= 1
		player.knock_dir = direction
		player.knock_time = 25
	
func _is_chase_player(body):
	if body.is_in_group("Player"):
		player_body = body
		distance = (self.position.x-body.position.x)**2 + (self.position.z-body.position.z)**2
		pos_before = body.position
		angle_before = null
			
func _is_not_chase_player(body):
	if body.is_in_group("Player"):
		SPEED = STOP_SPEED
		player_body = null

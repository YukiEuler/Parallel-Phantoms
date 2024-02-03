extends CharacterBody3D

var health = 3
var SPEED = 0

const NORMAL_SPEED = 1.0
const CHASE_SPEED = 4.0
const STOP_SPEED = 0.0

const ANGULAR_MOVEMENT = 10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_dir
var direction
var state = 0
var player_body
var knock_time = 0
var shoot_time = 250
var shoot_array = []
var knock_dir = Vector3.ZERO

@onready var player = get_tree().root.find_child("Player", true, false)
@onready var projectile = preload("res://Enemy/Boss/Projectile.tscn")
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
	for elm in shoot_array:
		if is_instance_valid(elm):
			elm.direct = player_body.position
	if state == 1:
		projectile_attack(delta)
	elif state == 2:
		meele_attack(delta)

func _on_player_body_entered(body):
	if body.is_in_group("Player"):
		if not (player.SPEED == player.BLOCKING_SPEED):
			body.health -= 1
		player.knock_time = 50

func _on_projectile_range(body):
	if body.is_in_group("Player"):
		player_body = body
		state = 1
		
func _on_meele_range(body):
	if body.is_in_group("Player"):
		print("hola")
		state = 2

func _out_meele_range(body):
	if body.is_in_group("Player"):
		state = 1
		
func _out_projectile_range(body):
	if body.is_in_group("Player"):
		player_body = null
		state = 0
		
func projectile_attack(delta):
	SPEED = STOP_SPEED
	if shoot_time == 0:
		var shoot = projectile.instantiate()
		add_child(shoot)
		shoot_array.append(shoot)
		shoot_time = 250
	else:
		shoot_time -= 1
	
func meele_attack(delta):
	SPEED = CHASE_SPEED
	direction = position.direction_to(player_body.position)
	if player.knock_time > 0:
		SPEED = STOP_SPEED
	if knock_time > 0:
		if knock_dir == Vector3.ZERO:
			knock_dir = -direction
		direction = knock_dir
		knock_time -= 1
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if knock_time <= 0:
		knock_dir = Vector3.ZERO
		model_rotation(delta)
	move_and_slide()
	
func model_rotation(delta):
	#rotation model
	if velocity.x != 0.0 or velocity.z != 0.0 and player.off_menu:
		model.rotation.y = lerp_angle(model.rotation.y, atan2(velocity.x, velocity.z), delta * ANGULAR_MOVEMENT)

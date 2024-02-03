extends CharacterBody3D

var health = 2
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
var player_body = null
var warn_att
var att
var warn_time = -1
var sudut

@onready var player = get_tree().root.find_child("Player", true, false)
@onready var model = $Model
@onready var Attack = preload("res://Enemy/Genderuwo/GenderuwoAttack.tscn")
@onready var WarningAttack = preload("res://Enemy/Genderuwo/GenderuwoWarning.tscn")

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
	if player_body:
		SPEED = 1
		if warn_time == 100:
			direction = position.direction_to(player_body.position)
			warn_att = WarningAttack.instantiate()
			get_node("Model").add_child(warn_att)
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
		
	model_rotation(model, delta)
	
	if warn_time > 0:
		warn_time -= 1
		
	if warn_time == 50:
		warn_att.queue_free()
		if player_body:
			att = Attack.instantiate()
			get_node("Model").add_child(att)
	
	if warn_time == 0:
		if is_instance_valid(att):
			att.queue_free()
		if player_body:
			if warn_time <= 0:
				warn_time = 100
			
	move_and_slide()
	
func model_rotation(what, delta):
	#rotation model
	if velocity.x != 0.0 or velocity.z != 0.0 and player.off_menu:
		what.rotation.y = lerp_angle(what.rotation.y, atan2(velocity.x, velocity.z), delta * 50)

func _on_player_body_entered(body):
	if body.is_in_group("Player"):
		print("H-hmphh")
		if not (player.SPEED == player.BLOCKING_SPEED):
			body.health -= 1
		player.knock_dir = direction
		player.knock_time = 25
	
func _is_chase_player(body):
	if body.is_in_group("Player"):
		player_body = body
		if warn_time <= 0:
			warn_time = 100
		
func _is_not_chase_player(body):
	if body.is_in_group("Player"):
		SPEED = STOP_SPEED
		player_body = null

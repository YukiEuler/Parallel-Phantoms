extends CharacterBody3D

var health = 3
var SPEED = 0.0

var off_menu: bool = true
const NORMAL_SPEED = 5.0
const BLOCKING_SPEED = 2.0
const STOP_SPEED = 0.0

const ANGULAR_MOVEMENT = 10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var health_bar = $PlayerUI/HealthBar
@onready var player_UI = $PlayerUI
@onready var model = $Model

var knock_time = 0
var knock_dir = Vector3.ZERO

func  _ready():
	SPEED = NORMAL_SPEED
	player_UI.visible = true

func _process(delta):
	health_bar.value = health
	if health <= 0:
		off_menu = false
		SPEED = STOP_SPEED 
		
		get_tree().change_scene_to_file("res://UI/Scnee/DeadScreen/dead_screen.tscn")

func _input(event):
	if Input.is_action_just_pressed("defense"):
		SPEED = BLOCKING_SPEED
	elif Input.is_action_just_released("defense"):
		SPEED = NORMAL_SPEED
	if Input.is_action_just_pressed("ui_cancel") and off_menu == true:
		player_UI.visible = false
		off_menu = false
	elif Input.is_action_just_pressed("ui_cancel") and off_menu == false:
		player_UI.visible = true
		off_menu = true

func _physics_process(delta):
	# Add Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if knock_time > 0:
		if knock_dir == Vector3.ZERO:
			knock_dir = -direction
		direction = knock_dir
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if knock_time <= 0:
		knock_dir = Vector3.ZERO
		model_rotation(delta)
	else:
		knock_time -= 1
		
	move_and_slide()

func model_rotation(delta):
	#rotation model
	if velocity.x != 0.0 or velocity.z != 0.0 and off_menu == true:
		model.rotation.y = lerp_angle(model.rotation.y, atan2(velocity.x, velocity.z), delta * ANGULAR_MOVEMENT)


extends Node3D

@onready var anim_combat = $CombatAnim
var is_not_blocking: bool = true
func _input(event):
	if Input.is_action_pressed("attack") and is_not_blocking == true :
		anim_combat.play("SwordAttack")
	elif Input.is_action_pressed("defense") and is_not_blocking == true:
		anim_combat.play("Shild")
		is_not_blocking = false
	elif Input.is_action_just_released("defense")and is_not_blocking == false:
		anim_combat.play_backwards("Shild")
		is_not_blocking = true

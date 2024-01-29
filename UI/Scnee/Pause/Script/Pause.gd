extends Control

@onready var setting = $Setting
func _ready():
	visible = false
	setting.visible = false
func _input(event):
	if Input.is_action_just_pressed("ui_cancel") and visible == false:
		visible = true
	elif Input.is_action_just_pressed("ui_cancel") and visible == true:
		visible = false

func _on_resume_pressed():
	visible = false

func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_setting_pressed():
	setting.visible = true


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/Scnee/MainMenu/MainMenu.tscn")

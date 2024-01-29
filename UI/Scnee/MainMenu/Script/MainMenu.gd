extends Control

@onready var setting_Scnee = $Setting

func _ready():
	setting_Scnee.visible = false


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Level/ProperLevel/TestLevel/test_level.tscn")


func _on_setting_pressed():
	setting_Scnee.visible = true


func _on_exit_pressed():
	get_tree().quit()

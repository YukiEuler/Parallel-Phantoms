extends Control


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Level/ProperLevel/TestLevel/test_level.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/Scnee/MainMenu/MainMenu.tscn")

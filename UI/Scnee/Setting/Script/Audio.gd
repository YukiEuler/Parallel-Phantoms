extends TabBar

var master_bus = AudioServer.get_bus_index("Master")
var music = AudioServer.get_bus_index("Music")
var Sound_effect = AudioServer.get_bus_index("SoundEffect")


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus,value)


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music,value)


func _on_sound_effect_slider_value_changed(value):
	AudioServer.set_bus_volume_db(Sound_effect,value)

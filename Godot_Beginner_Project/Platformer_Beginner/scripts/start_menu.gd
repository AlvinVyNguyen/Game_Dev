extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn") #load a scene file at this path
	
	

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	

func _on_quit_pressed():
	get_tree().quit()

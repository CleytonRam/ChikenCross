extends CanvasLayer



func _on_button_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")	

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

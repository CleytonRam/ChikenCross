extends Control

@onready var startButton = $StartButton
@onready var start2Button = $Start2Button
@onready var quitButton = $QuitButton
@onready var backgroundMusic = $MenuMusic  # Use @onready aqui

func _ready():
	startButton.grab_focus()
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	backgroundMusic.play()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/1PlayerScene.tscn")
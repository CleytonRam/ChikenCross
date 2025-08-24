extends Node

const CarScene = preload("res://Scenes/Cars.tscn")



@export var pointsToWin: int = 5
var points1 = 0

const fastTrack = [156.0, 411.0, 646.0, 734.0]
const slowTrack = [245.0, 323.0, 492.0, 816.0]
const cabulosoTrack = [580.0, 910.0]

var playerPosition = Vector2(942.0, 996.0)

func _ready():
	randomize();
	$Player.position = playerPosition
	$AudioTheme.play()
	$HUD.get_node("Score").visible = true
	$HUD.get_node("Press2P").visible = true

	configurePauseBehavior()

	set_process_input(true)
	process_mode = Node.PROCESS_MODE_ALWAYS
	#logica para botoes nao pausarem
	$HUD/Button.process_mode = Node.PROCESS_MODE_ALWAYS
	$HUD/ButtonMenu.process_mode = Node.PROCESS_MODE_ALWAYS

		

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	
	if event.is_action_pressed("ui_cancel") and not isGameOver:
		toggle_pause()


func _on_finish_line_area_entered(area:Area2D):
	print("cheguei")
	if area.name == "Player":
		$Player.position = playerPosition
		points1 += 1
		$HUD.get_node("Score").text = str(points1)
		print("Player 1 Points: ", points1)

	if points1 >= pointsToWin:
		isGameOver = true
		$HUD.get_node("Message").visible = true
		$HUD.get_node("Message").text = "You Won!"
		$HUD.get_node("ColorRect").visible = true
		$HUD.get_node("Button").visible = true
		$HUD.get_node("ButtonMenu").visible = true
		$AudioTheme.stop()
		$AudioVictory.play()

		get_tree().paused = true

	playRandomPitch()

func playRandomPitch():
	# normal pitch = 1.0
	var r = randf()
	var pitch : float
	if r < 0.6:  # 60% chance
		pitch = 1.0
	elif r < 0.8: #20% chance
		pitch = randf_range(0.6, 0.8)
	else: # 20% chance
		pitch = randf_range(1.5, 1.7)

	$AudioPoint.pitch_scale = pitch
	$AudioPoint.stop()
	$AudioPoint.play()


func _on_fast_cars_timeout() -> void:
	var car = CarScene.instantiate()
	add_child(car)
	car.add_to_group("cars")
	car.position.x = -10
	car.position.y = fastTrack[randi() % fastTrack.size()]
	car.carSpeedFast()


func _on_slow_cars_timeout() -> void:
	var car = CarScene.instantiate()
	add_child(car)
	car.add_to_group("cars")
	car.position.x = -10
	car.position.y = slowTrack[randi() % slowTrack.size()]
	car.carSpeedSlow()

func _on_cabuloso_timer_timeout() -> void:
	var car = CarScene.instantiate()
	print("Cabuloso car is on the game")
	add_child(car)
	car.add_to_group("cars")
	car.position.x = -10
	car.position.y = cabulosoTrack[randi() % cabulosoTrack.size()]
	car.carSpeedCabuloso()



func _on_player_body_entered(body:Node2D) -> void:
	$Player.bateu()
	$Player.position = playerPosition

	

func _on_button_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	



#region PAUSE
var volumePause = 0.0
var isGameOver = false
var isGamePaused = false


func toggle_pause():
	if get_tree().paused:
		# Despausar
		get_tree().paused = false
		isGamePaused = false
		$HUD/ColorRect.visible = false
		$HUD/Button.visible = false
		$HUD/ButtonMenu.visible = false
		$AudioTheme.volume_db = volumePause
		for car in get_tree().get_nodes_in_group("cars"):
			car.process_mode = Node.PROCESS_MODE_PAUSABLE
	else:
		# Pausar
		isGamePaused = true
		get_tree().paused = true
		$HUD/ColorRect.visible = true
		$HUD/Button.visible = true
		$HUD/ButtonMenu.visible = true
		volumePause = $AudioTheme.volume_db
		$AudioTheme.volume_db = -40
		for car in get_tree().get_nodes_in_group("cars"):
			car.process_mode = Node.PROCESS_MODE_PAUSABLE



func configurePauseBehavior():
	$Player.process_mode = Node.PROCESS_MODE_PAUSABLE
	$FastCars.process_mode = Node.PROCESS_MODE_PAUSABLE
	$SlowCars.process_mode = Node.PROCESS_MODE_PAUSABLE
	$CabulosoTimer.process_mode = Node.PROCESS_MODE_PAUSABLE

	$FinishLine.process_mode = Node.PROCESS_MODE_PAUSABLE
	for child in get_children():
		if child.is_in_group("cars"):
			child.process_mode = Node.PROCESS_MODE_PAUSABLE

#endregion


#logica press 2p
var showMessage := true

func update_press_2p_message():
	if showMessage:
		$HUD.get_node("Press2P").text = "Press ENTER to play"
	else:
		$HUD.get_node("Press2P").text = ""
	showMessage = !showMessage

func _on_timer_timeout() -> void:
	update_press_2p_message()

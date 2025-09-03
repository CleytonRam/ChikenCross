extends Node



const CarScene = preload("res://Scenes/Cars.tscn")



@export var pointsToWin: int = 5
var points1 = 0
var points2 = 0	

const fastTrack = [156.0, 411.0, 646.0, 734.0]
const slowTrack = [245.0, 323.0, 492.0, 816.0]
const cabulosoTrack = [580.0, 910.0]

const fastTrackDirection = [1, 1, -1, -1]  # Direção para cada pista em fastTrack
const slowTrackDirection = [1, -1, 1, -1]   # Direção para cada pista em slowTrack
const cabulosoTrackDirection = [-1, 1]     # Direção para cada pista em cabulosoTrack



var playerPosition = Vector2(628.0, 987.0)
var player2Position = Vector2(1243.0, 988.0)


func _ready():
	randomize();
	$Player.position = playerPosition
	$Player2.position = player2Position
	$AudioTheme.play()
	$HUD.get_node("Score").visible = true
	$HUD.get_node("Score2").visible = true
	configurePauseBehavior()
	set_process_input(true)
	process_mode = Node.PROCESS_MODE_ALWAYS
	#logica para botoes nao pausarem
	$HUD/Button.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	$HUD/ButtonMenu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

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
	elif area.name == "Player2":
		$Player2.position = player2Position
		points2 += 1
		$HUD.get_node("Score2").text = str(points2)
		print("Player 2 Points: ", points2)

	if points1 >= pointsToWin or points2 >= pointsToWin:
		$HUD.get_node("Message").text = "Player " + str(1 if points1 > points2 else 2) + " Wins!"
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
	var index = randi() % fastTrack.size()
	car.direction = fastTrackDirection[index]  # Define a direção primeiro
	add_child(car)
	var base_y = fastTrack[index]
	var scaled_y = ResolutionManager.getScaledPosition(Vector2(0, base_y)).y
	car.position.y = scaled_y
	car.direction = fastTrackDirection[index]

	var viewport_size = get_viewport().get_visible_rect().size
	if car.direction == 1:
		car.position.x = -10
	else:
		car.position.x = viewport_size.x + 10
	
	
	# Chama a função de velocidade DEPOIS de definir a direção
	if car.direction == 1:
		car.carSpeedFast()
	else:
		car.carSpeedFast()  # Já leva em conta a direção


func _on_slow_cars_timeout() -> void:
	var car = CarScene.instantiate()
	var index = randi() % slowTrack.size()
	car.direction = slowTrackDirection[index]  # Define a direção primeiro

	add_child(car)
	var base_y = slowTrack[index]
	var scaled_y = ResolutionManager.getScaledPosition(Vector2(0, base_y)).y
	car.position.y = scaled_y
	car.direction = slowTrackDirection[index]

	var viewport_size = get_viewport().get_visible_rect().size 
	if car.direction == 1:
		car.position.x = -10
	else:
		car.position.x = viewport_size.x + 10

	if car.direction == 1:
		car.carSpeedSlow()
	else:
		car.carSpeedSlow()  # Já leva em conta a direção

func _on_cabuloso_timer_timeout() -> void:
	var car = CarScene.instantiate()
	var index = randi() % cabulosoTrack.size()
	car.direction = cabulosoTrackDirection[index]  # Define a direção primeiro
	add_child(car)
	var base_y = cabulosoTrack[index]
	var scaled_y = ResolutionManager.getScaledPosition(Vector2(0, base_y)).y
	car.position.y = scaled_y
	car.direction = cabulosoTrackDirection[index]

	var viewport_size = get_viewport().get_visible_rect().size
	if car.direction == 1:
		car.position.x = -10
	else:
		car.position.x = viewport_size.x + 10

	# Chama a função de velocidade DEPOIS de definir a direção
	if car.direction == 1:
		car.carSpeedCabuloso()
	else:
		car.carSpeedCabuloso()  # Já leva em conta a direção

func _on_player_body_entered(body:Node2D) -> void:
	$Player.bateu()
	$Player.position = playerPosition



func _on_player_2_body_entered(body:Node2D) -> void:
	$Player2.bateu()
	$Player2.position = player2Position
	

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
	$Player2.process_mode = Node.PROCESS_MODE_PAUSABLE
	$FastCars.process_mode = Node.PROCESS_MODE_PAUSABLE
	$SlowCars.process_mode = Node.PROCESS_MODE_PAUSABLE
	$CabulosoTimer.process_mode = Node.PROCESS_MODE_PAUSABLE

	$FinishLine.process_mode = Node.PROCESS_MODE_PAUSABLE
	for child in get_children():
		if child.is_in_group("cars"):
			child.process_mode = Node.PROCESS_MODE_PAUSABLE

#endregion
extends Node



const CarScene = preload("res://Scenes/Cars.tscn")


const fastTrack = [439.0, 144.0, 243.0, 342.0]
const slowTrack = [96.0, 194.0, 387.0, 489.0, 543.0, 290.0]
# const cabulosoTrack = [342.0, 290.0]



var playerPosition = Vector2.ZERO
var player2Position = Vector2.ZERO


func _ready():
	randomize();
	playerPosition = $Player.position
	player2Position = $Player2.position
	$AudioTheme.play()

func _on_finish_line_area_entered(area:Area2D):
	print("cheguei")
	if area.name == "Player":
		$Player.position = playerPosition
	elif area.name == "Player2":
		$Player2.position = player2Position

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
		pitch = randf_range(1.2, 1.4)

	$AudioPoint.pitch_scale = pitch
	$AudioPoint.stop()
	$AudioPoint.play()


func _on_fast_cars_timeout() -> void:
	var car = CarScene.instantiate()
	add_child(car)
	car.position.x = -10
	car.position.y = fastTrack[randi() % fastTrack.size()]
	car.carSpeedFast()


func _on_slow_cars_timeout() -> void:
	var car = CarScene.instantiate()
	add_child(car)
	car.position.x = -10
	car.position.y = slowTrack[randi() % slowTrack.size()]
	car.carSpeedSlow()

func _on_player_body_entered(body:Node2D) -> void:
	$Player.position = playerPosition


func _on_player_2_body_entered(body:Node2D) -> void:
	$Player2.position = player2Position


# func _on_cabuloso_timer_timeout() -> void:
# 	var car = CarScene.instantiate()
# 	print("Cabuloso car is on the game")
# 	add_child(car)
# 	car.position.x = -10
# 	car.position.y = cabulosoTrack[randi() % cabulosoTrack.size()]
# 	car.carSpeedCabuloso()



extends CharacterBody2D

@export var speed = Vector2.ZERO
@export var acceleration = Vector2.ZERO
@export var direction: int = 1  # 1 para direita, -1 para esquerda

func _ready():
	randomize()
	var carRandom = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var carColor = carRandom[randi() % carRandom.size()]
	$AnimatedSprite2D.play(carColor)
	
	process_mode = Node.PROCESS_MODE_PAUSABLE
	# Aplicar o flip baseado na direção
	apply_direction_flip()

func apply_direction_flip():
	# Se a direção for para a esquerda, vira o sprite
	if direction == -1:
		scale.x = -abs(scale.x)  # Inverte horizontalmente
	else:
		scale.x = abs(scale.x)   # Volta ao normal

func carSpeedFast():
	speed = Vector2(randf_range(700, 750) * direction, 0)
	apply_direction_flip()  # Reaplicar o flip após mudar a velocidade

func carSpeedSlow():
	speed = Vector2(randf_range(300, 350) * direction, 0)
	apply_direction_flip()  # Reaplicar o flip após mudar a velocidade

func carSpeedCabuloso():
	speed = Vector2(randf_range(900, 950) * direction, 0)
	apply_direction_flip()  # Reaplicar o flip após mudar a velocidade

func _physics_process(_delta):
	velocity = speed
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("CARRO SAIU ")
	queue_free()
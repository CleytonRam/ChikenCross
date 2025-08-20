extends Area2D
signal pontua

@export var speed: float = 100.0
var screenSize: Vector2
var initialPosition: Vector2 = Vector2(351,626)

func _ready() -> void:
	screenSize = get_viewport_rect().size
	position = initialPosition

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	# Entrada vertical (corrigida)
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1  
	
	# Entrada horizontal
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	# Aplicar velocidade
	if velocity.length() > 0:
		# Duplica velocidade apenas no eixo X
		var speed_multiplier = speed * (2.0 if velocity.x != 0 else 1.0)
		velocity = velocity.normalized() * speed_multiplier
	
	position += velocity * delta
	position.x = clamp(position.x, 0.0, screenSize.x)
	position.y = clamp(position.y, 0.0, screenSize.y)
	
	# Animações
	if velocity.y > 0:
		$AnimatedSprite2D.play("Down")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("Up")
	else:
		$AnimatedSprite2D.play("Iddle")  

func _on_body_entered(body):
	if body.name == "FinishLine":
		emit_signal("pontua")
	else:
		position = initialPosition
		$AudioStreamPlayer2D.play()

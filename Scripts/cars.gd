extends CharacterBody2D

@export var speed = Vector2.ZERO
@export var acceleration = Vector2.ZERO

func _ready():
	randomize()
	var carRandom = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var carColor = carRandom[randi() % carRandom.size()]
	$AnimatedSprite2D.play(carColor)
	#carSpeedFast()


func carSpeedFast():
	speed = Vector2(randf_range(700, 750), 0)

func carSpeedSlow():
	speed = Vector2(randf_range(300, 350), 0)

func carSpeedCabuloso():
	speed = Vector2(randf_range(900, 950), 0)

func _physics_process(_delta):
	velocity = speed
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("CARRO SAIU ")
	queue_free()

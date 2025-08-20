extends Label


var manager

func _ready():
	# Acessa GameManager como filho de Main
	manager = get_parent().get_node("GameManager")

func _process(_delta):
	text = "Score: %s" % manager.score

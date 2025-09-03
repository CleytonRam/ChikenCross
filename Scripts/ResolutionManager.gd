extends Node

var baseResolution = Vector2(1920, 1080)
var currentScale = Vector2(1, 1)

func _ready():
    await get_tree().process_frame
    var viewportSize = get_viewport().get_visible_rect().size
    currentScale = Vector2(
        viewportSize.x / baseResolution.x,
        viewportSize.y / baseResolution.y
    )
    print("Current Scale: ", currentScale)


func getScaledPosition(originalPosition):
    return Vector2(
        originalPosition.x * currentScale.x,
        originalPosition.y * currentScale.y
    )

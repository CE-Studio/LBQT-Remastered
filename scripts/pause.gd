extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
            get_tree().paused = true
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
            get_tree().paused = false

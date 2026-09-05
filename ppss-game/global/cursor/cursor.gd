extends Sprite2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position()
	
	var current_shape = Input.get_current_cursor_shape()
	
	match current_shape:
		Input.CURSOR_ARROW:
			frame = 0
		Input.CURSOR_POINTING_HAND:
			frame = 1
		_:
			frame = 0

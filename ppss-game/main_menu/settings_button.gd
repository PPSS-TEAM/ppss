extends TextureButton

func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_button_down() -> void:
	print(".")

func _on_button_up() -> void:
	await Transition.fade_in()
	get_tree().change_scene_to_file("res://settings/settings.tscn")

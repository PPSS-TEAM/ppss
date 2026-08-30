extends TextureButton

func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_button_down() -> void:
	print(".")

func _on_button_up() -> void:
	# Небольшая задержка из твоего шаблона перед началом анимации
	await get_tree().create_timer(0.15).timeout
	
	# Вызываем плавный переход вместо стандартного change_scene_to_file
	Transition.change_scene("res://settings.tscn", 0.2)

extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func change_scene(target_path: String, duration: float = 0.5) -> void:
	# Создаем твин для плавного появления черного экрана (затухание)
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished
	
	# Меняем сцену
	get_tree().change_scene_to_file(target_path)
	
	# Создаем твин для плавного возврата видимости (проявление)
	var tween_in = create_tween()
	tween_in.tween_property(color_rect, "modulate:a", 0.0, duration)

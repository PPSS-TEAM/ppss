extends BaseButton

@export_file("*.tscn") var target_scene_path: String

@export var use_transition: bool = true

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	print(target_scene_path)

	if target_scene_path.is_empty():
		push_warning("Кнопка '%s': Не назначена целевая сцена (PackedScene) в Инспекторе!" % name)
		return

	if use_transition:
		await Transition.fade_in()

	var error = get_tree().change_scene_to_file(target_scene_path)
	if error != OK:
		push_error("Кнопка '%s': Не удалось загрузить сцену. Код ошибки: %d" % [name, error])


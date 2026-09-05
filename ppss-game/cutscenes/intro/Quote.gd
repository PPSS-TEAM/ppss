extends Control

@export_file("*.tscn", "*.scn") var next_scene: String = "res://cutscenes/intro_1/intro_1.tscn"

var _label: RichTextLabel
var _timer: Timer
var _audio: AudioStreamPlayer2D
var _letter_count: int = 0

const NORMAL_SPEED: float = 0.03
var _is_finished: bool = false

func _ready() -> void:
	_label = get_node("RichTextLabel")
	_timer = get_node("Timer")
	_audio = get_node("AudioStreamPlayer2D")

	_label.visible_characters = 0

	_timer.wait_time = NORMAL_SPEED
	_timer.timeout.connect(_on_timer_timeout)
	_timer.start()

func _on_timer_timeout() -> void:
	if _label.visible_characters < _label.get_total_character_count():
		_label.visible_characters += 1
		_letter_count += 1

		var current_text: String = _label.get_parsed_text()
		var char_index: int = _label.visible_characters - 1
		
		# Небольшая защита от выхода за границы строки (на всякий случай)
		if char_index < 0 or char_index >= current_text.length():
			return
			
		var current_char: String = current_text[char_index]
		var next_delay: float = NORMAL_SPEED

		if current_char in [".", "?", "!"]:
			next_delay = 0.4 # Пауза на точке
		elif current_char in [",", "-", ":"]:
			next_delay = 0.2 # Пауза на запятой
		else:
			next_delay = NORMAL_SPEED + randf_range(-0.01, 0.01)

		_timer.wait_time = maxf(0.01, next_delay)

		if current_char != " " and current_char != "\n" and current_char != "\r":
			if _letter_count % 4 == 0:
				_audio.pitch_scale = randf_range(0.95, 1.05)
				_audio.play()
	else:
		# Текст полностью напечатался
		_timer.stop()
		_timer.timeout.disconnect(_on_timer_timeout)

		# Ждем ровно 3 секунды (аналог ToSignal + CreateTimer)
		await get_tree().create_timer(3.0).timeout
		
		# Переходим на следующую сцену
		_change_scene()

# Пропуск заставки по нажатию клавиши или клику мыши
func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or \
	   (event is InputEventKey and event.pressed):
		_change_scene()

func _change_scene() -> void:
	if _is_finished:
		return
	_is_finished = true

	get_tree().change_scene_to_file(next_scene)

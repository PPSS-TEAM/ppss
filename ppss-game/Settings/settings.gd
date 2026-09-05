extends Control

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sound_bus_index = AudioServer.get_bus_index("Sounds")

@onready var fullscreen_checkbox = $Fullscreen/Checkbox
var fullscreen_mimic_states = [ # это нужно чтобы т.к. есть 3 варианта, когда окно как бы в fullscreen (включая сам fullscreen), так что да, такой странный костыль
DisplayServer.WINDOW_MODE_FULLSCREEN,  
DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
DisplayServer.WINDOW_MODE_MAXIMIZED
]

@onready var resolution_option = $WindowSize/OptionButton
var resolutions = [
	Vector2i(640, 360),
	Vector2i(800, 600),
	Vector2i(1024, 768),
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

@onready var sound_btn_plus = $SoundVolume/ButtonPlus
@onready var sound_btn_minus = $SoundVolume/ButtonMinus
@onready var sound_bar = $SoundVolume/ProgressBar

@onready var music_btn_plus = $MusicVolume/ButtonPlus
@onready var music_btn_minus = $MusicVolume/ButtonMinus
@onready var music_bar = $MusicVolume/ProgressBar

func _ready() -> void:
	Transition.fade_out()

	var sound_linear = db_to_linear(AudioServer.get_bus_volume_db(sound_bus_index))
	sound_bar.value = snapped(sound_linear, 0.1)
	sound_btn_plus.pressed.connect(_on_sound_btn_pressed.bind(true))
	sound_btn_minus.pressed.connect(_on_sound_btn_pressed.bind(false))

	var music_linear = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	music_bar.value = snapped(music_linear, 0.1)
	music_btn_plus.pressed.connect(_on_music_btn_pressed.bind(true))
	music_btn_minus.pressed.connect(_on_music_btn_pressed.bind(false))

	var is_fullscreen = DisplayServer.window_get_mode() in fullscreen_mimic_states
	fullscreen_checkbox.button_pressed = is_fullscreen
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)

	resolution_option.disabled = is_fullscreen
	for resolution in resolutions:
		resolution_option.add_item(str(resolution.x) + "x" + str(resolution.y))

	var current_resolution = DisplayServer.window_get_size()
	var current_index = resolutions.find(current_resolution)
	if current_index != -1:
		resolution_option.selected = current_index
	
	resolution_option.item_selected.connect(_on_resolution_selected)
		

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		resolution_option.disabled = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		resolution_option.disabled = false
	WindowGlobal.center_window()
	_on_settings_changed()

func _on_resolution_selected(index: int) -> void:
	var new_size = resolutions[index]
	DisplayServer.window_set_size(new_size)
	WindowGlobal.center_window()
	_on_settings_changed()

func _on_sound_btn_pressed(is_plus: bool) -> void:
	var step = 0.1
	var new_value = sound_bar.value + (step if is_plus else -step)

	new_value = clampf(new_value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(sound_bus_index, linear_to_db(new_value))
	sound_bar.value = snapped(new_value, step)
	_on_settings_changed()

func _on_music_btn_pressed(is_plus: bool) -> void:
	var step = 0.1
	var new_value = music_bar.value + (step if is_plus else -step)

	new_value = clampf(new_value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(new_value))
	music_bar.value = snapped(new_value, step)
	_on_settings_changed()

func _on_settings_changed() -> void:
	var config = ConfigFile.new()
	
	config.set_value("display", "fullscreen", true)
	config.set_value("display", "resolution_x", DisplayServer.window_get_size().x)
	config.set_value("display", "resolution_y", DisplayServer.window_get_size().y)

	config.set_value("volume", "music", music_bar.value)
	config.set_value("volume", "sound", sound_bar.value)

	var e = config.save("user://settings.cfg")
	if e == OK:
		print("Настройки сохранены через ConfigFile!")
	else:
		print("Ошибка сохранения: ", e)

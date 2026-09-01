extends Control

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sound_bus_index = AudioServer.get_bus_index("Sounds")

@onready var music_slider = $MusicVolume/Slider
@onready var sound_slider = $SoundVolume/Slider

@onready var fullscreen_checkbox = $Fullscreen/Checkbox
var fullscreen_mimic_states = [ # это нужно чтобы т.к. есть 3 варианта, когда окно как бы в fullscreen (включая сам fullscreen), так что да, такой странный костыль
DisplayServer.WINDOW_MODE_FULLSCREEN,  
DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
DisplayServer.WINDOW_MODE_MAXIMIZED
]

@onready var resolution_option = $WindowSize/OptionButton
var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160),
]

func _ready() -> void:
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sound_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sound_bus_index))
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sound_slider.value_changed.connect(_on_sound_slider_changed)

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
		

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))

func _on_sound_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sound_bus_index, linear_to_db(value))

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		resolution_option.disabled = true # отключаем изменение разрешения при переключении в fullscreen
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		resolution_option.disabled = false
	

func _on_resolution_selected(index: int) -> void:
	var new_size = resolutions[index]
	DisplayServer.window_set_size(new_size)

	var screen = DisplayServer.window_get_current_screen()
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var target_pos = screen_rect.position + (screen_rect.size - new_size) / 2
	DisplayServer.window_set_position(target_pos)

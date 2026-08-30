extends Control

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sound_bus_index = AudioServer.get_bus_index("Sounds")

@onready var music_slider = $MusicSlider
@onready var sound_slider = $SoundSlider

func _ready() -> void:
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sound_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sound_bus_index))
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sound_slider.value_changed.connect(_on_sound_slider_changed)

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))

func _on_sound_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sound_bus_index, linear_to_db(value))

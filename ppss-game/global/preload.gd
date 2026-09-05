extends Node

func _ready() -> void:
    _load_settings()
    WindowGlobal.center_window()

func _load_settings() -> void:
    var config = ConfigFile.new()

    var err = config.load("user://settings.cfg")
	
    if err != OK:
        print("Файл настроек не найден или поврежден. Создаем настройки по умолчанию.")
        _save_default_settings()
        return

    var sound_vol = config.get_value("volume", "sound", 1.0)
    var music_vol = config.get_value("volume", "music", 1.0)
	
    var sound_bus = AudioServer.get_bus_index("Sounds")
    var music_bus = AudioServer.get_bus_index("Music")
	
    if sound_bus != -1:
        AudioServer.set_bus_volume_db(sound_bus, linear_to_db(sound_vol))
    if music_bus != -1:
        AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_vol))

    var res_x = config.get_value("display", "resolution_x", 1920)
    var res_y = config.get_value("display", "resolution_y", 1080)
    DisplayServer.window_set_size(Vector2i(res_x, res_y))


    var is_fullscreen = config.get_value("display", "fullscreen", false)
    if is_fullscreen:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
    WindowGlobal.center_window()

func _save_default_settings() -> void:
    var config = ConfigFile.new()
    config.set_value("display", "fullscreen", true)
    config.set_value("display", "resolution_x", 1920)
    config.set_value("display", "resolution_y", 1080)
    config.set_value("volume", "music", 1.0)
    config.set_value("volume", "sound", 1.0)
    config.save("user://settings.cfg")
	


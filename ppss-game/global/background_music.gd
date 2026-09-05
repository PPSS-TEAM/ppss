extends Node

@export var music: AudioStream = preload("res://sounds/theme.ogg")

var _audio_player: AudioStreamPlayer

func _ready() -> void:
    _audio_player = AudioStreamPlayer.new()
    _audio_player.stream = music
    _audio_player.bus = "Music"
    
    add_child(_audio_player)
    _audio_player.play()


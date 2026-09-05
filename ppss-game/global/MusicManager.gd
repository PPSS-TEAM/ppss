extends Node

# Убираем типизацию или используем Node
static var instance: Node  # или просто: static var instance

var _audio_player: AudioStreamPlayer

func _ready() -> void:
    instance = self
    _audio_player = AudioStreamPlayer.new()
    add_child(_audio_player)

func play_music(stream: AudioStream) -> void:
    if _audio_player.stream == stream and _audio_player.playing:
        return

    _audio_player.stream = stream
    _audio_player.play()

func stop_music() -> void:
    _audio_player.stop()

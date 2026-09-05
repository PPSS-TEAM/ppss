extends Node

@export var click_sound: AudioStream = preload("res://sounds/button-up.wav")

var _audio_player: AudioStreamPlayer

func _ready() -> void:
    _audio_player = AudioStreamPlayer.new()
    _audio_player.stream = click_sound
    _audio_player.bus = "Sounds"
    add_child(_audio_player)
    
    get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
    if node is BaseButton:
        if not node.pressed.is_connected(_play_click_sound):
            node.pressed.connect(_play_click_sound)

func _play_click_sound() -> void:
    _audio_player.play()

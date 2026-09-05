extends Node

@export var click_sound = preload("res://sound/button-up.wav") 

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.pressed.connect(_play_click_sound)

func _play_click_sound() -> void:
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = click_sound
	
	get_tree().root.add_child(audio_player)
	audio_player.play()
	
	audio_player.finished.connect(audio_player.queue_free)

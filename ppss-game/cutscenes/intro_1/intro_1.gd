extends Control

@export_file("*.tscn", "*.scn") var _main_menu_scene: String = "res://main_menu/main_menu.tscn"

var _anim_player: AnimationPlayer
var _is_finished: bool = false

func _ready() -> void:
	_anim_player = get_node("AnimationPlayer")
	
	_anim_player.animation_finished.connect(_on_animation_finished)
	
	_anim_player.play("Logo")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Logo":
		_go_to_menu()

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or \
	   (event is InputEventKey and event.pressed):
		_go_to_menu()

func _go_to_menu() -> void:
	if _is_finished:
		return
	_is_finished = true
	
	_anim_player.animation_finished.disconnect(_on_animation_finished)
	get_tree().change_scene_to_file(_main_menu_scene)

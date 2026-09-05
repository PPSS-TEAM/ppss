extends Control

static var _init: bool = false

func _ready() -> void:
	if _init:
		await Transition.fade_out()
	else:
		_init = true

	print("_ready")

func _on_play_button_pressed() -> void:
	print("_on_play_button_pressed")

func _on_useless_button_pressed() -> void:
	print("_on_useless_button_pressed")
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


func _on_appeal_button_pressed() -> void:
	print("_on_appeal_button_pressed")
	var appeal_url := "https://t.me/appealppss/3"
	OS.shell_open(appeal_url)

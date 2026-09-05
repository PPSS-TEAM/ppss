extends Control

static var _init: bool = false

func _ready() -> void:
	if _init:
		await Transition.fade_out()
	else:
		_init = true

	print("Гитлер воскрес!")

func _on_play_button_pressed() -> void:
	print("нихуя.")

func _on_useless_button_pressed() -> void:
	print("хуй")

	await get_tree().create_timer(0.2).timeout

	print("Пошёл нахуй.")
	get_tree().quit()


func _on_appeal_button_pressed() -> void:
	print("обра")
	var appeal_url := "https://t.me/appealppss/3"
	OS.shell_open(appeal_url)

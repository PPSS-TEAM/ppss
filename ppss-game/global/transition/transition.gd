extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func fade_in(duration: float = 0.1, extra_delay: float = 0.3) -> void:
	color_rect.color.a = 0.0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration)
	await get_tree().create_timer(duration +extra_delay).timeout

func fade_out(duration: float = 0.1, extra_delay: float = 0.3) -> void:
	color_rect.color.a = 1.0
	await get_tree().create_timer(extra_delay).timeout
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, duration)
	await get_tree().create_timer(duration).timeout

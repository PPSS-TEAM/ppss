extends Node

func _center_window():
	var screen = DisplayServer.window_get_current_screen()
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var window_size = DisplayServer.window_get_size()
	
	var target_pos = screen_rect.position + (screen_rect.size - window_size) / 2
	DisplayServer.window_set_position(target_pos)

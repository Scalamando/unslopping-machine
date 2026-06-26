extends Node

## FOR DEBUG CLOSE GAME WITH ESC
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && OS.is_debug_build():
		get_tree().quit()
	elif event.is_action_pressed("give_me_money") && OS.is_debug_build():
		FinanceManager.add_money(100)
	elif event.is_action_pressed("end_level", false, true) && OS.is_debug_build():
		$"..".end_current_level()
	elif event.is_action_pressed("goto_end") && OS.is_debug_build():
		$"..".level_idx = len($"..".levels)
		$"..".end_current_level()
		$"..".next_level()

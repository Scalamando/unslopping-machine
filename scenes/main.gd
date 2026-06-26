extends Node

## FOR DEBUG CLOSE GAME WITH ESC
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && OS.is_debug_build():
		get_tree().quit()
	elif event.is_action_pressed("give_me_money") && OS.is_debug_build():
		FinanceManager.add_money(100)

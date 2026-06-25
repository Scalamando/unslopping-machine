extends Node

## FOR DEBUG CLOSE GAME WITH ESC
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && OS.is_debug_build():
		get_tree().quit()

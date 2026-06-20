extends Node2D

## FOR DEBUG CLOSE GAME WITH ESC
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

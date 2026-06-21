class_name InstructionProxy
extends Area2D

signal instruction_found

func _on_mouse_entered() -> void:
	scale = Vector2(1.2,1.2)

func _on_mouse_exited() -> void:
	scale = Vector2(1,1)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MouseButton.MOUSE_BUTTON_LEFT):
			instruction_found.emit()

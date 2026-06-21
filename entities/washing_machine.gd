class_name WashingMashine
extends Area2D

var settings : WaschingInstruction #ToDo default settings

func _on_settings_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MouseButton.MOUSE_BUTTON_LEFT):
			UiManager.show_washing_mashine_settings(self)

#TODO Flusensieb

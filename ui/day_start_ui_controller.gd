class_name DayStartUIController
extends Control

signal start_day

func _on_start_button_pressed() -> void:
	start_day.emit()
	queue_free() # delete day start scene

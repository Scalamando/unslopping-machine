class_name WashingMachineSettingsUI
extends Control

func _ready() -> void:
	UiManager.washing_maschine_ui = self # register with UiManager

func init(washing_machine : WashingMashine) -> void:
	pass
	#TODO display settings


func _on_button_pressed() -> void:
	UiManager.hide_washing_machine_settings()

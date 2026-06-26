extends Node

## spagetthi code class for UI Data traffic

# these variables have to be set by the scripts themself
var tresen_ui : TresenClothInspectionUIController
var washing_maschine_ui : WashingMachineSettingsUI

var level_end_ui : LevelEndUI

func show_inspection_tresen(cloth : Clothing) -> void:
	tresen_ui.init(cloth)
	tresen_ui.visible = true

func hide_inspection_tresen() -> void:
	tresen_ui.visible = false

func show_washing_mashine_settings(washing_machine : WashingMashine) -> void:
	washing_maschine_ui.init(washing_machine)
	washing_maschine_ui.visible = true

func hide_washing_machine_settings() -> void:
	washing_maschine_ui.visible = false

func show_level_end_ui(stats: Stats) -> void:
	washing_maschine_ui.visible = false
	tresen_ui.visible = false
	level_end_ui.init(stats)
	level_end_ui.visible = true

func hide_level_end_ui() -> void:
	level_end_ui.visible = false

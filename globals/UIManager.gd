class_name UIManager
extends Node

## spagetthi code class for UI Data traffic

# these variables have to be set by the scripts themself
var tresen_ui : TresenClothInspectionUIController
var washing_maschine_ui : Control
var active_ui_pop_up : Control

func show_inspection_tresen(cloth : Clothing) -> void:
	tresen_ui.init(cloth)
	tresen_ui.visible = true

func hide_inspection_tresen() -> void:
	tresen_ui.visible = false

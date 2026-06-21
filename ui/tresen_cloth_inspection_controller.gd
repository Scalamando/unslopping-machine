class_name TresenClothInspectionUIController
extends Control
@onready var cloth_pos: Control = %ClothPos

func _ready() -> void:
	UiManager.tresen_ui = self # register with ui manager

func init(cloth : Clothing) -> void:
	## clean up children
	for n in cloth_pos.get_children():
		cloth_pos.remove_child(n)
		n.queue_free()
	
	## add cloth scene
	var node : Node = cloth.spread_out_scene.instantiate()
	cloth_pos.add_child(node)


func _on_button_pressed() -> void:
	UiManager.hide_inspection_tresen()

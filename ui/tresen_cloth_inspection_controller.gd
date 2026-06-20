class_name TresenClothInspectionUIController
extends Control
@onready var cloth_pos: Control = %ClothPos

func init(cloth : Clothing):
	## clean up children
	for n in cloth_pos.get_children():
		cloth_pos.remove_child(n)
		n.queue_free()
	
	## add new child scene
	var node = cloth.spread_out_scene.instantiate()
	cloth_pos.add_child(node)

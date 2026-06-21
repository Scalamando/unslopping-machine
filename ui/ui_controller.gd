extends Control

@onready var tresen_cloth_inspection: TresenClothInspectionUIController = %TresenClothInspection
@export var test_cloth : Clothing 


func show_inspection_tresen(cloth : Clothing):
	tresen_cloth_inspection.init(cloth)
	tresen_cloth_inspection.visible = true

func hide_inspection_tresen():
	tresen_cloth_inspection.visible = false

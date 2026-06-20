extends Control

@onready var tresen_cloth_inspection: TresenClothInspectionUIController = %TresenClothInspection
@export var test_cloth : Clothing 

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	show_inspection_tresen(test_cloth)

func show_inspection_tresen(cloth : Clothing):
	tresen_cloth_inspection.init(cloth)
	tresen_cloth_inspection.visible = true

func hide_inspection_tresen():
	tresen_cloth_inspection.visible = false

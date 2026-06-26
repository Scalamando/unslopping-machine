class_name ClothInspectionController
extends Control

@export var instructions_proxy: InstructionProxy

func _ready() -> void:
	assert(instructions_proxy != null)

class_name TresenClothInspectionUIController
extends Control

var display_cloth : Clothing

@onready var cloth_pos: Control = %ClothPos
@onready var instructions: ColorRect = %Instructions

@export_group("Washing Instruction Icons")
@export var speed_slow : Texture
@export var speed_med : Texture
@export var speed_fast : Texture


@onready var temp_med: TextureRect = %TempMed
@onready var temp_high: TextureRect = %TempHigh


@export var dir_clockwise : Texture
@export var dir_counterclockwise : Texture



@onready var dir_tex_rect: TextureRect = %DirTexRect
@onready var speed_tex_rect: TextureRect = %SpeedTexRect

func _ready() -> void:
	UiManager.tresen_ui = self # register with ui manager

func init(cloth : Clothing) -> void:
	instructions.visible = false

	## clean up children
	for n in cloth_pos.get_children():
		cloth_pos.remove_child(n)
		n.queue_free()

	## add new cloth
	display_cloth = cloth
	var cloth_inspection_controller : ClothInspectionController = cloth.spread_out_scene.instantiate()
	cloth_pos.add_child(cloth_inspection_controller)

	cloth_inspection_controller.instructions_proxy.instruction_found.connect(show_instructions)


func _on_button_pressed() -> void:
	UiManager.hide_inspection_tresen()
	display_cloth = null

func show_instructions() -> void:
	assert(display_cloth != null)
	instructions.visible = true

	match display_cloth.wash_instructions.temperature:
		WaschingInstruction.Temperature.cold:
			temp_med.visible = false
			temp_high.visible = false
		WaschingInstruction.Temperature.medium:
			temp_med.visible = true
			temp_high.visible = false
		WaschingInstruction.Temperature.hot:
			temp_med.visible = true
			temp_high.visible = true
	
	dir_tex_rect.visible = true
	match display_cloth.wash_instructions.direction:
		WaschingInstruction.Direction.clockwise:
			dir_tex_rect.texture = dir_clockwise
		WaschingInstruction.Direction.counterclockwise:
			dir_tex_rect.texture = dir_counterclockwise
		WaschingInstruction.Direction.both:
			dir_tex_rect.visible = false

	match display_cloth.wash_instructions.speed:
		WaschingInstruction.Speed.slow:
			speed_tex_rect.texture = speed_slow
		WaschingInstruction.Speed.medium:
			speed_tex_rect.texture = speed_med
		WaschingInstruction.Speed.fast:
			speed_tex_rect.texture = speed_fast

class_name Cloth
extends Area2D
@onready var sprite_2d: Sprite2D = %Sprite2D

var cloth_data : Clothing

func load_data(cloth : Clothing) -> void:
	cloth_data = cloth

func _ready() -> void:
	sprite_2d.texture = cloth_data.dirty_texture

func get_state() -> Clothing.State:
	return cloth_data.state

func apply_wash(temperature: WaschingInstruction.Temperature, speed: int, direction: WaschingInstruction.Direction) -> Clothing.State:
	var state : Clothing.State = cloth_data.apply_wash(temperature, speed, direction)
	sprite_2d.texture = cloth_data.get_texture()
	return state

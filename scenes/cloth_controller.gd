class_name Cloth
extends Area2D
@onready var sprite_2d: Sprite2D = %Sprite2D

var clothing : Clothing
var customer : Customer

const cloth_scene = preload("res://entities/cloth.tscn")

static func create(state: Clothing, customer: Customer) -> Cloth:
	var new_scene : Cloth = cloth_scene.instantiate()
	new_scene.clothing = state
	new_scene.customer = customer
	return new_scene

func _ready() -> void:
	sprite_2d.texture = clothing.texture_dirty

func get_state() -> Clothing.State:
	return clothing.state

func apply_wash(temperature: WaschingInstruction.Temperature, speed: int, direction: WaschingInstruction.Direction) -> Clothing.State:
	var state : Clothing.State = clothing.apply_wash(temperature, speed, direction)
	sprite_2d.texture = clothing.get_texture()
	return state

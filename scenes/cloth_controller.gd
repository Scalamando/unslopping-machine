class_name Cloth
extends Area2D

@onready var sprite_2d: Sprite2D = %Sprite2D
const cloth_scene = preload("res://entities/cloth.tscn")

enum State {dirty, clean, soaked, ripped, shrunk, iced, garn}

var state : State = State.dirty
var clothing : Clothing
var customer : Customer

static func create(clothing: Clothing, customer_: Customer) -> Cloth:
	var new_scene : Cloth = cloth_scene.instantiate()
	new_scene.clothing = clothing
	new_scene.customer = customer_
	return new_scene

func _ready() -> void:
	sprite_2d.texture = clothing.texture_dirty

func get_state() -> State:
	return state

func apply_wash(temperature: WaschingInstruction.Temperature, speed: int, direction: WaschingInstruction.Direction) -> State:
	state = _state_for_wash(temperature, speed, direction)
	sprite_2d.texture = clothing.get_texture()
	return state

func get_texture() -> Texture:
	match state:
		State.dirty: return clothing.texture_dirty
		State.clean: return clothing.texture_clean
		State.soaked: return clothing.texture_soaked
		State.ripped: return clothing.texture_ripped
		State.shrunk: return clothing.texture_shrunk
		State.iced: return clothing.texture_iced
		State.garn: return clothing.texture_garn
		_: return clothing.texture_dirty

func _state_for_wash(temperature: WaschingInstruction.Temperature, speed: int, direction: WaschingInstruction.Direction) -> State:
	if temperature > clothing.wash_instructions.temperature:
		return State.shrunk
	if temperature < clothing.wash_instructions.temperature:
		return State.iced

	if clothing.wash_instructions.direction != WaschingInstruction.Direction.both and direction != clothing.wash_instructions.direction:
		return State.garn

	match clothing.wash_instructions.speed:
		WaschingInstruction.Speed.slow:
			if speed < clothing.wash_instructions.speed:
				return State.soaked
			elif speed >= WaschingInstruction.Speed.medium:
				return State.ripped
		WaschingInstruction.Speed.medium:
			if speed < clothing.wash_instructions.speed:
				return State.soaked
			elif speed >= WaschingInstruction.Speed.fast:
				return State.ripped
		WaschingInstruction.Speed.fast:
			if speed < clothing.wash_instructions.speed:
				return State.soaked
			elif speed >= WaschingInstruction.Speed.too_fast:
				state = State.ripped
				return state

	return State.clean

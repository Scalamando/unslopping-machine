class_name Cloth
extends Area2D

@export var soaked_material : Material
@export var ripped_material : Material
@export var scale_normal : Vector2 = Vector2(0.35, 0.35)
@export var scale_shrunk : Vector2 = Vector2(0.1, 0.1)

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var iced_sprite_2d: Sprite2D = %IcedSprite2D

const cloth_scene = preload("res://entities/cloth.tscn")

enum State {dirty, clean, soaked, ripped, shrunk, iced, garn}

var state : State = State.dirty
var clothing : Clothing
var customer : CustomerProfile

static func create(clothing: Clothing, customer_: CustomerProfile) -> Cloth:
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
	sprite_2d.texture = _get_texture()

	# iced overlay
	if state == State.iced:
		iced_sprite_2d.visible = true
	else:
		iced_sprite_2d.visible = false

	if state == State.soaked:
		sprite_2d.material = soaked_material
	elif state == State.ripped:
		sprite_2d.material = ripped_material
	else:
		sprite_2d.material = null

	if state == State.shrunk:
		sprite_2d.scale = scale_shrunk
	else:
		sprite_2d.scale = scale_normal

	return state

func _get_texture() -> Texture:
	match state:
		State.dirty: return clothing.texture_dirty
		State.clean: return clothing.texture_clean
		State.soaked: return clothing.texture_spread_out
		State.ripped: return clothing.texture_spread_out
		State.shrunk: return clothing.texture_spread_out
		State.iced: return clothing.texture_dirty
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

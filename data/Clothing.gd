class_name Clothing
extends Resource

enum State {dirty, clean, soaked, ripped, shrunk, iced, garn}

@export var dirty_texture : Texture
@export var clean_texture : Texture
@export var soaked_texture : Texture
@export var ripped_texture : Texture
@export var shrunk_texture : Texture
@export var iced_texture : Texture
@export var garn_texture : Texture
@export var spread_out_texture : Texture
@export var spread_out_scene : PackedScene
@export var wash_instructions : WaschingInstruction

var state : State = State.dirty

func get_texture() -> Texture:
	match state:
		State.dirty: return dirty_texture
		State.clean: return clean_texture
		State.soaked: return soaked_texture
		State.ripped: return ripped_texture
		State.shrunk: return shrunk_texture
		State.iced: return iced_texture
		State.garn: return garn_texture
		_: return dirty_texture

func apply_wash(temperature: WaschingInstruction.Temperature, speed: int, direction: WaschingInstruction.Direction) -> State:
	if temperature > wash_instructions.temperature:
		state = State.shrunk
		return state
	if temperature < wash_instructions.temperature:
		state = State.iced
		return state

	if wash_instructions.direction != WaschingInstruction.Direction.both and direction != wash_instructions.direction:
		state = State.garn
		return state

	match wash_instructions.speed:
		WaschingInstruction.Speed.slow:
			if speed < wash_instructions.speed:
				state = State.soaked
				return state
			elif speed >= WaschingInstruction.Speed.medium:
				state = State.ripped
				return state
		WaschingInstruction.Speed.medium:
			if speed < wash_instructions.speed:
				state = State.soaked
				return state
			elif speed >= WaschingInstruction.Speed.fast:
				state = State.ripped
				return state
		WaschingInstruction.Speed.fast:
			if speed < wash_instructions.speed:
				state = State.soaked
				return state

	state = State.clean
	return state

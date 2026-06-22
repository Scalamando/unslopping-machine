class_name Clothing
extends Resource

enum State {dirty, clean, soaked, ripped, shrunk, iced, garn}

@export var wash_instructions : WaschingInstruction

@export_range(0, 200, 1) var value : int = 50

@export_group("Textures", "texture_")
@export var texture_dirty : Texture
@export var texture_clean : Texture
@export var texture_soaked : Texture
@export var texture_ripped : Texture
@export var texture_shrunk : Texture
@export var texture_iced : Texture
@export var texture_garn : Texture
@export var texture_spread_out : Texture

@export var spread_out_scene : PackedScene

var state : State = State.dirty

func get_texture() -> Texture:
	match state:
		State.dirty: return texture_dirty
		State.clean: return texture_clean
		State.soaked: return texture_soaked
		State.ripped: return texture_ripped
		State.shrunk: return texture_shrunk
		State.iced: return texture_iced
		State.garn: return texture_garn
		_: return texture_dirty

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

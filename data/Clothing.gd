class_name Clothing
extends Resource

enum State {dirty, clean, soaked, ripped, shrunk, iced, garn}

@export var folded_texture : Texture
@export var spread_out_scene : PackedScene
@export var wash_instructions : WaschingInstruction

var state : State = State.dirty

func apply_wash(temperature: WaschingInstruction.Temperature, speed: int, direction: WaschingInstruction.Direction) -> State:
	if temperature > wash_instructions.temperature:
		state = State.shrunk
		return state
	if temperature < wash_instructions.temperature:
		state = State.iced
		return state

	if direction != wash_instructions.direction:
		state = State.garn
		return state

	match speed:
		WaschingInstruction.Speed.slow:
			if speed < wash_instructions.speed:
				state = State.soaked
			elif speed >= WaschingInstruction.Speed.medium:
				state = State.ripped
		WaschingInstruction.Speed.medium:
			if speed < wash_instructions.speed:
				state = State.soaked
			elif speed >= WaschingInstruction.Speed.fast:
				state = State.ripped
		WaschingInstruction.Speed.fast:
			if speed < wash_instructions.speed:
				state = State.soaked

	return state

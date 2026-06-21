class_name WashingMashine
extends Area2D

signal finished_wash

enum Direction {clockwise, counterclockwise}

@onready var temperature_rect: ColorRect = %TemperatureRect
@onready var speed_label: Label = %SpeedLabel
@onready var direction_texture_rect: TextureRect = %DirectionTextureRect
@onready var indicator_texture_rect: TextureRect = %IndicatorTextureRect
@onready var cloth_container: Node2D = %ClothContainer
@onready var wasching_timer: Timer = %WaschingTimer

var running: bool :
	get:
		return not wasching_timer.is_stopped()
	set(value):
		pass

const DIR_CLOCKWISE = preload("uid://bl0cqry5dllwh")
const DIR_COUNTERCLOCKWISE = preload("uid://cjjdrak1g00mr")

@export var speed : int = 0 :
	get: return speed
	set(value):
		speed = value
		if speed_label:
			_set_speed_label(value)

@export var temperature : WaschingInstruction.Temperature = WaschingInstruction.Temperature.hot :
	get: return temperature
	set(value):
		temperature = value
		if temperature_rect:
			_set_temperature_rect(value)

@export var direction : Direction = Direction.clockwise :
	get: return direction
	set(value):
		direction = value
		if direction_texture_rect:
			_set_direction_texture_rect(value)

func _ready() -> void:
	_set_speed_label(speed)
	_set_temperature_rect(temperature)
	_set_direction_texture_rect(direction)

func _on_settings_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton):
		if (event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT):
			UiManager.show_washing_mashine_settings(self)

func _set_speed_label(value : int) -> void:
	speed_label.text = str(value) + " RPM"

func _set_temperature_rect(value : WaschingInstruction.Temperature) -> void:
	match value:
		WaschingInstruction.Temperature.cold:
			temperature_rect.color = Color(0, 0, 255, 0.5)
		WaschingInstruction.Temperature.medium:
			temperature_rect.color = Color(255, 128, 0, 0.5)
		WaschingInstruction.Temperature.hot:
			temperature_rect.color = Color(255, 0, 0, 0.5)

func _set_direction_texture_rect(value : Direction) -> void:
	match value:
		Direction.clockwise:
			direction_texture_rect.texture = DIR_CLOCKWISE
		Direction.counterclockwise:
			direction_texture_rect.texture = DIR_COUNTERCLOCKWISE

func start_washing() -> void:
	for child in cloth_container.get_children():
		if child is Cloth:
			child.input_pickable = false
	indicator_texture_rect.visible = true
	wasching_timer.start()
	wasching_timer.timeout.connect(end_washing)

func end_washing() -> void:
	for child in cloth_container.get_children():
		if child is Cloth:
			child.cloth_data.apply_wash(temperature, speed, direction)
	indicator_texture_rect.visible = false
	finished_wash.emit()

#TODO Flusensieb

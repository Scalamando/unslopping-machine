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

@onready var foreground_open: AnimatedSprite2D = $ForegroundOpen
@onready var background: AnimatedSprite2D = %Background
@onready var base: AnimatedSprite2D = %Base
@onready var foreground_closed: AnimatedSprite2D = %ForegroundClosed

@onready var wasching_animation_player: AnimationPlayer = %WaschingAnimationPlayer

var running: bool :
	get:
		return not wasching_timer.is_stopped()
	set(value):
		pass

const DIR_CLOCKWISE = preload("uid://bpt7t56s24pkn")
const DIR_COUNTERCLOCKWISE = preload("uid://cjcqvkh4x85u2")

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
	wasching_timer.timeout.connect(end_washing)

@onready var starting_pos : Vector2 = self.position

func _process(delta: float) -> void:
	if self.running:
		var time = (Time.get_ticks_msec() / 1000.0) * (speed / 20.0);
		var wobbling = sin(time) * (speed / 3600.0);
		var direction = sin(time / 2.);
		self.position += Vector2(direction * wobbling,wobbling);
	else:
		self.position = starting_pos

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

func start_washing() -> bool:
	var cloths = cloth_container.get_children().filter(func(child: Node) -> bool: return child is Cloth)

	var has_unwashable_cloths : bool = cloths.any(func(c: Cloth) -> bool: return c.get_state() != Cloth.State.dirty)
	if has_unwashable_cloths:
		return false

	for c : Cloth in cloths:
		c.input_pickable = false

	# disable the dropzone
	self.collision_layer = 0

	indicator_texture_rect.visible = true
	foreground_open.visible = false
	foreground_closed.visible = true
	wasching_timer.start()

	wasching_animation_player.play("new_animation")
	wasching_animation_player.speed_scale = speed / 100.0

	return true

func end_washing() -> void:
	for child in cloth_container.get_children():
		if child is Cloth:
			child.apply_wash(temperature, speed, direction)
			child.input_pickable = true

	# re-enable the dropzone
	self.collision_layer = 1


	wasching_animation_player.play("RESET")
	indicator_texture_rect.visible = false
	foreground_open.visible = true
	foreground_closed.visible = false
	finished_wash.emit()

#TODO Flusensieb

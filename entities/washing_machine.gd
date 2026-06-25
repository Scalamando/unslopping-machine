class_name WashingMashine
extends Area2D

signal finished_wash

enum Direction {clockwise, counterclockwise}

@onready var temp_med: Sprite2D = %TempMed
@onready var temp_high: Sprite2D = %TempHigh

const heat_on = preload("uid://bj2f6c78jjfc7")
const heat_off = preload("uid://c3pir06gj8apv")

@onready var speed_indicator: Node2D = %SpeedIndicator

@onready var direction_texture_rect: TextureRect = %DirectionTextureRect
@onready var cloth_container: Node2D = %ClothContainer
@onready var wasching_timer: Timer = %WaschingTimer

@onready var foreground_open: AnimatedSprite2D = $ForegroundOpen
@onready var background: AnimatedSprite2D = %Background
@onready var base: AnimatedSprite2D = %Base
@onready var foreground_closed: AnimatedSprite2D = %ForegroundClosed

@onready var wasching_animation_player: AnimationPlayer = %WaschingAnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D

@onready var ui_start_red: Sprite2D = %UiStartRed
@onready var ui_start_yellow: Sprite2D = %UiStartYellow


const WASHING_MACHINE_FAST = preload("res://assets/audio/washing_machine/WashingMachine_Fast.mp3")
const WASHING_MACHINE_MEDIUM = preload("res://assets/audio/washing_machine/WashingMachine_Medium.mp3")
const WASHING_MACHINE_SLOW = preload("res://assets/audio/washing_machine/WashingMachine_Slow.mp3")

const DIR_CLOCKWISE = preload("uid://dfiy3v5mak80d")
const DIR_COUNTERCLOCKWISE = preload("uid://yr8w6tf37am5")

var running: bool :
	get:
		return not wasching_timer.is_stopped()
	set(value):
		pass

var has_unwashable_cloths: bool :
	get:
		var cloths = cloth_container.get_children().filter(func(child: Node) -> bool: return child is Cloth)
		return cloths.any(func(c: Cloth) -> bool: return c.state != Cloth.State.dirty)
	set(value):
		pass

@export var speed : int = 0 :
	get: return speed
	set(value):
		speed = value
		set_speed_pointer(value)

@export var temperature : WaschingInstruction.Temperature = WaschingInstruction.Temperature.hot :
	get: return temperature
	set(value):
		temperature = value
		_set_temperature_rect(value)

@export var direction : Direction = Direction.clockwise :
	get: return direction
	set(value):
		direction = value
		if direction_texture_rect:
			_set_direction_texture_rect(value)

func _ready() -> void:
	set_speed_pointer(speed)
	_set_temperature_rect(temperature)
	_set_direction_texture_rect(direction)
	wasching_timer.timeout.connect(end_washing)

@onready var starting_pos : Vector2 = self.position

func set_speed_pointer(speed_ : float) -> void:
	speed_indicator.rotation_degrees = remap(speed_, 0.0, 3000.0, -37.9, 42.0)

func _process(_delta: float) -> void:
	if self.running:
		var time : float = (Time.get_ticks_msec() / 1000.0) * (speed / 20.0);
		var wobbling : float = sin(time) * (speed / 3600.0);
		var direction_ : float = sin(time / 2.);
		self.position += Vector2(direction_ * wobbling,wobbling);
	else:
		self.position = starting_pos

func _on_settings_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton):
		if (event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT):
			UiManager.show_washing_mashine_settings(self)


func _set_temperature_rect(value : WaschingInstruction.Temperature) -> void:
	match value:
		WaschingInstruction.Temperature.cold:
			temp_med.texture = heat_off
			temp_high.texture = heat_off
		WaschingInstruction.Temperature.medium:
			temp_med.texture = heat_on
			temp_high.texture = heat_off
		WaschingInstruction.Temperature.hot:
			temp_med.texture = heat_on
			temp_high.texture = heat_on

func _set_direction_texture_rect(value : Direction) -> void:
	match value:
		Direction.clockwise:
			direction_texture_rect.texture = DIR_CLOCKWISE
		Direction.counterclockwise:
			direction_texture_rect.texture = DIR_COUNTERCLOCKWISE

func start_washing() -> bool:
	var cloths : Array[Node] = cloth_container.get_children().filter(func(child: Node) -> bool: return child is Cloth)

	if has_unwashable_cloths:
		ui_start_yellow.visible = true
		return false
	
	ui_start_yellow.visible = false

	for c : Cloth in cloths:
		c.input_pickable = false

	# disable the dropzone
	self.collision_layer = 0

	ui_start_red.visible = true
	foreground_open.visible = false
	foreground_closed.visible = true
	wasching_timer.start()



	if speed < WaschingInstruction.Speed.medium:
		audio_stream_player_2d.stream = WASHING_MACHINE_SLOW
	elif speed >= WaschingInstruction.Speed.fast:
		audio_stream_player_2d.stream = WASHING_MACHINE_MEDIUM
	else:
		audio_stream_player_2d.stream = WASHING_MACHINE_FAST

	audio_stream_player_2d.play()
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
	audio_stream_player_2d.stop()
	ui_start_red.visible = false
	foreground_open.visible = true
	foreground_closed.visible = false
	finished_wash.emit()

#TODO Flusensieb

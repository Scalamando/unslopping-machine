class_name WashingMachineSettingsUI
extends Control

var current_washing_machine : WashingMashine

@onready var temperature_cold_button: Button = %Cold
@onready var temperature_medium_button: Button = %Medium
@onready var temperature_hot_button: Button = %Hot

@onready var direction_button: Button = %DirectionButton

@onready var start_button: Button = %StartButton
@onready var start_button_red: TextureRect = %StartButtonRed
@onready var start_button_yellow: TextureRect = %StartButtonYellow

@onready var speed_crank: SpeedCrankController = %SpeedCrank
@onready var speed_indicator: Control = %SpeedIndicator

const DIR_CLOCKWISE = preload("uid://bpt7t56s24pkn")
const DIR_COUNTERCLOCKWISE = preload("uid://cjcqvkh4x85u2")

const HEAT_OFF = preload("uid://cax2bq2ok7oq7")
const HEAT_ON = preload("uid://da10pbbqmxpl4")

func _ready() -> void:
	UiManager.washing_maschine_ui = self # register with UiManager
	
	speed_crank.speed_changed.connect(_on_speed_updated)

func _on_speed_updated(speed : float) -> void:
	set_speed_pointer(speed)
	current_washing_machine.speed = round(speed)

func init(washing_machine : WashingMashine) -> void:
	if current_washing_machine != null:
		current_washing_machine.finished_wash.disconnect(_on_wash_end)

	current_washing_machine = washing_machine

	if not current_washing_machine.finished_wash.is_connected(_on_wash_end):
		current_washing_machine.finished_wash.connect(_on_wash_end)

	match current_washing_machine.temperature:
		WaschingInstruction.Temperature.cold:
			_on_cold_pressed()
		WaschingInstruction.Temperature.medium:
			_on_medium_pressed()
		WaschingInstruction.Temperature.hot:
			_on_hot_pressed()

	match current_washing_machine.direction:
		WashingMashine.Direction.clockwise:
			direction_button.add_theme_icon_override("icon", DIR_CLOCKWISE)
		WashingMashine.Direction.counterclockwise:
			direction_button.add_theme_icon_override("icon", DIR_COUNTERCLOCKWISE)

	set_speed_pointer(float(current_washing_machine.speed))
	_on_speed_value_changed(float(current_washing_machine.speed))

	# start_button.visible = not current_washing_machine.running
	start_button_red.visible = current_washing_machine.running


func _on_button_pressed() -> void:
	UiManager.hide_washing_machine_settings()


func _on_cold_pressed() -> void:
	current_washing_machine.temperature = WaschingInstruction.Temperature.cold
	temperature_medium_button.icon = HEAT_OFF
	temperature_hot_button.icon = HEAT_OFF


func _on_medium_pressed() -> void:
	current_washing_machine.temperature = WaschingInstruction.Temperature.medium
	temperature_medium_button.icon = HEAT_ON
	temperature_hot_button.icon = HEAT_OFF


func _on_hot_pressed() -> void:
	current_washing_machine.temperature = WaschingInstruction.Temperature.hot
	temperature_medium_button.icon = HEAT_ON
	temperature_hot_button.icon = HEAT_ON


func _on_speed_value_changed(value: float) -> void:
	current_washing_machine.speed = round(value)


func _on_direction_button_pressed() -> void:
	match current_washing_machine.direction:
		WashingMashine.Direction.clockwise:
			current_washing_machine.direction = WashingMashine.Direction.counterclockwise
			direction_button.add_theme_icon_override("icon", DIR_COUNTERCLOCKWISE)
		WashingMashine.Direction.counterclockwise:
			current_washing_machine.direction = WashingMashine.Direction.clockwise
			direction_button.add_theme_icon_override("icon", DIR_CLOCKWISE)

func set_speed_pointer(speed : float) -> void:
	speed_indicator.rotation_degrees = remap(speed, 800.0, 3200.0, -21.2, 22.5)


func _on_start_button_pressed() -> void:
	var started_washing : bool = current_washing_machine.start_washing()
	if not started_washing:
		return

	start_button.disabled = true
	start_button_red.visible = true

func _on_wash_end() -> void:
	start_button.disabled = false
	start_button_red.visible = false

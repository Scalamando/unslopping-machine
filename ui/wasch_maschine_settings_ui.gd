class_name WashingMachineSettingsUI
extends Control

var current_washing_machine : WashingMashine

var button_style : StyleBoxFlat = StyleBoxFlat.new()

@onready var speed_slider: HSlider = %SpeedSlider
@onready var speed_label: Label = %SpeedLabel

@onready var temperature_cold_button: Button = %Cold
@onready var temperature_medium_button: Button = %Medium
@onready var temperature_hot_button: Button = %Hot
@onready var indicator_texture_rect: TextureRect = %IndicatorTextureRect

@onready var direction_button: Button = %DirectionButton
@onready var start_button: Button = %StartButton

const DIR_CLOCKWISE = preload("uid://bl0cqry5dllwh")
const DIR_COUNTERCLOCKWISE = preload("uid://cjjdrak1g00mr")


func _ready() -> void:
	UiManager.washing_maschine_ui = self # register with UiManager

	temperature_cold_button.add_theme_stylebox_override("normal", button_style)
	temperature_medium_button.add_theme_stylebox_override("normal", button_style)
	temperature_hot_button.add_theme_stylebox_override("normal", button_style)

	temperature_cold_button.add_theme_stylebox_override("hover", button_style)
	temperature_medium_button.add_theme_stylebox_override("hover", button_style)
	temperature_hot_button.add_theme_stylebox_override("hover", button_style)

func init(washing_machine : WashingMashine) -> void:
	current_washing_machine = washing_machine

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

	speed_slider.value = float(current_washing_machine.speed)
	_on_speed_value_changed(float(current_washing_machine.speed))

	print(current_washing_machine.running)
	start_button.visible = not current_washing_machine.running
	indicator_texture_rect.visible = current_washing_machine.running


func _on_button_pressed() -> void:
	UiManager.hide_washing_machine_settings()


func _on_cold_pressed() -> void:
	current_washing_machine.temperature = WaschingInstruction.Temperature.cold
	button_style.bg_color = Color(0, 0, 255, 0.5)


func _on_medium_pressed() -> void:
	current_washing_machine.temperature = WaschingInstruction.Temperature.medium
	button_style.bg_color = Color(255, 128, 0, 0.5)


func _on_hot_pressed() -> void:
	current_washing_machine.temperature = WaschingInstruction.Temperature.hot
	button_style.bg_color = Color(255, 0, 0, 0.5)


func _on_speed_value_changed(value: float) -> void:
	current_washing_machine.speed = round(value)
	speed_label.text = str(current_washing_machine.speed) + " RPM"


func _on_direction_button_pressed() -> void:
	match current_washing_machine.direction:
		WashingMashine.Direction.clockwise:
			current_washing_machine.direction = WashingMashine.Direction.counterclockwise
			direction_button.add_theme_icon_override("icon", DIR_COUNTERCLOCKWISE)
		WashingMashine.Direction.counterclockwise:
			current_washing_machine.direction = WashingMashine.Direction.clockwise
			direction_button.add_theme_icon_override("icon", DIR_CLOCKWISE)


func _on_start_button_pressed() -> void:
	start_button.visible = false
	indicator_texture_rect.visible = true
	current_washing_machine.start_washing()
	current_washing_machine.finished_wash.connect(_on_wash_end)

func _on_wash_end() -> void:
	start_button.visible = true
	indicator_texture_rect.visible = false

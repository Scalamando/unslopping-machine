class_name SpeedCrankController
extends Control

signal speed_changed(speed : int)

@onready var anchor: Control = %Anchor
@onready var line_2d: Line2D = $Line2D
@onready var speed_label: Label = %SpeedLabel

@export var SPEED_CRANK_MULTIPLIER : float = 8
@export var SPEED_CRANK_FALLOFF : float = 0.005

const MAX_SPEED : int = 3000

var cranking : bool = false
var current_angle : float = NAN
var prev_angle : float = NAN

var avg_speed : float = 0

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_enter)
	self.mouse_exited.connect(_on_mouse_exit)

func _on_mouse_enter() -> void:
	self.modulate = Color(1.1, 1.1, 1.1, 1)

func _on_mouse_exit() -> void:
	self.modulate = Color(1, 1, 1, 1)


func _on_crank_input(event: InputEvent) -> void:
	
	if event is InputEventMouse:
		if event.is_action_pressed("draggable_click"):
			cranking = true
		elif event.is_action_released("draggable_click"):
			cranking = false
			prev_angle = NAN
		
		if cranking:
			current_angle = angle_to_center(event.position)
			anchor.rotation_degrees = current_angle

func _process(delta: float) -> void:
	if (is_nan(current_angle) || not cranking):
		return
	
	if (is_nan(prev_angle)) :
		prev_angle = current_angle
		return
	
	var speed : float = abs(current_angle - prev_angle)
	
	if (speed > 180): # angles jumped from ~ -180 to 180
		speed -= 360
	
	speed *=  0.1 * SPEED_CRANK_MULTIPLIER / delta
	
	avg_speed = min(lerp(avg_speed, speed, SPEED_CRANK_FALLOFF), MAX_SPEED) 
	speed_label.text = str(avg_speed)
	
	speed_changed.emit(avg_speed)
	
	prev_angle = current_angle

func angle_to_center(mouse_pos : Vector2) -> float:
	var direction : Vector2 = (mouse_pos - anchor.position)
	return rad_to_deg(direction.angle())

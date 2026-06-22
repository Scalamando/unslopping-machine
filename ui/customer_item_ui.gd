class_name CustomerItemUI
extends PanelContainer

signal timeout

const customer_item_ui_scene = preload("res://ui/customer_item_ui.tscn")

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var cloth_texture: TextureRect = %ClothTexture

@export var warning_stylebox: StyleBoxFlat
@export var critical_stylebox: StyleBoxFlat

var customer_queue_item : CustomerQueueItem
var start_time_msec : int
var timed_out : bool = false

static func create(queue_item: CustomerQueueItem) -> CustomerItemUI:
	var new_scene : CustomerItemUI = customer_item_ui_scene.instantiate()
	new_scene.customer_queue_item = queue_item
	return new_scene

func _ready() -> void:
	self.cloth_texture.texture = customer_queue_item.customer.clothing.spread_out_texture
	self.progress_bar.max_value = customer_queue_item.timeout_at_msec - Time.get_ticks_msec()

func _process(_delta: float) -> void:
	if timed_out or customer_queue_item == null: return

	var new_value : int = max(0, customer_queue_item.timeout_at_msec - Time.get_ticks_msec())
	progress_bar.value = new_value

	if progress_bar.value < progress_bar.max_value * 0.25:
		progress_bar.add_theme_stylebox_override("fill", critical_stylebox)
	elif progress_bar.value < progress_bar.max_value * 0.5:
		progress_bar.add_theme_stylebox_override("fill", warning_stylebox)

	if new_value <= 0:
		timed_out = true
		timeout.emit()

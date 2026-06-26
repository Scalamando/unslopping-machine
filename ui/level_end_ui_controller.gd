class_name LevelEndUI
extends Control

signal start_next_level

@onready var time_used_value: Label = %TimeUsedValue
@onready var money_made_value: Label = %MoneyMadeValue
@onready var cloth_finished_value: Label = %ClothFinishedValue
@onready var cloth_timedout_value: Label = %ClothTimedoutValue
@onready var money_left_label: Label = %MoneyLeftLabel

func _ready() -> void:
	UiManager.level_end_ui = self # register with ui manager

func init(stats: Stats) -> void:
	# time
	var minutes : int = floor(stats.time_used_msec / 1000.0 / 60.0)
	var seconds : int = int(floor(stats.time_used_msec / 1000.0)) % 60
	time_used_value.text = "%s minutes and %s seconds" % [minutes, seconds]

	money_made_value.text = str(stats.money_made)
	cloth_finished_value.text = str(stats.finished_cloth)
	cloth_timedout_value.text = str(stats.timedout_cloth)

	money_left_label.text = "You need to collect %s more $$\nto make grandma proud." % (1000 - stats.money_made_total)


func _on_next_level_button_pressed() -> void:
	start_next_level.emit()

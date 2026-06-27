class_name LevelEndUI
extends Control

signal start_next_level

@onready var title_label: Label = %TitleLabel
@onready var time_used_value: Label = %TimeUsedValue
@onready var money_made_value: Label = %MoneyMadeValue
@onready var cloth_finished_value: Label = %ClothFinishedValue
@onready var cloth_timedout_value: Label = %ClothTimedoutValue
@onready var money_left_label: Label = %MoneyLeftLabel
@onready var cloth_soaked_value: Label = %ClothSoakedValue
@onready var cloth_ripped_value: Label = %ClothRippedValue
@onready var cloth_iced_value: Label = %ClothIcedValue
@onready var cloth_shrunk_value: Label = %ClothShrunkValue
@onready var cloth_garn_value: Label = %ClothGarnValue

func _ready() -> void:
	UiManager.level_end_ui = self # register with ui manager

func init(day: int, stats: Stats, win_threshold: int) -> void:
	title_label.text = "Day %s Finished" % day

	# time
	var minutes : int = floor(stats.time_used_msec / 1000.0 / 60.0)
	var seconds : int = int(floor(stats.time_used_msec / 1000.0)) % 60
	time_used_value.text = "%s minutes and %s seconds" % [minutes, seconds]

	money_made_value.text = str(stats.money_made)
	cloth_finished_value.text = str(stats.finished_cloth)
	cloth_timedout_value.text = str(stats.timedout_cloth)
	cloth_soaked_value.text = str(stats.cloth_soaked)
	cloth_ripped_value.text = str(stats.cloth_ripped)
	cloth_iced_value.text = str(stats.cloth_iced)
	cloth_shrunk_value.text = str(stats.cloth_shrunk)
	cloth_garn_value.text = str(stats.cloth_garn)

	if stats.money_made_total < win_threshold:
		money_left_label.text = "I still need to collect $%s til the end\nof the week to make grandma proud." % (win_threshold - stats.money_made_total)
	else:
		money_left_label.text = "I got $%s.\nThat's all the money I need to make grandma proud!" % (stats.money_made_total)


func _on_next_level_button_pressed() -> void:
	start_next_level.emit()

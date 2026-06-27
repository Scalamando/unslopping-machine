class_name LevelManager
extends Node2D

@export var levels : Array[LevelRes]

@export_group("refs")
@export var customer_manager : CustomerManager
@export var Camera : Camera2D
@export var washing_machines : Array[Area2D]
@export var baskets : Array[Area2D]

@onready var music_player: AudioStreamPlayer = %MusicPlayer

@export_group("Win Conditions")
@export var threshold_win : int = 3000

var level_idx : int = 1 # start with level 1

# stats
var stats : Stats = Stats.new()
var time_at_level_start_msec : int = 0

func _ready() -> void:
	assert(levels != null)
	assert(customer_manager != null)
	load_level()


func load_level() -> void:
	UiManager.hide_level_end_ui()
	stats.reset_level_stats()

	# load data
	var level : LevelRes = levels[level_idx - 1] # TODO can be out of bounds
	customer_manager.customer_array = level.customer_array
	FinanceManager.reset_money()

	stats.start_tracking_time()

	## hide/unhide spawn machines and baskets
	enable_utils(washing_machines, level.machine_amount)
	enable_utils(baskets, level.baskset_amount)

	## open day start UI
	var node : Node = level.day_start_scene.instantiate()
	var day_start_UI : DayStartUIController = node as DayStartUIController
	Camera.add_child(day_start_UI)
	
	# start music
	music_player.stream = level.music_stream
	music_player.play()
	
	## start Level
	await day_start_UI.start_day # start button sigal
	customer_manager.timed_customer_iteration()
	

func next_level() -> void:
	level_idx += 1
	if level_idx > len(levels):
		if stats.money_made_total < threshold_win:
			UiManager.show_endscreen_ui("lose")
		else:
			for machine : WashingMashine in get_tree().get_nodes_in_group("WaschingMachine"):
				if machine.opened_flusensieb:
					UiManager.show_endscreen_ui("win")
					return
				else:
					UiManager.show_endscreen_ui("flusensieb")
	else:
		load_level()

func end_current_level() -> void:
	## delete all cloths
	for cloth in get_tree().get_nodes_in_group("Cloth"):
		cloth.queue_free()

	stats.stop_tracking_time()
	stats.add_money_made(FinanceManager.money)

	var level : LevelRes = levels[level_idx - 1]
	stats.add_customers_served(len(level.customer_array))

	## show level end UI
	UiManager.show_level_end_ui(level_idx, stats, threshold_win)

func _on_cm_customer_queue_finshed() -> void:
	end_current_level()

func _on_cloth_finished(cloth: Cloth) -> void:
	stats.add_finished_cloth()
	match cloth.state:
		Cloth.State.soaked: stats.add_soaked_cloth()
		Cloth.State.ripped: stats.add_ripped_cloth()
		Cloth.State.shrunk: stats.add_shrunk_cloth()
		Cloth.State.iced: stats.add_iced_cloth()
		Cloth.State.garn: stats.add_garn_cloth()

func _on_cloth_timedout(_i: CustomerQueueItem) -> void:
	stats.add_timedout_cloth()

func enable_utils(utils : Array[Area2D], amount : int) -> void:
	for i in len(utils):
		var enabled : bool = i <= amount - 1
		utils[i].visible = enabled
		utils[i].monitoring = enabled
		utils[i].monitorable = enabled

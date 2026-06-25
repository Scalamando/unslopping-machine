class_name LevelManager
extends Node2D

@export var levels : Array[LevelRes]

@export_group("refs")
@export var customer_manager : CustomerManager
@export var Camera : Camera2D

@export_group("Spawn Markers")
@export var machine_spawn_markers : Array[Marker2D]
@export var basket_spawn_markers : Array[Marker2D] 

var level_counter : int = 0

func _ready() -> void:
	assert(levels != null)
	assert(customer_manager != null)
	
	load_level(2)


func load_level(level_idx : int) -> void:
	var level : LevelRes = levels[level_idx - 1]
	
	customer_manager.customer_array = level.customer_array
	
	## TODO spawn machines and baskets
	
	## TODO open day start UI
	
	## TODO start Level
	## await start_level_ui - start_day signal 
	customer_manager.timed_customer_iteration()
	pass


func end_current_level() -> void:
	## TODO delete all cloths
	
	## TODO close all UIs
	
	## TODO show Level End UI with stats 
	pass

func _on_cm_customer_queue_finshed() -> void:
	end_current_level()

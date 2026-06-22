class_name CustomerManager
extends Node2D

@export var customer_array : Array[Customer]
@export var cloth_scene : PackedScene
@export var customer_wait_time : int = 45
@export var timed_out_multiplier : float = 0.8

@export_group("Multiplier", "MOD_")
@export_range(0.0, 1, 0.05) var MOD_CLEAN : float = 1.0
@export_range(0.0, 1, 0.05) var MOD_SOAKED : float = 0.9
@export_range(0.0, 1, 0.05) var MOD_RIPPED : float = 0.5
@export_range(0.0, 1, 0.05) var MOD_SHRUNK : float = 0.7
@export_range(0.0, 1, 0.05) var MOD_ICED : float = 0.8
@export_range(0.0, 1, 0.05) var MOD_GARN : float = 0.3
@export_range(0.0, 1, 0.05) var MOD_TIMEOUT : float = 0.5

var time : int = 0
var customer_spawn_counter : int = 0
var customer_queue_array : Array[CustomerQueueItem] = []

signal customer_added(customer : CustomerQueueItem)
signal customer_removed(customer: CustomerQueueItem)

func _ready() -> void:
	assert(cloth_scene != null)
	assert(!customer_array.is_empty())
	timed_customer_iteration()

func timed_customer_iteration() -> void:
	customer_spawn_counter =  0

	for customer : Customer in customer_array:
		var delay : int = customer.timeStamp - time
		await get_tree().create_timer(delay).timeout

		spawn_customer(customer)
		customer_spawn_counter += 1

func spawn_customer(customer : Customer) -> void:
	var cloth_node : Cloth = Cloth.create(customer.clothing, customer)
	add_child(cloth_node)

	var customer_queue_item : CustomerQueueItem = CustomerQueueItem.new(customer, customer_wait_time)
	customer_queue_array.append(customer_queue_item)
	customer_added.emit(customer_queue_item)

func _on_finished_clothing(cloth: Cloth) -> void:
	for item in customer_queue_array:
		if item.customer == cloth.customer:
			var value : float = float(cloth.clothing.value) # TODO: Replace with customer specific value
			match cloth.clothing.state:
				Clothing.State.clean: value *= MOD_CLEAN
				Clothing.State.soaked: value *= MOD_SOAKED
				Clothing.State.ripped: value *= MOD_RIPPED
				Clothing.State.shrunk: value *= MOD_SHRUNK
				Clothing.State.iced: value *= MOD_ICED
				Clothing.State.garn: value *= MOD_GARN

			if item.timeout_at_msec < Time.get_ticks_msec():
				value *= MOD_TIMEOUT

			FinanceManager.add_money(ceil(value))

			customer_removed.emit(item)

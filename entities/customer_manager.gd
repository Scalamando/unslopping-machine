class_name CustomerManager
extends Node2D

@export var customer_array : Array[Customer]
@export var cloth_scene : PackedScene
@export var customer_wait_time : int = 45
@export var timed_out_multiplier : float = 0.8

var time : int = 0
var customer_spawn_counter : int = 0

signal customer_added(customer : CustomerQueueItem)

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
	var cloth_node : Cloth = Cloth.create(customer.clothing)
	add_child(cloth_node)

	var customer_queue_item : CustomerQueueItem = CustomerQueueItem.new(customer, customer_wait_time)
	customer_added.emit(customer_queue_item)

func _on_customer_timed_out(customer: CustomerQueueItem) -> void:
	pass # Replace with function body.

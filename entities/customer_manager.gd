class_name CustomerManager
extends Node2D

var customer_array : Array[CustomerProfile]
@export var cloth_scene : PackedScene
## The time customers will wait for their clothes to be washed. Incurs a penalty if the time is up
@export var customer_wait_time : int = 45
## The offset between customers, when multiple customers are present in the queue
@export var customer_offset : Vector2 = Vector2(-20.0, 0.0)

@export_group("Multiplier", "MOD_")
## Money modifier applied for clean cloths.
@export_range(-1, 1, 0.05) var MOD_CLEAN : float = 1.0
## Money modifier applied for soaked cloths.
@export_range(-1, 1, 0.05) var MOD_SOAKED : float = 0.9
## Money modifier applied for ripped cloths.
@export_range(-1, 1, 0.05) var MOD_RIPPED : float = 0.5
## Money modifier applied for shrunk cloths.
@export_range(-1, 1, 0.05) var MOD_SHRUNK : float = 0.7
## Money modifier applied for iced cloths.
@export_range(-1, 1, 0.05) var MOD_ICED : float = 0.8
## Money modifier applied for cloths that got torn to garn.
@export_range(-1, 1, 0.05) var MOD_GARN : float = 0.3
## Money modifier applied for cloths that did not finsh in time.
@export_range(-1, 1, 0.05) var MOD_TIMEOUT : float = 0.5

var time : int = 0
var customer_spawn_counter : int = 0
var customer_queue_array : Array[CustomerQueueItem] = []

signal customer_added(customer : CustomerQueueItem)
signal customer_removed(customer: CustomerQueueItem)

signal customer_queue_finshed()

func _ready() -> void:
	assert(cloth_scene != null)

	self.child_entered_tree.connect(_on_customer_count_changes)
	self.child_exiting_tree.connect(_on_customer_count_changes)

func timed_customer_iteration() -> void:
	assert(!customer_array.is_empty())
	
	customer_spawn_counter =  0

	for customer : CustomerProfile in customer_array:
		var delay : int = customer.timeStamp - time
		await get_tree().create_timer(delay).timeout

		spawn_customer(customer)
		customer_spawn_counter += 1
	
	await get_tree().create_timer(customer_wait_time).timeout ## wait for the last customer to finsh
	customer_queue_finshed.emit()

func spawn_customer(customer : CustomerProfile) -> void:
	var customer_node : Customer = Customer.create(customer)
	add_child(customer_node)
	customer_node.global_position = self.global_position + customer_offset * (get_child_count() - 1)

	var customer_queue_item : CustomerQueueItem = CustomerQueueItem.new(customer, customer_wait_time)
	customer_queue_array.append(customer_queue_item)
	customer_added.emit(customer_queue_item)

func _on_customer_count_changes(node: Node) -> void:
	if node is Customer:
		var i : int = 0
		for child : Node in get_children().filter(func(c: Node) -> bool: return c is Customer and not is_same(c, node)):
			create_tween().set_trans(Tween.TRANS_SINE).tween_property(child, "global_position", self.global_position + customer_offset * i, 0.5)
			i += 1

func _on_finished_clothing(cloth: Cloth) -> void:
	for item in customer_queue_array:
		if item.customer == cloth.customer:
			var value : float = float(cloth.clothing.value) # TODO: Replace with customer specific value
			match cloth.state:
				Cloth.State.clean: value *= MOD_CLEAN
				Cloth.State.soaked: value *= MOD_SOAKED
				Cloth.State.ripped: value *= MOD_RIPPED
				Cloth.State.shrunk: value *= MOD_SHRUNK
				Cloth.State.iced: value *= MOD_ICED
				Cloth.State.garn: value *= MOD_GARN

			if item.timeout_at_msec < Time.get_ticks_msec():
				value *= MOD_TIMEOUT

			FinanceManager.add_money(ceil(value))

			customer_removed.emit(item)

extends Node2D

@export var customer_array : Array[Customer]
@export var cloth_scene : PackedScene
var time : int = 0

func _ready() -> void:

	assert(cloth_scene != null)
	assert(!customer_array.is_empty())

	spawn_customers()


func spawn_customers() -> void:
	for customer : Customer in customer_array:
		var delay : int = customer.timeStamp - time
		await get_tree().create_timer(delay).timeout

		var cloth_node : Cloth = cloth_scene.instantiate() as Cloth
		cloth_node.load_data(customer.clothing)
		add_child(cloth_node)

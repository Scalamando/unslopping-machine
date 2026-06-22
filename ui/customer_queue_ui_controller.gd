class_name CustomerQueue
extends HBoxContainer

signal customer_timed_out(customer: CustomerQueueItem)

#TODO add Items on CustomerManager.active_customer_queue : Signal
#TODO update all items time (CustomerItemUI.on_time_updated()) in CustomerManger.time_updated : Signal

func _on_customer_added(customer: CustomerQueueItem) -> void:
	var customer_item : CustomerItemUI = CustomerItemUI.create(customer)
	customer_item.timeout.connect(func() -> void: customer_timed_out.emit(customer))
	add_child(customer_item)

class_name CustomerQueueItem

var customer : CustomerProfile
var timeout_at_msec : int

func _init(customer_ : CustomerProfile, start_time : int) -> void:
	customer = customer_
	timeout_at_msec = Time.get_ticks_msec() + (start_time * 1000)

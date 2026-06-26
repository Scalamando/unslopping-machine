class_name Stats

var finished_cloth : int = 0
var timedout_cloth : int = 0
var customers_served : int = 0
var customers_served_total : int = 0
var money_made : int = 0
var money_made_total : int = 0
var _time_start_msec : int = 0
var time_used_msec : int = 0

func add_finished_cloth() -> void:
	finished_cloth += 1

func add_timedout_cloth() -> void:
	timedout_cloth += 1

func add_customers_served(count: int) -> void:
	customers_served = count
	customers_served_total += count

func add_money_made(amount: int) -> void:
	money_made = amount
	money_made_total += amount

func start_tracking_time() -> void:
	_time_start_msec = Time.get_ticks_msec()

func stop_tracking_time() -> void:
	time_used_msec = Time.get_ticks_msec() - _time_start_msec

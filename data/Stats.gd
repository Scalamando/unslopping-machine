class_name Stats

var finished_cloth : int = 0
var finished_cloth_total : int = 0
var timedout_cloth : int = 0
var timedout_cloth_total : int = 0
var cloth_soaked : int = 0
var cloth_soaked_total : int = 0
var cloth_ripped : int = 0
var cloth_ripped_total : int = 0
var cloth_iced : int = 0
var cloth_iced_total : int = 0
var cloth_shrunk : int = 0
var cloth_shrunk_total : int = 0
var cloth_garn : int = 0
var cloth_garn_total : int = 0
var customers_served : int = 0
var customers_served_total : int = 0
var money_made : int = 0
var money_made_total : int = 0
var _time_start_msec : int = 0
var time_used_msec : int = 0

func add_finished_cloth() -> void:
	finished_cloth += 1
	finished_cloth_total += 1

func add_timedout_cloth() -> void:
	timedout_cloth += 1
	timedout_cloth_total += 1

func add_soaked_cloth() -> void:
	cloth_soaked += 1
	cloth_soaked_total += 1

func add_ripped_cloth() -> void:
	cloth_ripped += 1
	cloth_ripped_total += 1

func add_iced_cloth() -> void:
	cloth_iced += 1
	cloth_iced_total += 1

func add_shrunk_cloth() -> void:
	cloth_shrunk += 1
	cloth_shrunk_total += 1

func add_garn_cloth() -> void:
	cloth_garn += 1
	cloth_garn_total += 1

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

func reset_level_stats() -> void:
	finished_cloth = 0
	timedout_cloth = 0
	cloth_soaked = 0
	cloth_ripped = 0
	cloth_shrunk = 0
	cloth_iced = 0
	cloth_garn = 0
	customers_served = 0
	money_made = 0
	time_used_msec = 0

extends Node

var money : int = 0
signal money_updated(money : int)

func add_money(amount : int) -> void:
	money += amount
	money_updated.emit(money)
	
func reset_money() -> void:
	money = 0
	money_updated.emit(money)

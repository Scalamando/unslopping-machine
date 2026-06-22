extends PanelContainer
@onready var money_label: Label = %Money

func _ready() -> void:
	FinanceManager.money_updated.connect(_on_money_updated)

func _on_money_updated(new_amount : int) -> void:
	money_label.text = str(new_amount)

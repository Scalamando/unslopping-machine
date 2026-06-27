extends Area2D


func _on_drop_zone_drop_applied(_zone: DropZone, area: Area2D, _plan: DropPlan) -> void:
	display_cloth(area)


func _on_drop_zone_drop_rejected(_zone: DropZone, area: Area2D, _plan: DropPlan) -> void:
	display_cloth(area)

func display_cloth(area : Area2D) -> void:
	if (area is not Cloth):
		return;

	var cloth : Cloth = area as Cloth
	UiManager.show_inspection_tresen(cloth.clothing)

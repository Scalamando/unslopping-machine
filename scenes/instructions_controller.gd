extends Area2D

var hovering := false
@onready var instructions: Sprite2D = %Instructions

func _on_mouse_entered() -> void:
	hovering = true
	scale_delay()

func _on_mouse_exited() -> void:
	instructions.visible = false
	hovering = false

func scale_delay() -> void:
	await get_tree().create_timer(0.5).timeout
	
	if (hovering == false) :
		return 
	
	instructions.visible = true

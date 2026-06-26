class_name Highlightable
extends Control

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_enter)
	self.mouse_exited.connect(_on_mouse_exit)

func _on_mouse_enter() -> void:
	self.modulate = Color(1.1, 1.1, 1.1, 1)

func _on_mouse_exit() -> void:
	self.modulate = Color(1, 1, 1, 1)

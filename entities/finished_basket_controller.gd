class_name FinishedBasket
extends Area2D

signal finished_clothing(cloth: Cloth)

@onready var cloth_container: Node2D = %ClothContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cloth_container.child_entered_tree.connect(_on_new_node)

func _on_new_node(node: Node) -> void:
	if node is Cloth:
		if node.clothing.state == Cloth.State.dirty: return
		finished_clothing.emit(node)
		node.queue_free()

class_name Customer
extends Node2D

const customer_scene = preload("res://entities/customer.tscn")

@onready var customer_sprite_2d: Sprite2D = %CustomerSprite2D
@onready var cloth_marker_2d: Marker2D = %ClothMarker2D
@onready var cloth_container: Node2D = %ClothContainer

var texture : Texture
var cloth: Cloth

static func create(profile: CustomerProfile) -> Customer:
	var new_customer : Customer = customer_scene.instantiate()
	new_customer.texture = profile.texture

	var new_cloth : Cloth = Cloth.create(profile.clothing, profile)
	new_customer.cloth = new_cloth

	return new_customer

func _ready() -> void:
	customer_sprite_2d.texture = texture
	cloth.position = cloth_marker_2d.position
	cloth_container.add_child(cloth)

	cloth_container.child_exiting_tree.connect(_on_cloth_removed)

func _on_cloth_removed(node: Node) -> void:
	if node is Cloth:
		await get_tree().create_timer(0.25).timeout
		if cloth_container.get_child_count() > 1: return # dont allow customer to despawn with cloth
		queue_free()

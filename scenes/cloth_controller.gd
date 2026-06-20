class_name Cloth
extends Area2D
@onready var sprite_2d: Sprite2D = %Sprite2D

var cloth_data : Clothing

func load_data(cloth : Clothing) -> void:
	cloth_data = cloth

func _ready() -> void:
	sprite_2d.texture = cloth_data.folded_texture

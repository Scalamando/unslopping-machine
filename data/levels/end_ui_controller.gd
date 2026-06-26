class_name EndUI
extends Control

@onready var postcard: Sprite2D = %Postcard

@export var postcard_lose : Texture2D
@export var postcard_flusensieb : Texture2D
@export var postcard_win : Texture2D

func _ready() -> void:
	UiManager.end_ui = self

func init(type: String) -> void:
	assert(type in ["win", "flusensieb", "lose"])
	match type:
		"lose": postcard.texture = postcard_lose
		"flusensieb": postcard.texture = postcard_flusensieb
		"win": postcard.texture = postcard_win

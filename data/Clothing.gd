class_name Clothing
extends Resource

@export var wash_instructions : WaschingInstruction

@export_range(0, 200, 1) var value : int = 50

@export_group("Textures", "texture_")
@export var texture_dirty : Texture
@export var texture_clean : Texture
@export var texture_soaked : Texture
@export var texture_ripped : Texture
@export var texture_shrunk : Texture
@export var texture_iced : Texture
@export var texture_garn : Texture
@export var texture_spread_out : Texture

@export var spread_out_scene : PackedScene

class_name Clothing
extends Resource

enum State {dirty, clean, ripped, shrunk, iced, garn} 

@export var folded_texture : Texture
@export var spread_out_scene : PackedScene
@export var wash_instructions : WaschingInstruction

var state : State = State.dirty

class_name WaschingInstruction
extends Resource

enum Direction {clockwise, counterclockwise, none}
enum Temperature {cold = 10, medium = 30, hot = 120}

@export var speed : int
@export var temperature : Temperature = 30 as Temperature
@export var direction : Direction

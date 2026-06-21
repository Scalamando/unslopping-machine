class_name WaschingInstruction
extends Resource

enum Direction {clockwise, counterclockwise, both}
enum Temperature {cold = 10, medium = 30, hot = 120}
enum Speed {slow = 800 , medium = 1600, fast = 4000} # lower end of the range

@export var speed : Speed = 800 as Speed
@export var temperature : Temperature = Temperature.hot
@export var direction : Direction

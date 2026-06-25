class_name WaschingInstruction
extends Resource

enum Direction {clockwise, counterclockwise, both}
enum Temperature {cold = 10, medium = 30, hot = 120}
enum Speed {slow = 350 , medium = 1100, fast = 1950, too_fast = 2750} # lower end of the ranges - max: 3000

@export var speed : Speed = Speed.slow
@export var temperature : Temperature = Temperature.hot
@export var direction : Direction = Direction.both

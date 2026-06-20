extends Camera2D

@export var cameraPosLeftRoom : Vector2
@export var cameraPosRightRoom : Vector2

const CAMERA_SPEED : float = 7.0
var targetPos : Vector2

func _process(delta: float) -> void:
	var weight = 1 - exp(-CAMERA_SPEED * delta)
	position = position.lerp(targetPos, weight)

func _input(event):
	
	if event.is_action_pressed("move_left_room"):
		targetPos = cameraPosLeftRoom
	elif event.is_action_pressed("move_right_room"):
		targetPos = cameraPosRightRoom
